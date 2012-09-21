package DDGC::DB::Result::Thread;
# ABSTRACT: Dukgo.com Forum thread

use DBIx::Class::Candy -components => [ 'TimeStamp', 'InflateColumn::DateTime', 'InflateColumn::Serializer', 'EncodedColumn' ]; #, 'Indexed'
#__PACKAGE__->set_indexer( 'WebService::Dezi',  { server => 'http://localhost:5000', content_type => 'application/json' } );

use Parse::BBCode;
use Moose;
use DateTime::Format::Human::Duration;
use Text::VimColor;

my $_bbcode = Parse::BBCode->new({
        close_open_tags => 1,
        attribute_quote => q('"),
        url_finder => {
            max_length  => 200,
            # sprintf format:
            format      => '<a href="%s" rel="nofollow">%s</a>',
        },
        tags => {
            Parse::BBCode::HTML->defaults,
            url => 'url:<a href="%{link}A">%{parse}s</a>',
            img => '<a href="%{link}A"><img src="%{link}A" alt="[%{html}s]" title="%{html}s"></a>',
            code => {
                code => sub {
                    my ($parser, $attr, $content, $attribute_fallback) = @_;
                    my $lang = "";

                    my $highlight_ok = 1;
                    $highlight_ok = 0 if length($$content) > 50_000; # it can handle a lot

                    for(split /\n/, $$content) {
                        if (length($_) > 600) { # >80s just because of a long line? I think not.
                            $highlight_ok = 0;
                            break();
                        }
                    }
                    if ($attr && $highlight_ok) {
                        my @lines = split /\n/, $$content;
                        my $tvc = Text::VimColor->new( string => $$content, filetype => lc($attr) );
                        $content = $tvc->html;
                        $lang = ucfirst($attr)." ";
                    } else {
                        $content = Parse::BBCode::escape_html($$content);
                    }
                    "<div class='bbcode_code_header'>${lang}Code:<pre class='bbcode_code_body'>$content</pre></div>"
                },
                parse => 0,
                class => 'block',
            },
            quote => {
                parse => 1,
                slass => 'block',
                code => sub {
                    my ($parser, $attr, $content, $attribute_fallback) = @_;
                    "<div class='bbcode_quote_header'>Quote from {{#USER $attribute_fallback #}}:<div class='bbcode_quote_body'>$$content</div></div>";
                },
            },
        },
});

table 'thread';

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

column thread_title => {
    data_type => 'text',
    is_nullable => 0,
    indexed => 1,
};

column text => {
    data_type => 'text',
    is_nullable => 0,
    indexed => 1,
};

column data => {
	data_type => 'text',
	is_nullable => 1,
	serializer_class => 'YAML',
};

column users_id => {
	data_type => 'bigint',
	is_nullable => 0,
};

column category_id => {
    data_type => 'int',
    is_nullable => 0,
};

column created => {
	data_type => 'timestamp with time zone',
	set_on_create => 1,
};

column updated => {
	data_type => 'timestamp with time zone',
	set_on_create => 1,
	set_on_update => 1,
};

belongs_to 'user', 'DDGC::DB::Result::User', 'users_id';

use overload '""' => sub {
	my $self = shift;
	return $self->thread_title;
}, fallback => 1;

has categories => (
    is => 'ro',
    isa => 'HashRef',
    auto_deref => 1, 
    lazy_build => 1, 
);

has dezi_enabled => (
    is => 'ro',
    default => sub { shift->result_source->schema->ddgc->config->dezi_enabled },
);

around new => sub {
    my $new = shift;
    my $obj = $new->(@_);
    __PACKAGE__->load_components('Indexed');
    __PACKAGE__->set_indexer( 'WebService::Dezi',  { server => 'http://localhost:5000', content_type => 'application/json', disabled => $obj->dezi_enabled } );
    return $obj;
};

sub _build_categories {
        {  
          1 => "discussion",
          2 => "idea",
          3 => "problem",
          4 => "question",
          5 => "announcement",
        }  
}

sub _category {
    shift->categories->{$_[1]};
}

sub started_term {
    my %started = (
        1 => "started",
        2 => "proposed",
        3 => "reported",
        4 => "asked",
        5 => "announced",
    );
    $started{shift->category_id};
}

sub _statuses {
    # 1 is the default status
    my %catstats = (
        idea => {
            2 => "declined",
            3 => "in progress",
        },
        problem => {
            2 => "need more information",
            3 => "not a problem",
            4 => "solved",
        },
        question => {
            2 => "answered",
        },
    );
    \%catstats;
}

sub get_user {
    my ( $self, $username, $d ) = @_;
    my $user = $d->rs('User')->single({ username => lc($username) });
    my $uname = $user && $user->public_username ? $user->public_username : Parse::BBCode::escape_html($username);
    return "<a>\@${uname}</a>";
}

sub render_html {
    my ($self, $db) = @_;
    my $html = $_bbcode->render(shift->text);
    $html =~ s/(?:{{#USER (.+?) #}}|\@(\w+))/$self->get_user(($1?$1:$2), $db)/eg;
    return $html;
}

sub statuses {
    my $self = shift;
    my $category = $self->category_key;
    my $statuses = $self->_statuses;
    my $cat_stat = $$statuses{$category} or return {};
    return values %{$cat_stat} unless $_[0];
    return %{$cat_stat};
}

sub is_closed {
    my $self = shift;
    my $category = $self->category_key;
    $self->data->{"${category}_status_id"} == 0;
}

sub status_key {
    my $self = shift;

    my $category = $self->category_key;
    my $status_id = $self->data->{"${category}_status_id"};
    return 'closed' if $status_id == 0;
    return 'open' if $status_id == 1;
    my $statuses = $self->_statuses;
    my $cat_stat = $$statuses{$category};
    $$cat_stat{$status_id};
}

sub title_to_path { # construct a id-title-of-thread string from $id and $title
    shift; # knock off $self, don't need it
    my $url = substr(lc($_[1]),0,50);
    $url =~ s/[^a-z0-9]+/-/g; $url =~ s/-$//;
    return $_[0] . "-" . $url;
}

sub url {
    my $self = shift;
    my $x = $self->title_to_path($self->id, $self->thread_title);
    $x;
}

sub title {
    shift->thread_title;
}

sub category_key {
    my $self = shift;
    $self->_category($self->category_id);
}

sub updated_human {
    my $span = DateTime::Format::Human::Duration->new();
    my $now = DateTime->now;
    my $delta = $now - shift->updated;
    $span->format_duration($delta);
}

sub created_human {
    my $span = DateTime::Format::Human::Duration->new();
    my $now = DateTime->now;
    my $delta = $now - shift->created;
    $span->format_duration($delta);
}



1;

