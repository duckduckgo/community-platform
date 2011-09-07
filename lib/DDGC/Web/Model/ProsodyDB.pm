package DDGC::Web::Model::ProsodyDB;

use Moose;
extends 'Catalyst::Model::DBIC::Schema';

use DDGC::Config;

__PACKAGE__->config(
	schema_class => 'Prosody::Storage::SQL::DB',
	connect_info => DDGC::Config::prosody_connect_info,
);

1;