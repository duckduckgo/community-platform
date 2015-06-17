package DDGC::Postman;
# ABSTRACT: Mail functions

use Moose;
use Email::Sender::Simple qw( sendmail );
use Email::Simple;
use Email::Simple::Creator;
use Email::MIME;
use Email::Sender::Transport::SMTP;
use Email::Sender::Transport::Sendmail;
use Email::Sender::Transport::Test;
use HTML::FormatText::WithLinks;
use Data::Dumper;
use IO::All;

has ddgc => (
	isa => 'DDGC',
	is => 'ro',
	required => 1,
	weak_ref => 1,
);

has transport => (
	does => 'Email::Sender::Transport',
	is => 'ro',
	lazy_build => 1,
);

sub _build_transport {
	my ( $self ) = @_;
	return Email::Sender::Transport::Test->new if $self->ddgc->config->mail_test;
	return Email::Sender::Transport::Sendmail->new unless $self->ddgc->config->smtp_host;
	my %smtp_args;
	$smtp_args{host} = $self->ddgc->config->smtp_host;
	$smtp_args{ssl} = $self->ddgc->config->smtp_ssl;
	$smtp_args{sasl_username} = $self->ddgc->config->smtp_sasl_username if $self->ddgc->config->smtp_sasl_username;
	$smtp_args{sasl_password} = $self->ddgc->config->smtp_sasl_password if $self->ddgc->config->smtp_sasl_password;
	return Email::Sender::Transport::SMTP->new({ %smtp_args });
}

has plaintext_formatter => (
	isa => 'HTML::FormatText::WithLinks',
	is  => 'ro',
	lazy_build => 1,
);
sub _build_plaintext_formatter {
	HTML::FormatText::WithLinks->new(
		unique_links => 1,
	);
}

sub mail {
	my ( $self, $verified, $to, $from, $subject, $body, %extra_headers ) = @_;
	return unless $verified;
	die __PACKAGE__."->mail needs to, from, subject, body" unless $body && $subject && $to && $from;
	$subject =~ s/\n/ /g;
	my $email = Email::Simple->create(
		header => [
			To      => $to,
			From    => $from,
			Subject => $subject,
			%extra_headers,
		],
		body => $body,
	);
	my @return = sendmail($email, { transport => $self->transport });
	if ($self->ddgc->config->mail_test && $self->ddgc->config->mail_test_log) {
		my @deliveries = $self->transport->deliveries;
		io($self->ddgc->config->mail_test_log)->append(Dumper \@deliveries);
	}
	return @return;
}

sub template_mail {
	my ( $self, $verified, $to, $from, $subject, $template, $stash, %extra ) = @_;
	return unless $verified;
	$stash->{email_template} = "email/".$template.".tx";
	my $body = $self->ddgc->xslate->render('email/base.tx',$stash);
	return $self->html_mail($verified, $to, $from, $subject, $body, %extra);
}

sub html_mail {
	my ( $self, $verified, $to, $from, $subject, $body, %extra ) = @_;
	return unless $verified;
	die __PACKAGE__."->mail needs to, from, subject, body" unless $body && $subject && $to && $from;

	my @parts = defined $extra{parts}
		? (@{delete $extra{parts}})
		: ();

	my $email = Email::MIME->create(
		attributes => {
			content_type => 'multipart/alternative',
		},
		header_str => [
			To      => $to,
			From    => $from,
			Subject => $subject,
			%extra,
		],
		parts => [
			Email::MIME->create(
				attributes => {
					content_type => 'text/plain; charset="UTF-8"',
					content_transfer_encoding => '8bit',
				},
				body => $self->plaintext_formatter->parse($body),
			),
			Email::MIME->create(
				attributes => {
					content_type => 'text/html; charset="UTF-8"',
					content_transfer_encoding => '8bit',
				},
				body => $body,
			),
			map {
				Email::MIME->create(%{$_});
			} @parts
		],
	);

	my @return = sendmail($email, { transport => $self->transport });
	if ($self->ddgc->config->mail_test && $self->ddgc->config->mail_test_log) {
		my @deliveries = $self->transport->deliveries;
		io($self->ddgc->config->mail_test_log)->append(Dumper \@deliveries);
	}
	return @return;
}

no Moose;
__PACKAGE__->meta->make_immutable;
