
# Get the GH issues for DDG repos
#
use JSON;
use DBI;

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

# get the GH issues 
sub getIssues{
	foreach my $repo (@repos){
		$json->{$repo} = decode_json(`curl --silent https://api.github.com/repos/duckduckgo/$repo/issues?status=current`);
		
		# add all the data we care about to an array 
		for my $issue ( @{$json->{$repo}} ){
			
			# get the IA name from the link in the first comment
			# Update this later for whatever format we decide on
			if($issue->{'body'} =~ /code:(\s)?http(s)?\:\/\/(.*)\/(.*)/i){
				my $link = $4;
			}
			
			# remove special chars from title and body
			$issue->{'body'} =~ s/\'//g;
			$issue->{'title'} =~ s/\'//g;

			# get repo name
			$repo =~ s/zeroclickinfo-//;
			
			# add entry to result array
			my @entry = (
				$link // 'null', 
				$repo // 'null', 
				$issue->{'number'} // 'null', 
				$issue->{'title'} // 'null', 
				$issue->{'body'} // 'null', 
				$issue->{'tags'} // 'null', 
				$issue->{'created_at'} // 'null'
			);

			push(@results, \@entry);
		}
	}
}

sub updateDB{
	$dbh = DBI->connect('dbi:SQLite:github', 'root', '');

	# drop table
	$sql = 'drop table if exists gh_issues';
	$stmt = $dbh->prepare($sql);
	$stmt->execute();
	
	# create
	$sql = 'create table gh_issues (name text, repo text, issue integer, title text, body text, tags text, created text)';
	$stmt = $dbh->prepare($sql);
	$stmt->execute();

	# insert
	foreach (@results){
		$sql = qq(insert into gh_issues values('@$_[0]','@$_[1]','@$_[2]','@$_[3]','@$_[4]','@$_[5]','@$_[6]'));
		$stmt = $dbh->prepare($sql);
		$stmt->execute();
	}

	$dbh->disconnect();
}

getIssues;

updateDB;

