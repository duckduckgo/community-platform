use strict;
use warnings;

# Database setup
BEGIN {
    unlink 'ddgc_test.db';
    $ENV{DDGC_DB_DSN} = 'dbi:SQLite:dbname=ddgc_test.db';
}

use Test::More;
use t::lib::DDGC::TestUtils;
use HTTP::Request::Common;
use Plack::Test;
use Plack::Builder;
use Plack::Session::State::Cookie;
use Plack::Session::Store::File;
use File::Temp qw/ tempdir /;
use File::Spec::Functions;
use IO::All -utf8;
use JSON::MaybeXS qw/:all/;
use URI;
use MIME::Base64;
use List::MoreUtils qw/ pairwise /;

use DDGC;
use DDGC::LocaleDist;
use DDGC::Web;

my $d = DDGC->new;
t::lib::DDGC::TestUtils::deploy( undef, $d->db );

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

test_psgi $app => sub {
    my ( $cb ) = @_;

    my $create_user_and_get_cookie = sub {
        my $opts = shift;

        my $user_request = $cb->(
            POST '/testutils/new_user',
            {
                username => $opts->{username},
                ( $opts->{role} ) ? ( role => $opts->{role} ) : (),
            }
        );
        ok( $user_request->is_success, 'Creating a user' );

        my $session_request = $cb->(
            POST '/testutils/user_session',
            { username => $opts->{username} }
        );
        ok( $session_request->is_success, 'Getting user Cookie' );
        my $cookie = 'ddgc_session=' . $session_request->content;
    };

    my $delete_msgstr_request = sub {
        my ( $user, $token_language_id ) = @_;

        $cb->(
            GET "/translate/delete_live/$token_language_id",
            Cookie => $user,
        );
    };

    my $retire_request = sub {
        my ( $user, $token_id, $retire ) = @_;

        $cb->(
            GET "/translate/single_token/$token_id/retire/$retire",
            Cookie => $user,
        );
    };

    my $add_translation_request = sub {
        my ( $user, $token_language_id, $msgstr ) = @_;

        $cb->(
            POST "/translate/tokenlanguage/$token_language_id", [
                "token_language_${token_language_id}_msgstr0" => $msgstr,
                save_translations => 'yes',
            ],
            Cookie => $user,
        );
    };

    my $token = sub {
        $d->rs('Token')->search({ msgid => $_[0] })->one_row;
    };

    my $new_lang = sub {
        my ( $locale, $name ) = @_;
        $d->rs('Language')->create({
            locale => $locale,
            name_in_english => $name,
            name_in_local => $name
        });
    };

    my $admin = $create_user_and_get_cookie->( {
        username => 'tadminuser',
        role     => 'admin',
    } );
    my $admin_user = $d->find_user('tadminuser');

    my $polyglot = $create_user_and_get_cookie->( {
        username => 'polyglot',
    } );
    my $polyglot_user = $d->find_user('polyglot');

    my $user = $create_user_and_get_cookie->( {
        username => 'tuser',
    } );
    my $user_user = $d->find_user('tuser');

    my $l1 = $new_lang->('en_US', 'US English');

    my $domain = $d->rs('Token::Domain')->create({
        name => 'test',
        key => 'test',
        source_language_id => $l1->id,
    });

    $_->create_related(
        user_languages => {
            grade => 5,
            language_id => $l1->id,
        }
    ) for ( $admin_user, $user_user );

    my $l2 = $new_lang->('en_GB', 'UK English');
    my $l3 = $new_lang->('en_AU', 'Aus English');

    $domain->create_related(
        token_domain_languages => {
            language => $_
        }
    ) for ( $l1, $l2, $l3 );

    $polyglot_user->create_related(
        user_languages => {
            grade => 5,
            language_id => $_->id,
        }
    ) for ( $l1, $l2, $l3 );

    $domain->create_related( tokens => { msgid => $_ } )
        for ( qw/ foo bar baz qux quux quuz / );

    my $r = $retire_request->( $user, $token->('baz')->id, 1 );
    ok( !$r->is_success, 'Non-admin cannot retire token' );
    is( $token->('baz')->retired, 0, 'Token baz not retired' );

    $r = $retire_request->( $admin, $token->('baz')->id, 1 );
    ok( $r->is_success, 'Admin can retire token' );
    is( $token->('baz')->retired, 1, 'Token baz retired' );

    my @bad_msgstrs = ( decode_base64('aG9yc2UgcGlzcw=='), decode_base64('c2hpdHR5IGJlZXI='),
        q{'><img src=x onerror='alert(1)>}, q{"><script>alert(1)</script>}, q{"><img src=x onerror=prompt(1)>} );
    my @good_msgstrs = ( q{scunthorpe}, q{shitake mushrooms}, q{Open Menu > Settings > Search and select DuckDuckGo!}, q{> 20 Minuten} );
    my @tl = $d->rs('Token::Language')->search( {
        token_domain_language_id => {
            '!=' => $d->rs('Token::Domain::Language')->search({ language_id => $l1->id })->one_row->id
        },
    } )->all;

    my @slice =  @tl[0..4];
    pairwise {
        my $display_bad_msgstr = encode_base64($a);
        my $r = $add_translation_request->( $polyglot, $b->id, $a );
        ok( $r->is_success, "Adding translation $display_bad_msgstr" );
        is( $d->rs('Token::Language::Translation')->order_by({ -desc => 'id' })->one_row->check_result, 0, "Invalid token $display_bad_msgstr" );
    } @bad_msgstrs, @slice;

    @slice =  @tl[5..8];
    pairwise {
        my $r = $add_translation_request->( $polyglot, $b->id, $a );
        ok( $r->is_success, "Adding translation $a" );
        is( $d->rs('Token::Language::Translation')->order_by({ -desc => 'id' })->one_row->check_result, 1, "Valid token $a" );
    } @good_msgstrs, @slice;

    my @tokens =  $d->rs('Token')->search({ retired => 0 })->all;
    $tokens[0]->notes("This is a usage note for this token\n\nIt is split over multiple lines");
    $tokens[1]->notes("This is a single line usage note");
    $tokens[0]->update;
    $tokens[1]->update;

    my $dist = DDGC::LocaleDist->new( token_domain => $domain );
    my $dir = $dist->distribution_file->stringify =~ s/\.tar\.[a-zA-Z0-9]+$//r;

    my $pofile = catfile( $dir, qw/ share en_AU LC_MESSAGES test.po / );
    my $content = io->file($pofile)->slurp;
    ok( $content =~ /#\. This is a single line usage note/,
        'PO file contains properly formatted comment' );
    ok( $content =~ /#\. This is a usage note for this token[\n\r]+#\. It is split over multiple lines/s,
        'PO file contains properly formatted multiline comment' );

    for my $lang (qw/ en_AU en_GB /) {
        my $fn = catfile( $dir, 'share', $lang, 'LC_MESSAGES', 'test.js' );
        my $baz = grep { /baz/ } io->file($fn)->all;
        my $quux = grep { /quux/ } io->file($fn)->all;
        my $bad = grep { my $l = $_; grep { $l =~ /$_/ } @bad_msgstrs } io->file($fn)->all;
        ok( !$baz, "Retired token baz not in locale js for $lang" );
        ok( $quux, "Token quux is in locale js for $lang" );
        ok( !$bad, "No invalid translations in locale js" );
    }

    my $en_us_dir = catfile( $dir, qw/ share en_US LC_MESSAGES / );
    my @po = io->file( catfile( $en_us_dir, 'test.po' ) )->all;
    my @js = io->file( catfile( $en_us_dir, 'test.js' ) )->all;
    for my $token ( qw/ foo bar baz qux quux quuz / ) {
        ok( !( grep { /$token/ } @js ), 'en_US tokens not in js' );
        ok( !( grep { /$token/ } @po ), 'en_US tokens not in po' );
    }

    my $tl = $d->rs('Token::Language')->search({
        msgstr0 => { '!=' => undef },
        token_domain_language_id => {
            '!=' => $d->rs('Token::Domain::Language')->search({ language_id => $l1->id })->one_row->id
        }
    })->one_row;
    ok ( $tl->msgstr0, "tokenlanguage has msgstr" );

    $r = $delete_msgstr_request->( $polyglot, $tl->id );
    ok ( ! $r->is_success, "Non translation manager msgstr delete request failed" );
    $tl = $tl->get_from_storage;
    ok ( $tl->msgstr0, "tokenlanguage still has msgstr" );

    $r = $delete_msgstr_request->( $admin, $tl->id );
    ok ( $r->is_success, "Admin delete request msgstr succeeded" );
    $tl = $tl->get_from_storage;
    ok ( ! $tl->msgstr0, "tokenlanguage no longer has msgstr" );

};

done_testing;

