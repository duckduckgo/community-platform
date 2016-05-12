use strict;
use warnings;

# Database setup
BEGIN {
    $ENV{DDGC_DB_DSN} = 'dbi:SQLite:dbname=ddgc_test.db';
}

use Test::More;
use Test::WWW::Mechanize::PSGI;
use t::lib::DDGC::TestUtils;
use HTTP::Request::Common;
use Plack::Test;
use Plack::Builder;
use Plack::Session::State::Cookie;
use Plack::Session::Store::File;
use File::Temp qw/ tempdir /;
use File::Path qw/ make_path remove_tree /;
use JSON::MaybeXS qw/:all/;
use URI;
use DDH::UserPage::Gather;
use DDH::UserPage::Generate;

use DDGC;
use DDGC::Web;

my $userpage_out = $ENV{HOME} . "/ddgc/test-ddh-userpages";

my $d = DDGC->new;
t::lib::DDGC::TestUtils::deploy( undef, $d->db );

# Application setup and creation
my $app = builder {
    enable 'Session',
        store => Plack::Session::Store::File->new(
            dir => tempdir,
        ),
        state => Plack::Session::State::Cookie->new(
            secure => 0,
            httponly => 1,
            expires => 21600,
            session_key => 'ddgc_session',
        );
    mount '/testutils' => t::lib::DDGC::TestUtils->to_app;
    mount '/' => DDGC::Web->new->psgi_app;
};

# Tests - assert things here
test_psgi $app => sub {
    my ( $cb ) = @_;

    my $get_repo_json = sub {
        my $opts = shift;
        my $repo = $opts->{repo} || 'all';
        my $u = URI->new("/ia/repo/$repo/json");
        $u->query_form( all_milestones => $opts->{all_milestones} || 0 );

        my $ia_repo_json_request = $cb->( GET $u->canonical );
        ok( $ia_repo_json_request->is_success, "Can retrieve $repo JSON" );
        return decode_json( $ia_repo_json_request->decoded_content );
    };

    my $get_action_token = sub {
        my $action_token = $cb->(
            GET '/testutils/action_token',
            Cookie => shift,
        )->decoded_content;
        ok( $action_token && !ref $action_token, 'Have a CSRF token scalar' );
        return $action_token;
    };

    my $set_ia_value = sub {
        my $opts = shift;
        my $cookie = delete $opts->{cookie};
        my ( $field, $value ) = each $opts;
        my $ia_update_request = $cb->(
            POST '/ia/save',
            Cookie  => $cookie,
            Content => [
                id           => 'test_ia',
                field        => $field,
                value        => $value,
                autocommit   => 1,
                action_token => $get_action_token->( $cookie ),
            ],
        );
        ok( $ia_update_request->is_success, 'IA update request returns 200' );
        return decode_json( $ia_update_request->decoded_content )->{result};
    };

    # Create user
    my $user_request = $cb->(
        POST '/testutils/new_user',
        { username => 'ia_user' }
    );
    ok( $user_request->is_success, 'Creating an IA user' );

    # Get session
    my $session_request = $cb->(
        POST '/testutils/user_session',
        { username => 'ia_user' }
    );
    ok( $session_request->is_success, 'Getting IA user Cookie' );
    my $cookie = 'ddgc_session=' . $session_request->content;

    # Create an IA
    my $new_ia_req = $cb->(
        POST '/ia/create',
        Cookie          => $cookie,
        Content         => [ data => encode_json( {
            id            => 'test_ia',
            name          => 'Test IA',
            description   => 'This is a test IA',
            example_query => 'testing IAs',
            repo          => 'longtail',
            action_token  => $get_action_token->( $cookie ),
        } ) ],
    );
    ok( $new_ia_req->is_success, 'Creating IA' );

    # Find IA
    my $ia = $d->rs('InstantAnswer')->find('test_ia');
    ok( $ia, 'Query returns something' );
    isa_ok( $ia, 'DDGC::DB::Result::InstantAnswer' );

    # Check all_milestones JSON (should have everything)
    my $ia_repo = $get_repo_json->({ repo => 'longtail', all_milestones => 1 });
    is( ref $ia_repo->{test_ia}, 'HASH', 'Test IA is in all milestone repo JSON' );

    # "Approve" IA
    my $ia_approve_result = $set_ia_value->({ cookie => $cookie, public => 1 });
    is( $ia_approve_result->{saved}, 1, 'IA "Approve" was successful' );

    # This forces a re-select from the db - see: https://metacpan.org/pod/DBIx::Class::Row#discard_changes
    $ia->discard_changes;
    is( $ia->public, 1, 'IA Result is now public' );

    # Check repo JSON - test_ia should be absent due to its milestone
    $ia_repo = $get_repo_json->({ repo => 'longtail' });
    ok( !$ia_repo->{test_ia}, 'Test IA not in published milestone' );

    # Set IA milestone
    my $ia_milestone_result = $set_ia_value->({ cookie => $cookie, dev_milestone => 'testing' });
    is( $ia_milestone_result->{saved}, 1, 'Set test_ia milestone to testing' );

    # Check repo JSON - test_ia should now be present
    $ia_repo = $get_repo_json->({ repo => 'longtail' });
    is( ref $ia_repo->{test_ia}, 'HASH', 'Test IA is now in published milestone' );

    # Check contributors - the new user doesn't have a GitHub account connected
    # so he should be listed with his duck.co account
    isnt($ia->developer, undef, 'Test contributor is not null for the new IA');    
    my @contributors  = @{ decode_json( $ia->developer ) };
    my $contributor = $contributors[0];
    is($contributor->{type}, 'duck.co', 'Test contributor is a duck.co account - no github account connected');
    
    # Create user with GitHub account linked
    my $gh_user_request = $cb->(
        POST '/testutils/new_user',
        { 
            username => 'daxtheduck',
            github_id => 13421713
        }
    );
    ok( $gh_user_request->is_success, 'Creating a new user with github account linked' );
    

    # Set contributor to the new user
    my $dax = {
        username => 'daxtheduck',
        type => 'duck.co',
        name => 'daxtheduck'
    };

    $dax = encode_json([$dax]);
    my $ia_switch_contributor = $set_ia_value->({ cookie => $cookie, developer => $dax });
    is( $ia_switch_contributor->{saved}, 1, 'Successfully saved the new contributor' );

    # Check the contributor again - this time it should have the github type
    $ia->discard_changes;
    isnt($ia->developer, undef, 'Test contributor is not null for the new IA');    
    @contributors  = @{ decode_json( $ia->developer ) };
    $contributor = $contributors[0];
    is($contributor->{type}, 'github', 'Test contributor is a github account ' . $contributor->{url});

    # Use this when you need to see session data
    # $cb->( GET '/testutils/debug_session' );

};

# Some basic backend template checks
my $mech = Test::WWW::Mechanize::PSGI->new( app => $app );

my $ia = $d->rs('InstantAnswer')->find('test_ia');

$ia->update({ dev_milestone => 'live', perl_module => 'DDG::Longtail::TestIA' });
$ia->add_to_topics( { name => 'interesting_topic' } );

$mech->get_ok('/ia');
$mech->content_contains('test_ia');

$mech->get_ok('/ia/view/test_ia');
$mech->title_is('Test Ia'); # Title case filter

if ( -d $userpage_out ) {
     remove_tree( $userpage_out );
}
make_path( $userpage_out );

DDH::UserPage::Generate->new(
    contributors => DDH::UserPage::Gather->new->contributors,
    view_dir => "$FindBin::Dir/../views",
    build_dir => $userpage_out
)->generate;

done_testing;
