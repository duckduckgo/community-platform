#!/usr/bin/env perl
# Get the GH issues for DDG repos
#
#
use strict;
use warnings;
use FindBin;
use lib $FindBin::Dir . "/../lib";
use JSON;
use DDGC;
use HTTP::Tiny;
use Data::Dumper;
use Try::Tiny;
use Net::GitHub::V3;
use Time::Local;
use Term::ProgressBar;
use Date::Parse;
use Time::Piece;
use Time::Seconds;

my $d = DDGC->new;

BEGIN {
    $ENV{DDGC_IA_AUTOUPDATES} = 1;
}

# JSON response from GH API
my %json;

# results to go into DB
# |IA name|Repo|Issue#|title|Body|tags|created at|
my @results;

# the repos we care about
my @repos = (
    'zeroclickinfo-spice',
    'zeroclickinfo-goodies',
    'zeroclickinfo-longtail',
    'zeroclickinfo-fathead'
);

my $token = $ENV{DDGC_GITHUB_TOKEN} || $ENV{DDG_GITHUB_BASIC_OAUTH_TOKEN};
my $gh = Net::GitHub->new(access_token => $token);


my $today = localtime;
# get last days worth of issues
my $since = $today - (1 * ONE_DAY);

# get the GH issues
sub getIssues{
    foreach my $repo (@repos){
        my $line = 1;
        my @issues = $gh->issue->repos_issues('duckduckgo', $repo, {
                state => 'all',
                since => $since->datetime
            }
        );

        while($gh->issue->has_next_page){
            push(@issues, $gh->issue->next_page)
        }

        print "Starting $repo\n";
        my $progress = Term::ProgressBar->new(scalar @issues);
		
        # add all the data we care about to an array
		for my $issue (@issues){
            $progress->update($line);
            $line++;

            # get the IA name from the link in the first comment
			# Update this later for whatever format we decide on
			my $name_from_link = '';
            ($name_from_link) = $issue->{'body'} =~ /https?:\/\/duck\.co\/ia\/view\/(\w+)/i;

            # remove special chars from title and body
			$issue->{'body'} =~ s/\'//g;
			$issue->{'title'} =~ s/\'//g;

			# get repo name
			$repo =~ s/zeroclickinfo-//;

            my $is_pr = exists $issue->{pull_request} ? 1 : 0;

            # get last commit and user info
            my $last_commit;
            $last_commit = get_last_commit($repo, $issue->{number}) if $is_pr;

            # get last comment
            my $comments;
            $comments = get_comments($repo, $issue->{number}) if $is_pr;
            my $last_comment = $comments->[-1] if $comments;

            my $mentions = get_mentions($last_comment->{text}) if $last_comment;
            
            $comments = to_json $comments if $comments;
            $last_comment = to_json $last_comment if $last_comment;

            my $producer = assign_producer($issue->{assignee}->{login});

            my $state = $issue->{state};
            if ($state ne 'open') {
                $state = $gh->pull_request->is_merged('duckduckgo','zeroclickinfo-'.$repo, $issue->{number})? 'merged' : $state;
            }

            # add entry to result array
			my %entry = (
			    name => $name_from_link || '',
				repo => $repo || '',
				issue_id => $issue->{'number'} || '',
                author => $issue->{user}->{login} || '', 
				title => $issue->{'title'} || '',
				body => $issue->{'body'} || '',
				tags => $issue->{'labels'} || '',
				date => $issue->{'created_at'} || '',
                is_pr => $is_pr,
                last_update => $issue->{updated_at},
                last_commit => $last_commit,
                last_comment => $last_comment,
                all_comments => $comments,
                mentions => $mentions,
                producer => $producer,
                state => $state,
			);

			push(@results, \%entry);
            
            my $create_page = sub {
                my $data = \%entry;
                return unless $data->{name};

                # check to see if we have this IA already
                # First lookup by ID.  This can fail if an admin updates the ID on the IA page later
                my $ia = $d->rs('InstantAnswer')->search( {
                    -or => [
                        id => $data->{name},
                        meta_id => $data->{name},
                    ]
                } )->hri->one_row;
                my $new_ia = 1 if !$ia;

                # no auto generating IA pages from a PR anymore
                return unless $ia;

                my @time = localtime(time);
                my ($month, $day, $year) = ($time[4]+1, $time[3], $time[5]+1900);
                my $date = "$month/$day/$year";

                $data->{body} =~ s/\n|\r//g;

                # get the file info for the pr
                $gh->set_default_user_repo('duckduckgo', "zeroclickinfo-$data->{repo}");
                my $pr = $gh->pull_request->pull($data->{issue_id});
                my @files_data = $gh->pull_request->files($data->{issue_id});

                my $template = find_template(\@files_data);

                my $pm;
                # look for the perl module
                for my $file (@files_data){
                    my $tmp_repo = ucfirst $data->{repo};
                    $tmp_repo =~ s/s$//g;

                    if(my ($name) = $file->{filename} =~ /lib\/DDG\/$tmp_repo\/(.+)\.pm/i ){
                        my @parts = split('/', $name);
                        $name = join('::', @parts);
                        $pm = "DDG::".$tmp_repo."::$name";
                        last;
                    }
                }

                my $is_new_ia;
                for my $tag (@{$data->{tags}}){
                    $is_new_ia = 1 if $tag->{name} eq 'New Instant Answer';
                    $pm = "DDG::Goodie::CheatSheets" if $tag->{name} eq 'CheatSheet';
                }

                my $developer = [{
                        name => $data->{author},
                        type => 'github',
                        url => "https://github.com/$data->{author}"
                    }];
                $developer = to_json $developer;

                my $name = $data->{name};
                $name =~ s/_/ /g;

                # move status to development once we have seen the PR
                my $dev_milestone;
                if($ia->{dev_milestone} eq 'planning'){
                    $dev_milestone = 'development';
                }

                my %new_data = (
                    id => $ia->{id} || $data->{name},
                    meta_id => $ia->{meta_id} || $data->{name},
                    name => $ia->{name} || ucfirst $name,
                    dev_milestone => $dev_milestone || $ia->{dev_milestone},
                    description => $ia->{description},
                    created_date => $ia->{created_date} || $date, 
                    repo => $ia->{repo} || $data->{repo},
                    perl_module => $ia->{perl_module} || $pm,
                    forum_link => $ia->{forum_link},
                    src_api_documentation => $ia->{src_api_documentation},
                    developer => $ia->{developer} || $developer,
                    last_update => $issue->{updated_at},
                    last_commit => $data->{last_commit},
                    last_comment => $data->{last_comment},
                    all_comments => $data->{all_comments},
                    at_mentions => $data->{mentions},
                    producer => $data->{producer},
                    template => $template,
                    example_query => $ia->{example_query} || '',
                    tab => $ia->{tab} || '',
                    src_url => $ia->{src_url} || '',
                    public => 1
                );

                update_pr_template(\%new_data, $data->{issue_id}, $ia);

                #return 1 if !$is_new_ia;
                $d->rs('InstantAnswer')->update_or_create({%new_data});


            };

            # check for an existing IA page.  Create one if none are found
            try {
                $d->db->txn_do($create_page) if $is_pr;
            } catch {
                print "Update error $_ \n rolling back\n";
                $d->errorlog("Error updating ghIssues: '$_'...");
            }


		}
	}
    # warn Dumper @results;
    # warn Dumper %pr_hash;
}

sub get_last_commit {
    my ($repo, $issue) = @_;
    my $pulls = $gh->pull_request;
    my @commits = $pulls->commits('duckduckgo', "zeroclickinfo-$repo", $issue);
    my $commit = pop @commits;

    return unless $commit;

    my $gh_user = $commit->{commit}->{committer}->{name};
    my $result = duckco_user($gh_user);
    my $last_commit = { 
        diff => $commit->{html_url}, 
        user => $gh_user,
        duckco => $result->{gh_user},
        admin => $result->{admin},
        comleader => $result->{comleader},
        date => $commit->{commit}->{committer}->{date},
        message => $commit->{commit}->{message},
        issue_id => $issue
    };

    return to_json $last_commit;
}

sub get_comments {
    my ($repo, $issue) = @_;
    my $issues = $gh->issue;
    my @comments = $issues->comments('duckduckgo', "zeroclickinfo-$repo", $issue);

    # get the diff comments
    my @diff_comments = $gh->pull_request->comments('duckduckgo', "zeroclickinfo-$repo", $issue);

    my @all_comments = (@comments, @diff_comments);

    # sort comments by time
    my @sorted = sort { str2time($a->{created_at}) <=> str2time($b->{created_at}) } @all_comments;

    my $formatted_comments;
    foreach my $comment (@sorted){
 
    my $gh_user = $comment->{user}->{login};
    my $result = duckco_user($gh_user);
    push(@$formatted_comments,
            { 
                user => $gh_user,
                duckco => $result->{user},
                admin => $result->{admin},
                comleader => $result->{comleader},
                date => $comment->{created_at},
                text => $comment->{body},
                id => $comment->{id}
            });
    }

    return $formatted_comments;
}

