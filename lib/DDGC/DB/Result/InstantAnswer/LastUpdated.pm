package DDGC::DB::Result::InstantAnswer::LastUpdated;
# ABSTRACT: Tracking IA updates across all relationships

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'instant_answer_last_updated';

# Token can be anything. It's just some data to ensure we have
# a write transaction and set_on_update kicks in.
#
# See touch RS method.
primary_column token => { data_type => 'text' };
column updated => { data_type => 'timestamp with time zone', set_on_create => 1, set_on_update => 1 };

1;
