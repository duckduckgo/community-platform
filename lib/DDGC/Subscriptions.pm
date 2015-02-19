package DDGC::Subscriptions;
# ABSTRACT: Describes notification types users can subscribe to.

use v5.10.1;

use Moose;

has ddgc => (
	isa => 'DDGC',
	is => 'ro',
	required => 1,
	weak_ref => 1,
);

has categories => (
	isa => 'ArrayRef',
	is => 'ro',
	required => 1,
	lazy_build => 1,
);
sub _build_categories {
	+[
		{
			name => 'comleader',
			description => "Community Leader",
			user_filter => sub { $_[0]->is('forum_manager') },
			subscriptions => [qw/ neglected_thread /],
		},
		{
			name => 'forum',
			description => "Discussions",
			subscriptions => [qw/
				at_mention
				all_threads_general
				all_comments_general
				all_threads_community
				all_comments_community
				all_threads_internal
				all_comments_internal
			/],
		}
	];
}

has notification_cycles => (
	isa => 'ArrayRef',
	is => 'ro',
	required => 1,
	lazy_build => 1,
);
sub _build_notification_cycles {
	+[
		{ value => 0, name => "Never" },
		{ value => 2, name => "Hourly" },
		{ value => 3, name => "Daily" },
		{ value => 4, name => "Weekly" },
	];
}

sub forum_user_filter {
	my ( $self, $forum, $user ) = @_;
	$self->ddgc->config->forums->{
		$self->ddgc->config->id_for_forum( $forum )
	}->{user_filter}->( $user );
}

#   - applies_to  - entity the notification applies to, for filtering
#   - process     - a code ref, check if entity matches criteria, generate events
#   - user_filter - whether a user can subscribe to this notification
#   - description - describe the subscription
has subscriptions => (
	isa => 'HashRef',
	is => 'ro',
	required => 1,
	lazy_build => 1,
);
sub _build_subscriptions {
	my ( $self ) = @_;
	+{

		at_mention => {
			applies_to          => 'comment',
			process             => sub { $self->at_mention(@_) },
			user_filter         => sub { $_[0]->public },
			description         => 'Comments which @mention you',
			category            => 'forum',
		},


		neglected_thread        => {
			applies_to          => 'thread_aggregate',
			process             => sub { $self->neglected_thread(@_); },
			user_filter         => sub { $_[0]->is('forum_manager') },
			description         => 'Threads without a reply for over 24 hours',
			category            => 'comleader',
		},


		all_threads_general => {
			applies_to          => 'thread',
			process             =>  sub {
				$self->all_threads( 'general', @_ );
			},
			user_filter         => sub { 1; },
			description         => 'All threads on the General Ramblings forum',
			category            => 'forum',
		},


		all_threads_community => {
			applies_to          => 'thread',
			process             =>  sub {
				$self->all_threads( 'community', @_ );
			},
			user_filter         => sub { $self->forum_user_filter( 'community',  @_ ) },
			description         => 'All threads on the Community Leader forum',
			category            => 'forum',
		},


		all_threads_internal => {
			applies_to          => 'thread',
			process             =>  sub {
				$self->all_threads( 'internal', @_ );
			},
			user_filter         => sub { $self->forum_user_filter( 'internal',  @_ ) },
			description         => 'All threads on the Internal forum',
			category            => 'forum',
		},


		all_comments_general => {
			applies_to          => 'comment_aggregate',
			process             =>  sub {
				$self->all_comments_on_threads( 'general', @_ );
			},
			user_filter         => sub { 1; },
			description         => 'All comments on the General Ramblings forum',
			category            => 'forum',
		},


		all_comments_community => {
			applies_to          => 'comment_aggregate',
			process             =>  sub {
				$self->all_comments_on_threads( 'community', @_ );
			},
			user_filter         => sub { $self->forum_user_filter( 'community',  @_ ) },
			description         => 'All comments on the Community Leader forum',
			category            => 'forum',
		},


		all_comments_internal => {
			applies_to          => 'comment_aggregate',
			Process             =>  sub {
				$self->all_comments_on_threads( 'internal', @_ );
			},
			user_filter         => sub { $self->forum_user_filter( 'internal',  @_ ) },
			description         => 'All comments on the Internal forum',
			category            => 'forum',
		},


	}

} # _build_subscriptions

sub neglected_thread {
	my ( $self ) = @_;
	#
}

# Generates events for all new thread comments, all new threads.
sub all_comments_on_threads {
	my ( $self, $forum, $r ) = @_;
	return unless ( $r->can('thread') && $r->thread );
	if ( $r->thread->forum == $self->ddgc->config->id_for_forum( $forum ) ) {
		if ( $r->parent_id ) {
			$self->event_simple( "all_comments_$forum", $r );
		}
	}
}

sub all_threads {
	my ( $self, $forum, $r ) = @_;
	$r = $self->rs_to_result( $r );
	if ( $r->forum == $self->ddgc->config->id_for_forum( $forum ) ) {
		$self->event_simple( "all_threads_$forum", $r );
	}
}

# Return result or first result in resultset.
sub rs_to_result {
	my ( $self, $r ) = @_;
	return ( ref $r =~ /ResultSet/ ) ? $r->first : $r;
}

# @user mentions
# Operates on a single result or first result in a resultset.
sub at_mention {
	my ( $self, $r ) = @_;
	$r = $self->rs_to_result( $r );
	my $ref = ref $r;
	my $comment = ( $ref =~ /Thread/ ) ? $r->comment : $r;
	my @usernames = ( $comment->content =~ /(?:^|\s+)\@([\w.]+)/g );
	my @ids = $self->rs_ids($r);
	for my $username (@usernames) {
		if ( my $user = $self->ddgc->find_user( $username ) ) {
			if ( $user->public ) {
				$self->ddgc->rs('Event')->create( {
					subscription_id  => 'at_mention',
					target_object_id => $user->id,
					users_id         => $comment->users_id,
					object           => $self->rs_name( $r ),
					object_ids       => \@ids,
				} );
			}
		}
	}
}

sub rs_name {
	my ( $self, $rs ) = @_;
	my $ref = ref $rs;
	return ( $ref =~ /Result(?:Set)?::(.*)/ ) ? $1 : undef;
}

# Generate event for a single result with users_id and instance info.
sub event_simple {
	my ( $self, $subcription_id, $r ) = @_;
	my @ids = $self->rs_ids($r);
	my $result = ( ref $r =~ /ResultSet/ ) ? $r->first : $r;
	$self->ddgc->rs('Event')->create( {
		subscription_id => $subcription_id,
		users_id        => $result->users_id,
		object          => $self->rs_name( $r ),
		object_ids      => \@ids,
	});
}

sub rs_ids {
	my ( $self, $r ) = @_;
	if ( ref $r =~ /ResultSet/ ) {
		return $r->get_column(qw/ id /)->all;
	}
	return $r->id;
}

# New Event table entries
#   - type      - matches a subscription 'applies_to' clause
#   - rs        - Result(Set) of object(s) linked in the notification
sub generate_events {
	my ( $self, $type, $rs ) = @_;
	
	my $subs = $self->subscriptions;

	for my $sub (keys $subs) {
		my (@ids, $id);
		next if ( ( ref $subs->{ $sub }->{applies_to} eq 'ARRAY' ) ?
			( !grep { $_ eq $type } @{ $subs->{ $sub }->{applies_to} } ) :
			( $subs->{ $sub }->{applies_to} ne $type ) );

		$subs->{ $sub }->{process}->( $rs );
	}
}

1;
