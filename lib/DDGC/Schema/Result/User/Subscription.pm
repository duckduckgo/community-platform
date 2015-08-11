package DDGC::Schema::Result::User::Subscription;
# ABSTRACT: Activity feed subscription result class

use Moo;
extends 'DDGC::Schema::Result';
use DBIx::Class::Candy;

table 'user_subscription';

column id => {
    data_type => 'bigint',
    is_auto_increment => 1,
};
primary_key 'id';

column users_id => {
    data_type   => 'bigint',
    is_nullable => 0,
};

column category => {
    data_type => 'text',
    is_nullable => 0,
};

column action => {
    data_type => 'text',
    is_nullable => 1,
};

column meta1 => {
    data_type => 'text',
    is_nullable => 1,
};

column meta2 => {
    data_type => 'text',
    is_nullable => 1,
};

column meta3 => {
    data_type => 'text',
    is_nullable => 1,
};

belongs_to 'user', 'DDGC::Schema::Result::User', 'users_id';

has_many 'activity', 'DDGC::Schema::Result::ActivityFeed', sub {
    my ( $args ) = @_;

    my $activity = $args->{foreign_alias};
    my $subscription = $args->{self_alias};

    +{
        -and => {
            "$activity.category" => { -ident => "$subscription.category" },
            -or => [
                "$subscription.action" => undef,
                "$activity.action" => { -ident => "$subscription.action" },
            ],
            -or => [
                "$subscription.meta1" => undef,
                "$activity.meta1" => { 'like' => { -ident => "$subscription.meta1" } },
            ],
            -or => [
                "$subscription.meta2" => undef,
                "$activity.meta2" => { 'like' => { -ident => "$subscription.meta2" } },
            ],
            -or => [
                "$subscription.meta3" => undef,
                "$activity.meta3" => { 'like' => { -ident => "$subscription.meta3" } },
            ],
            -or => [
                "$activity.for_user" => undef,
                "$activity.for_user" => { -ident => "$subscription.users_id" },
            ],
            -or => [
                "$activity.for_role" => undef,
                "$activity.for_role" => {
                    -in => \"SELECT role FROM user_role WHERE users_id = $subscription.users_id",
                }
            ]
        }
    };

};

1;

