package DDGC::DB::ResultSet::Event::Notification::Group;
# ABSTRACT: Resultset class for comment entries

use Moose;
extends 'DDGC::DB::Base::ResultSet';
use namespace::autoclean;

sub prefetch_all {
  my ( $self ) = @_;
  $self->search_rs({},{
    prefetch => [qw( user_notification_group ),{
      event_notifications => [qw( user_notification ),{
        event => [qw( user ),{
          %{$self->prefetch_context_config('DDGC::DB::Result::Event')},
          event_relates => $self->prefetch_context_config('DDGC::DB::Result::Event::Relate'),
        }],
      }],
    }],
  });
}

no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
