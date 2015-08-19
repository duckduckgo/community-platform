package DDGC::DB::Result::Topic;
# ABSTRACT: Result class of a topic in the DB

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use DDGC::User::Page;
use Path::Class;
use IPC::Run qw/ run timeout /;
use LWP::Simple qw/ is_success getstore /;
use File::Temp qw/ tempfile /;
use Carp;
use Prosody::Mod::Data::Access;
use Digest::MD5 qw( md5_hex );
use List::MoreUtils qw( uniq  );
use namespace::autoclean;

table 'topics';

column id => {
        data_type => 'bigint',
        is_auto_increment => 1,
};

primary_key 'id';

unique_column name => {
        data_type => 'text',
        is_nullable => 0,
};

has_many 'instant_answer_topics', 'DDGC::DB::Result::InstantAnswer::Topics', 'topics_id';
many_to_many 'instant_answers', 'instant_answer_topics', 'instant_answer';

no Moose;
__PACKAGE__->meta->make_immutable ( inline_constructor => 0 );
