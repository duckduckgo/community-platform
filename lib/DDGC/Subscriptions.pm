package DDGC::User::Subscriptions;
# ABSTRACT: Describes notification types users can subscribe to.

use Moose;

has ddgc => (
	isa => 'DDGC',
	is => 'ro',
	required => 1,
	weak_ref => 1,
);

has categories => (
	isa => 'HashRef',
	is => 'ro',
	required => 1,
	lazy_build => 1,
);
sub _build_categories {
	my ( $self ) = @_;
	my $subs = $self->subscriptions;
	my $cats;
	for my $sub (keys $subs) {
		push @{ $cats->{ $subs->{ $sub }->category }, $sub }
	}
	return $cats;
}

# Describe notification types
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
			applies_to          => [ 'comment', 'thread' ],
			process             => \&at_mention,
			user_filter         => sub { $_[0]->public },
			description         => 'Comments which @mention you',
			category            => 'forum',
		},


		neglected_thread        => {
			applies_to          => 'thread',
			process             => sub { $self->neglected_thread(@_); },
			user_filter         => sub { $_[0]->is('forum_manager') },
			description         => 'Threads without a reply for over 24 hours',
			category            => 'comleader',
		},


		all_comments_general => {
			applies_to          => 'comment',
			process             =>  sub {
				$self->event_simple( 'all_comments_general', @_ );
			},
			user_filter         => sub { 1; },
			description         => 'All comments on the General Ramblings forum',
			category            => 'forum',
		},


		all_comments_comleader => {
			applies_to          => 'comment',
			process             =>  sub {
				$self->event_simple( 'all_comments_comleader', @_ );
			},
			user_filter         => sub {
				$self->ddgc->config->forums->{
					$self->forum_id_comleader
				}->user_filter( $_[0] );
			},
			description         => 'All comments on the Community Leader forum',
			category            => 'forum',
		},


		all_comments_internal => {
			applies_to          => 'comment',
			process             =>  sub {
				$self->event_simple( 'all_comments_internal', @_ );
			},
			user_filter         => sub {
				$self->ddgc->config->forums->{
					$self->forum_id_internal
				}->user_filter( $_[0] );
			},
			description         => 'All comments on the Internal forum',
			category            => 'forum',
		},


	}

} # _build_subscriptions

sub neglected_thread {
	my ( $self ) = @_;
	#
}

sub at_mention {
	my ( $self, $rs ) = @_;
	my $comment = ( ref $rs =~ /Thread/ ) ? $rs->first->comment : $rs->first;
	my @usernames = ( $comment =~ /(?:^|\s+)\@([\w.]+)/g );
	my @ids = $self->rs_ids($rs);
	for my $username (@usernames) {
		if ( my $user = $self->ddgc->find_user( $username ) ) {
			if ( $user->public ) {
				$self->ddgc->rs('Event')->create( {
					subscription_id => 'at_mention',
					target_users_id => $user->id,
					users_id        => $comment->users_id,
					object          => $self->rs_name( $rs ),
					object_ids      => \@ids,
				} );
			}
		}
	}
}

sub rs_name {
	my ( $self, $rs ) = @_;
	return ( ref $rs =~ /ResultSet::(.*)/ ) ? $1 : undef;
}

# Generate event for a single result with users_id and instance info.
sub event_simple {
	my ( $self, $subcription_id, $rs ) = @_;
	my @ids = $self->rs_ids($rs);
	my $result = $rs->first;
	$self->ddgc->rs('Event')->create( {
		subscription_id => $subcription_id,
		users_id        => $result->users_id,
		object          => $self->rs_name( $rs ),
		object_ids      => \@ids,
	});
}

sub rs_ids {
	my ( $self, $rs ) = @_;
	return $rs->get_column(qw/ id /)->all;
}

# New Event table entries
#   - type      - matches a subscription 'applies_to' clause
#   - is        - ResultSet of object(s) linked in the notification
sub generate_events {
	my ( $self, $type, $rs ) = @_;
	my $subs = $self->subscriptions;

	for my $sub (keys $subs) {
		my (@ids, $id);
		next if ( ( ref $subs->{ $sub }->{applies_to} eq 'ARRAY' ) ?
			( grep { $_ eq $type } @{ $subs->{ $sub }->{applies_to} } ) :
			( $subs->{ $sub }->{applies_to} ne $type) );

		$subs->{ $sub }->{process}->( $rs );
	}
}

1;