sub duckco_user {
    my ($gh_user) = @_;

    my $user = $d->rs('User')->find_by_github_login( $gh_user );
    my $admin = 0;
    my $comleader = 0;
    my $username;

    if ($user) {
        $username = $user->username;
        $admin = $user->admin;
        $comleader = 0;
        #$user->is('community_leader');
    }

    my %result = (
        user => $username,
        admin => $admin,
        comleader => $comleader
    );

    return \%result;
}

# check the status of PRs in $pr_hash.  If they were merged
# then update the file paths in the db
sub merge_files {
    my ($data, $issue_id) = @_;
        $gh->set_default_user_repo('duckduckgo', "zeroclickinfo-".$data->repo);
        my $pr;
        try{
            $pr = $gh->pull_request->pull($issue_id);
        }catch{
        };

        return unless $pr;

        # closed PRs have undef merged_at.  Merged ones have the date
        return unless $pr->{merged_at};
        
        my @files_changed = $gh->pull_request->files($issue_id);

        my @files;
        map{ push(@files, $_->{filename}) } @files_changed;

        #update code in db
        my $result = $d->rs('InstantAnswer')->find({id => $data->id});
        $result->update({code => JSON->new->ascii(1)->encode(\@files)}) if $result;
}

my $update = sub {
    #$d->rs('InstantAnswer::Issues')->delete_all();

    foreach my $result (@results){
        # check if the IA is in our table so we dont die on a foreign key error

        my $ia = $d->rs('InstantAnswer')->search( {
            -or => [
                id => $result->{name},
                meta_id => $result->{name},
            ]
        } )->one_row;
 
        if(exists $result->{name} && $ia){
            $d->rs('InstantAnswer::Issues')->update_or_create({
                instant_answer_id => $ia->id,
                repo => $result->{repo},
                issue_id => $result->{issue_id},
                title => $result->{title},
                body => $result->{body},
                tags => $result->{tags},
                is_pr => $result->{is_pr},
                date => $result->{date},
                author => $result->{author},
                status => $result->{state},
	        });

        }

        merge_files($ia, $result->{issue_id}) if $ia;
    }
};

sub assign_producer {
    my ($gh_user) = @_;

    # all IAs must have a producer - temporary fallback
    my @producers = ('Moollaza', 'Jag');
    return $producers[int(rand(@producers))] unless $gh_user;

    # look for linked duck.co account
    my $user = $d->rs('User')->find_by_github_login( $gh_user );

    if ($user && $user->admin) {
        $gh_user = $user->username;
    } else {
        # If no linked account found, we can't be sure whether 
        # the user is an admin or not.
        # But producers can only be admins, so use the temporary fallback
        $gh_user = $producers[int(rand(@producers))];
    }

    return $gh_user;
}

