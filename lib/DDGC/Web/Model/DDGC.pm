package DDGC::Web::Model::DDGC;
# ABSTRACT: Adaptor model to connect DDGC to Catalyst

use Moose;
extends 'Catalyst::Model::Adaptor';

use Catalyst::Utils;

__PACKAGE__->config( class => 'DDGC' );

my $ddgc_test;

sub _create_instance {
    my ($self, $app, $rest) = @_;

    my $constructor = $self->{constructor} || 'new';
    my $arg = $self->prepare_arguments($app, $rest);

    if (defined $ENV{DDGC_TESTING} && $ENV{DDGC_TESTING}) {
      Catalyst::Utils::ensure_class_loaded("DDGCTest::Database");
      return DDGCTest::Database->for_test($ENV{DDGC_TESTING})->d;
    }

    my $adapted_class = $self->{class};

    return $adapted_class->$constructor($self->mangle_arguments($arg));
}

no Moose;
__PACKAGE__->meta->make_immutable;
