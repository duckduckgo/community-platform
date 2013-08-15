package DDGC::Feedback::Step;

use Moose;
use MooseX::Storage;
with Storage('format' => 'Storable');
use DDGC::Feedback::Option;

has options => (
  is => 'ro',
  isa => 'ArrayRef[DDGC::Feedback::Option]',
  predicate => 'has_options',
);

has end => (
  is => 'ro',
  isa => 'Str',
  predicate => 'has_end',
);

sub BUILD {
  my ( $self ) = @_;
  die __PACKAGE__."->new requires options OR end" unless $self->has_options || $self->has_end;
}

sub new_from_config {
  my ( $class, @config_options ) = @_;
  my @options;
  while (@config_options) {
    my $option = shift @config_options;
    if (defined $config_options[0]) {
      my $target_ref = ref $config_options[0];
      my $target;
      if (!$target_ref && defined $config_options[1]) {
        $target = $class->new({ end => (shift @config_options) });
      } elsif ($target_ref eq 'ARRAY') {
        my $target_options = shift @config_options;
        $target = $class->new_from_config(@{$target_options});
      }
      push @options, DDGC::Feedback::Option->new_from_config($option,$target);
    } else {
      if (ref $option eq 'HASH') {
        push @options, DDGC::Feedback::Option->new_from_config($option);
      } elsif ($option eq "") {
        # explicit does nothing
      } else {
        push @options, DDGC::Feedback::Option->new_from_config({
          type => 'submit',
          description => $option,
        });
      }
    }
  }
  return $class->new({ options => \@options });
}

no Moose;
__PACKAGE__->meta->make_immutable;