sub find_template {
    my ($files) = @_;

    return unless $files;

    foreach my $file_data (@$files){
        next unless exists $file_data->{patch};
        # goodies templats
        my ($template) = $file_data->{patch} =~ /group =>\s?(?:'|")([[:alpha:]]+)(?:'|")/;
        return lc $template if $template;
        # spice templates
        ($template) = $file_data->{patch} =~ /group:\s?(?:'|")([[:alpha:]]+)(?:'|")/;
        return lc $template if $template;
    }
}

sub get_mentions {
    my ($comment) = @_;

    # remove github inline comment blocks
    $comment =~ s/^>.+\n//g;
    my @mentions = $comment =~ /@(\w+)/g;

    my $duck_users;
    # get duck.co id for each
    foreach my $gh_user (@mentions){
        my $user = $d->rs('User')->find_by_github_login( $gh_user );
        
        if($user){
            push(@$duck_users, {name => $user->username} );
        }
    }

    if($duck_users){
        return to_json $duck_users;
    }
}

sub update_pr_template {
    my ($data, $pr_number, $ia) = @_;

    # XXX comment this line to test pr template posts
    # it will make actual posts to GitHub PRs.
    return unless $d->is_live;

    # find dax comment at spot #1 or bail
    my @comments = $gh->issue->comments($pr_number);

    my $comment_number;
    my $old_comment = '';
    if(scalar @comments){
        my $comment = $comments[0];
        return unless $comment->{user}->{login} eq 'daxtheduck';

        # skip dax welcome message if it exists
        if($comment->{body} =~ /Thanks for taking the time to contribute!/){
            if(scalar @comments > 1){
                $comment = $comments[1];
                return unless $comment->{user}->{login} eq 'daxtheduck';
                $comment_number = $comment->{id};
            }
        }else{
            $comment_number = $comment->{id};
            $old_comment = $comment->{body};
        }
    }


    my $examples = $data->{example_query} || ' ';

    if(defined $ia->{other_queries}){
        $ia->{other_queries} =~ s/"|\[|\]//g;
        $ia->{other_queries} =~ s/,/, /g;
        $examples .=", ". $ia->{other_queries};
    }

    my $browsers;
    foreach my $browser (qw(safari firefox ie opera chrome)){
        my $val = $ia->{"browsers_$browser"};
        if($val){
            $val = 'X';
        }else{
            $val = ' ';
        }
        $browsers .= '- ['.$val.'] ' . $browser. "\n";
    }

    my $mobile;
    foreach my $type (qw(android ios)){
        my $val = $ia->{"mobile_$type"};
        if($val){
            $val = 'X';
        }else{
            $val = ' ';
        }
        $mobile .= '- ['.$val.'] '. $type. "\n";
    }

    map{ $data->{$_} = ' ' unless $data->{$_} } qw(src_url description tab);

    if($data->{repo} =~ /fathead/i){
        $data->{tab} = "About";
    }elsif($data->{repo} =~ /goodie/i){
        $data->{tab} = "Answer";
    }

    my $message = qq(
## Instant Answer Metadata from [IA page](https://duck.co/ia/view/$data->{meta_id})

**Description**: $data->{description}

**Example Query**: $examples

**Tab Name**: $data->{tab}

**Source**: $data->{src_url}

*These are the important fields from the IA page.  Please check these for errors or missing information and update the [IA page](https://duck.co/ia/view/$data->{meta_id})*

---
**Testing**

**Browsers**
$browsers

**Mobile**
$mobile

---
*This is an automated message which will be updated as changes are made to the [IA page](https://duck.co/ia/view/$data->{meta_id})*
);
    # check to see if anything has been updated since the last post
    # remove white space and testing block of the comment.  Testing
    # has markdown clickable check boxes that we don't want to compare.
    my $tmp_message = $message;
    for ($tmp_message, $old_comment){
        $_ =~ s/\s//g;
        $_ =~ s/\*\*Testing\*\*.*$//g;
    }
    return if $tmp_message eq $old_comment;

    my $dax = $ENV{DAX_TOKEN};
    return unless $dax;

    warn "Posting comment";
    my $dax_comment = Net::GitHub->new(access_token => $dax);
    if(!$comment_number){
        # update the comment
        $dax_comment->issue->create_comment('duckduckgo', 'zeroclickinfo-'.$data->{repo}, $pr_number, {
            "body" => $message
            }
        );
    }else{
        $dax_comment->issue->update_comment('duckduckgo', 'zeroclickinfo-'.$data->{repo}, $comment_number, {
            "body" => $message
            }
        );
    }
}

getIssues;

try {
    $d->db->txn_do($update);
} catch {
    print "Update error $_ \n rolling back\n";
    $d->errorlog("Error updating ghIssues: '$_'...");
}
