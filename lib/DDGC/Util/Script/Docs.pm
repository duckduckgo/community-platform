package DDGC::Util::Script::Docs;

use Moo;

use File::Find;
use File::Spec;
use File::chdir;
use File::Temp qw/ tempdir /;
use File::Copy qw/ mv /;
use File::Path qw/ make_path /;
use Path::Class;
use IO::All;
use Markdent::Handler::HTMLStream::Document;
use Markdent::Parser;
use Text::Trim;
use JSON;
use Text::Xslate;
use IPC::Run qw{run timeout};

with qw/
    DDGC::Util::Script::Base::Service
    DDGC::Util::Script::Base::ServiceEmail
/;

has xslate => (
    is => 'ro',
    lazy => 1,
    builder => sub {
        Text::Xslate->new(
            path => 'views/duckduckgo-documentation',
            verbose => 2,
        );
    },
);

has docs_dir => (
    is => 'ro',
    lazy => 1,
    builder => sub { $_[0]->ddgc_config->ddh_docs_directory; },
);

has nav_file => (
    is => 'ro',
    lazy => 1,
    builder => sub {'ddh-index.md'},
);

has prev_next_file => (
    is => 'ro',
    lazy => 1,
    builder => sub {'ddh-prev-next.json'},
);

has source_dir => (
    is => 'ro',
    lazy => 1,
    builder => '_build_source_dir',
);
sub _build_source_dir {
    my ( $self ) = @_;

    my $cache_dir = $self->ddgc_config->cachedir;
    my $source_dir = File::Spec->catdir(
        $cache_dir, 'duckduckgo-documentation/duckduckhack'
    );

    {
        my ($in, $out, $err);

        if (-d $source_dir) {
            local $CWD = $source_dir;
            run [
                'git', 'pull'
            ], \$in, \$out, \$err, timeout(60) or die "$err (error $?) $out";
        } else {
            local $CWD = $cache_dir;
            run [
                'git', 'clone', '--depth=1', 'https://github.com/duckduckgo/duckduckgo-documentation.git'
            ], \$in, \$out, \$err, timeout(60) or die "$err (error $?) $out";
        }
    }

    return $source_dir;
}

# Builds the prev/next hash to push to each template.
sub get_prev_next {
    my $self = shift;

    my $prev_next_path = dir($self->source_dir,$self->prev_next_file);
    my $json = io($prev_next_path)->slurp;
    $json =~ s/\.md//g;
    my $data = decode_json $json;

    return $data;
}


sub get_nav {
    my $self = shift;

    my $nav_path = dir( $self->source_dir, $self->nav_file );
    my $markdown = io($nav_path)->slurp;

    my %nav = ();
    my @nav = ();
  HEADING: foreach my $heading ( split( /\n\-/s, $markdown ) ) {
        next HEADING if !$heading;
        next HEADING if $heading !~ /\*\*/;

        my $title = '';
        my @sec   = ();
      LINE: foreach my $line ( split( /\n/, $heading ) ) {
            if ( $line =~ /\*\*([^\*]+)/ ) {
                $title = $1;

                # Capturing markdown link.
            }
            elsif ( $line =~ /\[([^\]]+)\]\(([^\)]+)/ ) {
                my $section = $1;
                my $link    = $2;
                $link =~ s/^.*\/(.*)\.md/$1/;
                my %sec = ();
                $sec{'title'} = $section;
                $sec{'link'}  = $link;
                push( @sec, \%sec );

                $nav{$link} = {
                    'category' => $title,
                    'title'    => $section,
                };
            }
        }

        if ($title) {
            my %sec = ();
            $sec{'title'}    = $title;
            $sec{'sections'} = \@sec;
            push( @nav, \%sec );
        }
    }

    return \@nav, \%nav;
}

