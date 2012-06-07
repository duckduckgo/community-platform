package DDGC::DB::Result::Thread;
# ABSTRACT: Dukgo.com Forum thread

use DBIx::Class::Candy -components => [ 'TimeStamp', 'InflateColumn::DateTime', 'InflateColumn::Serializer', 'EncodedColumn' ];

table 'post';

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

column title => {
    data_type => 'text',
    is_nullable => 0,
};

column text => {
    data_type => 'text',
    is_nullable => 0,
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
	return $self->title;
}, fallback => 1;

sub _category {
    my %cats = ( 
      1 => "discussion",
      2 => "idea",
      3 => "problem",
      4 => "question",
      5 => "announcement",
    );
    $cats{$_[1]};
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
};

sub status_key {
    my $self = shift;

    my $category = $self->category_key;
    my $status_id = $self->data->{"${category}_status_id"};
    return 'closed' if $status_id == 0;
    return '' if $status_id == 1;
    my $statuses = $self->_statuses;
    my $cat_stat = $$statuses{$category};
    $$cat_stat{$status_id};
}

sub category_key {
    my $self = shift;
    $self->_category($self->category_id);
}

1;

