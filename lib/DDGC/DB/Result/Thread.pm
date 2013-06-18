package DDGC::DB::Result::Thread;
# ABSTRACT: Dukgo.com Forum thread

use Moose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use DateTime::Format::Human::Duration;
use namespace::autoclean;

table 'thread';

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

column title => {
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

has categories => (
    is => 'ro',
    isa => 'HashRef',
    auto_deref => 1, 
    lazy_build => 1, 
);

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
    my ( $self, $category ) = @_;
    $self->categories->{$category};
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
    my $self = shift;
    $self->_humanify($self->updated);
}

sub created_human {
    my $self = shift;
    $self->_humanify($self->created);
}

no Moose;
__PACKAGE__->meta->make_immutable;
