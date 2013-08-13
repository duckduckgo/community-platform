package DDGC::DB::Result::Thread;
# ABSTRACT: Dukgo.com Forum thread

use Moose;
use MooseX::NonMoose;
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

column sticky => {
    data_type => 'bool',
    default_value => 0,
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
      1 => "dev",
      2 => "discussion",
    }  
}

sub _category {
    my ( $self, $category ) = @_;
    $self->categories->{$category};
}

sub _statuses {
    # 1 is the default status
    {
        dev => {
            2 => "needs developer",
            3 => "needs more information",
            4 => "in development",
            5 => "under review",
            6 => "invalid", # not an instant answer ...?
            7 => "improvement idea",
        },
        discussion => {
            2 => "need more information",
            3 => "resolved",
        },
    }
}

sub statuses {
    my $self = shift;
    my $category = $self->category_key;
    my $statuses = $self->_statuses;
    my $cat_stat = $$statuses{$category} or return {};
    return values %{$cat_stat} unless $_[0];
    return $cat_stat;
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
    my $x = $self->title_to_path($self->id, $self->title);
    $x;
}

sub title {
    shift->thread_title;
}

sub category_key {
    my $self = shift;
    $self->_category($self->category_id);
}


# TEMPORARY (TODO: get rid of this and replace it with something sane?)
sub first_comment {
    my $self = shift;
    return $self->result_source->schema->ddgc->comments(__PACKAGE__, $self->id)->list->[0];
}

no Moose;
__PACKAGE__->meta->make_immutable;
