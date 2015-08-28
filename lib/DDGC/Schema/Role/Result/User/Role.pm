package DDGC::Schema::Role::Result::User::Role;

use Moo::Role;

sub normalise_role {
    my ( $role ) = @_;
    return 'forum_manager' if ( lc( $role ) eq 'idea_manager' );
    return 'forum_manager' if ( lc( $role ) eq 'community_leader' );
    return $role;
}

sub is {
    my ( $self, $role ) = @_;
    return 0 if !$role;
    $role = normalise_role( $role );
    return 1 if ( $role eq 'user' );
    return 1 if $self->roles->find({
        role => $self->ddgc_config->id_for_role('admin')
    });
    return 1 if $self->roles->find({
        role => $self->ddgc_config->id_for_role($role)
    });
    return 0;
}

sub add_role {
    my ( $self, $role ) = @_;
    $role = normalise_role( $role );
    my $role_id = $self->ddgc_config->id_for_role($role);
    return 0 if !$role_id;
    $self->roles->find_or_create({ role => $role_id });
}

sub del_role {
    my ( $self, $role ) = @_;
    $role = normalise_role( $role );
    my $role_id = $self->ddgc_config->id_for_role($role);
    return 0 if !$role_id;
    my $has_role = $self->roles->find({ role => $role_id });
    $has_role->delete if $has_role;
}

sub admin { $_[0]->is('admin') }
sub community_leader { $_[0]->is('forum_manager') }
sub forum_manager { $_[0]->is('forum_manager') }
sub translation_manager { $_[0]->is('translation_manager') }

sub badge {
    my ( $self ) = @_;
    for my $role (qw/
        admin community_leader
        translation_manager
    /) {
        return $role if $self->is($role)
    }
    return '';
}

1;
