package DDGC::Schema::Result::Subscriber::MailLog;

use Moo;
extends 'DDGC::Schema::Result';
use DBIx::Class::Candy;

table 'subscriber_maillog';

primary_column email_address => { data_type => 'text' };
primary_column campaign      => { data_type => 'text' };
primary_column email_id      => { data_type => 'char', size => 1 };

column sent => {
    data_type => 'timestamp with time zone',
    set_on_create => 1,
};

belongs_to subscriber => 'DDGC::Schema::Result::Subscriber' => {
    'foreign.email_address' => 'self.email_address',
    'foreign.campaign'      => 'self.campaign',
};

1;
