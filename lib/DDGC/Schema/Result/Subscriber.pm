package DDGC::Schema::Result::Subscriber;

use Moo;
extends 'DDGC::Schema::Result';
use DBIx::Class::Candy;

use URI;
use Digest::SHA1;

table 'subscriber';

primary_column email_address => { data_type => 'text' };
primary_column campaign      => { data_type => 'text' };

column verified     => { data_type => 'int', default_value => 0 };
column unsubscribed => { data_type => 'int', default_value => 0 };
column v_key        => { data_type => 'text' };
column u_key        => { data_type => 'text' };
column created      => {
    data_type => 'timestamp with time zone',
    set_on_create => 1,
};

has_many => logs => 'DDGC::Schema::Result::Subscriber::MailLog' => {
    'foreign.email_address' => 'self.email_address',
    'foreign.campaign'      => 'self.campaign',
};

around new => sub {
    my $orig = shift;
    my $self = shift;
    $_[0]->{v_key} = _key();
    $_[0]->{u_key} = _key();
    $orig->( $self, @_ );
};

sub _key {
    Digest::SHA1::sha1_hex( rand() . $$ . {} . time );
}

sub _url {
    my ( $self, $type ) = @_;
    my $u = URI->new( $self->app->config->{ddgc_config}->web_base );
    $u->path(
        sprintf "/s/%s/%s/%s/%s",
        ( $type eq 'u' ? 'u' : 'v' ),
        $self->campaign,
        $self->email_address =~ s/\@/%24/gr,
        ( $type eq 'u' ? $self->u_key : $self->v_key )
    );
    return $u->canonical->as_string;
}

sub verify_url {
    my ( $self ) = @_;
    self->_url( 'v' );
}

sub unsubscribe_url {
    my ( $self ) = @_;
    self->_url( 'u' );
}

sub verify {
    my ( $self, $key ) = @_;
    $self->update({ verified => 1 })
        if ( $key eq $self->v_key );
}

sub unsubscribe {
    my ( $self, $key ) = @_;
    $self->update({ unsubscribed => 1 })
        if ( $key eq $self->u_key );
}

1;