sub pages {
    my $self = shift;

    my %pages = ();

    # Old index.
    $pages{'index'} = sub {
        no_search_header        => 1,
          hero_header           => 1,
          no_hero_header_icon   => 1,
          hero_header_link      => 'https://duck.co/duckduckhack/ddh-intro',
          hero_header_link_text => "Docs",
          hero_alt              => 1,
          asset_path            => 'ddg',
          js_page_type          => 'DDH',
          hero_slides           => [
            {
                text =>
"Welcome to %sDuckDuckHack%s, an open source community changing the future of search.",
                img  => 'soundcloud',
                tab  => 'Audio',
                user => 'jdan',
                link => 'https://duckduckgo.com/?q=songs+by+tycho&ia=audio',
            },
            {
                text =>
"Getting what you search for in few or zero clicks makes a great search experience.",
                img  => 'regex',
                tab  => 'Regex',
                user => 'mintsoft',
                link => 'https://duckduckgo.com/?q=regex+cheat+sheet&ia=answer',
            },
            {
                text =>
"With the help of you and our community, every search can have an Instant Answer.",
                img  => 'recipes',
                tab  => 'Recipes',
                user => 'bsstoner',
                link =>
'https://duckduckgo.com/?q=reese%27s+cookie+recipes&ia=recipes',
            },
            {
                text =>
"Use the Web's best sources for a specific topic or build an Instant Answer from scratch!",
                img  => 'movies',
                tab  => 'Movies',
                user => 'killerfish',
                link =>
'https://duckduckgo.com/?q=currently+in+theaters&ia=in_theaters&iai=0',
            }
          ],
          foot_useful => [
            {
                name => 'Recipes',
                desc => 'Find recipes by ingredient',
                user => 'bsstoner',
                link =>
'https://github.com/duckduckgo/zeroclickinfo-spice/blob/master/lib/DDG/Spice/Recipes.pm',
                example_link =>
'https://duckduckgo.com/?q=carrot+ginger+soup+recipes&ia=recipes',
            },
            {
                name => 'Regex cheat sheet',
                desc => 'Quickly see regex syntax',
                user => 'mintsoft',
                link =>
'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/RegexCheatSheet.pm',
                example_link =>
'https://duckduckgo.com/?q=regex+cheat+sheet&t=ffab&ia=answer',
            },
            {
                name => 'Timer',
                desc => 'Set a timer for any occasion',
                user => 'mattr555',
                link =>
'https://github.com/duckduckgo/zeroclickinfo-spice/blob/master/lib/DDG/Spice/Timer.pm',
                example_link =>
                  'https://duckduckgo.com/?q=timer+5+minutes&t=ffab&ia=timer',
            }
          ],
          foot_fun => [
            {
                name => 'People in Space',
                desc => "Find out who's orbiting Earth",
                user => 'NeoSilky',
                link =>
'https://github.com/duckduckgo/zeroclickinfo-spice/blob/master/lib/DDG/Spice/PeopleInSpace.pm',
                example_link =>
                  'https://duckduckgo.com/?q=people+in+space&t=ffab&ia=answer',
            },
            {
                name => 'Flip a Coin',
                desc => 'Play virtual heads or tails',
                user => 'mattlehning',
                link =>
'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Coin.pm',
                example_link =>
                  'https://duckduckgo.com/?q=flip+a+coin&t=ffab&ia=answer',
            },
            {
                name => 'Figlet',
                desc => 'Generate a figlet design',
                user => 'larseng',
                link =>
'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/FIGlet.pm',
                example_link =>
'https://duckduckgo.com/?q=figlet+Welcome+to+DuckDuckHack&t=ffab&ia=answer',
            }
          ],
          foot_users => [
            {
                name => 'Usman Raza',
                user => 'killerfish',
            },
            {
                name => 'Rob Emery',
                user => 'mintsoft',
            },
            {
                name => 'Chris Wilson',
                user => 'MrChrisW',
            }
          ],
          ;
    };

    my $prev_next_hash_ref = $self->get_prev_next;
    my %prev_next          = %{$prev_next_hash_ref};

    my ( $nav_arr_ref, $nav_hash_ref ) = $self->get_nav;
    my %nav = %{$nav_hash_ref};

    find(
        sub {

            my $name = $File::Find::name;
            my $dir  = $File::Find::dir;

            return if $name =~ /$self->{nav_file}/;

            return unless $name =~ /^[^.].+\.md$/;    # only markdown files

            my ($file) = $name =~ /^$self->{source_dir}\/(.*)\.md/;
            my $dir_rel = '';
            ( $dir_rel, $file ) = $file =~ /^(.*)\/(.*)/ if $file =~ /\//;

            my $markdown = io($name)->slurp;

# Replaces hard github links to other markdown files to our newly converted relative links
            $markdown =~
s~(\]\()https://github.com/duckduckgo/duckduckgo-documentation/blob/master/duckduckhack/(?:[^\/\.]+\/){1,4}([^\.]+?)\.md([^\)]*?\))~$1$2$3~sg;

 # Replace code types the parser can't deal with,
 # that is a #### line without a space line between it and a code start line ```
            $markdown =~ s/(\n\#+.*?)(\n`)/$1\n$2/sg;

            my $buffer = q{};
            open my $fh, '>', \$buffer;

            my $handler = Markdent::Handler::HTMLStream::Document->new(
                title  => $name,
                output => $fh,
            );

            my $parser =
              Markdent::Parser->new( dialect => 'GitHub', handler => $handler );
            $parser->parse( markdown => $markdown );

            my $html = $buffer;

            $html =~ s/^.*?<html>.*?<\/head>\s*<body>\s*//s;
            $html =~ s/\s*<\/body>.*?<\/html>\s*$//s;

            $html =~
s/(<h\d>)(.*?)(<\/h\d>)/$1 . '<a name="' . make_anchor($2) . '" class="anchor"><\/a>' . $2 . $3/ges;

            my $category = $nav{$file}{'category'} || '';
            my $title    = $nav{$file}{'title'}    || '';

            warn qq(NO CATEGORY: $file\n) if !$category;

            my $prev = $prev_next{$file}{'prev'} || [];
            my $next = $prev_next{$file}{'next'} || [];

            warn qq(NO PREV: $file\n) if !$prev;
            warn qq(NO NEXT: $file\n) if !$next;

            $pages{$file} = {
                file       => $file,
                  file_dir => $dir_rel,
                  file_path =>
"https://github.com/duckduckgo/duckduckgo-documentation/tree/master/duckduckhack",
                  title        => $title,
                  category     => $category,
                  html         => $html,
                  nav_ref      => $nav_arr_ref,
                  maintemplate => 'doc.tx',
                  prev         => $prev,
                  next         => $next,
                  raw_output   => 1,
            };

        },
        $self->source_dir
    );

    return \%pages;
}

sub make_anchor {
    my ($anchor) = @_;

    $anchor = lc $anchor;
    $anchor =~ s/[^a-z\s]+//g;
    $anchor = trim $anchor;
    $anchor =~ s/\s+/\-/g;

    return $anchor;
}

sub execute {
    my ( $self ) = @_;
    my $tmp = tempdir;

    for my $file ( keys $self->pages ) {
        my $page = $self->pages->{$file};

        next if !$page->{maintemplate};

        $self->xslate->render(
            $page->{maintemplate}, $page
        ) > io(File::Spec->catfile(
            $tmp, $page->{file}
        ))->utf8;
    }

    mv( $_, $self->ddgc_config->docsdir )
        for glob File::Spec->catfile( $tmp, '*' );
}

1;
