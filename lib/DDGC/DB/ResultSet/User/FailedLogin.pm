package DDGC::DB::ResultSet::User::FailedLogin;
# ABSTRACT: Resultset class for tracking login failures

use Moose;
extends 'DDGC::DB::Base::ResultSet';
use namespace::autoclean;

no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );

