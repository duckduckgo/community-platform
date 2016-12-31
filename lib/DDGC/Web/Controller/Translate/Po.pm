package DDGC::Web::Controller::Translate::Po;
# ABSTRACT:

use Moose;
BEGIN { extends 'Catalyst::Controller'; }

use DDGC::Config;
use Data::Printer;
use Path::Class;
use DDGC::Util::Po;
use JSON;
use IO::All;
use DateTime;
use namespace::autoclean;

sub base :Chained('/translate/base') :PathPart('po') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
	if (!$c->user) {
		$c->response->redirect($c->chained_uri('My','login'));
		return $c->detach;
	}
	if (!$c->user || !$c->user->translation_manager) {
		$c->response->redirect($c->chained_uri('Root','index',{ admin_required => 1 }));
		return $c->detach;
	}
	$c->add_bc('Po Manager', $c->chained_uri('Translate::Po','index'));
}

sub upload :Chained('base') :Args(0) {
    my ( $self, $c ) = @_;
	if (!$c->user) {
		$c->res->code(403);
		$c->stash->{no_user} = 1;
		return $c->detach;
	}
	if (!$c->user->translation_manager) {
		$c->res->code(403);
		$c->stash->{no_translation_manager} = 1;
		return $c->detach;
	}
	my $uploader = $c->user->username;
	my $upload = $c->req->upload('po_upload');
	my $domain = $c->req->param('token_domain');
	my @entries;
	eval {
		my $entries_ref = read_po_file($upload->tempname);
		@entries = @{$entries_ref};
	};
	if ($@) {
		$c->res->code(403);
		$c->stash->{po_upload_error} = $@;
		return $c->detach;
	}
	unless (@entries) {
		$c->res->code(403);
		$c->stash->{no_entries} = 1;
		return $c->detach;
	}
	my $dir = dir($c->d->config->cachedir,'po');
	$dir->mkpath unless -d $dir;
	my $i = 0;
	my %data = (
		tokens => { map { $i++, $_ } @entries },
		uploader => $uploader,
		created => DateTime->now->epoch,
		filename => $upload->filename,
		$domain ? ( domain => $domain ) : (),
	);
	my $filename = $data{created}.'.'.$data{uploader}.( $domain ? '.'.$domain : '' ).'.json';
	io($dir->file($filename))->print(encode_json(\%data));
	$c->stash->{upload_filename} = $filename;

	$c->d->postman->template_mail(
		1,
		$c->user->email,
		'"DuckDuckGo Translations" <noreply@duckduckgo.com>',
		'[DuckDuckGo Translations] New PO file uploaded',
		'newpo',
		$c->stash,
		Cc => $c->d->config->error_email,
	);

}

sub index :Chained('base') :PathPart('') :Args(0) {
    my ( $self, $c ) = @_;
    $c->bc_index;
	my $dir = io(dir($c->d->config->cachedir,'po')->stringify);
	my @pos;
	for (keys %$dir) {
		next if $_ =~ /^\./;
		my $link = $_;
		push @pos, {
			%{decode_json(io($dir->{$_})->slurp)},
			link => $link,
		};
	}
	@pos = sort { $a->{created} <=> $b->{created} } @pos;
	$c->stash->{po_list} = \@pos;
}

sub po :Chained('base') :PathPart('') :CaptureArgs(1) {
    my ( $self, $c, $po ) = @_;
	$c->stash->{po_filename} = $po;
	$c->stash->{po} = decode_json(io(file($c->d->config->cachedir,'po',$po)->stringify)->slurp);
	$c->add_bc($po);
}

sub view :Chained('po') :PathPart('') :Args(0) {
	my ( $self, $c ) = @_;
	if ($c->req->param('token_domain')) {
		$c->response->redirect(
			$c->chained_uri(
				'Translate::Po',
				'compare',
				$c->stash->{po_filename},
				$c->req->param('token_domain')
			)
		);
		return $c->detach;
	}
	if ($c->req->param('delete')) {
		file($c->d->config->cachedir,'po',$c->stash->{po_filename})->remove;
		$c->response->redirect(
			$c->chained_uri(
				'Translate::Po',
				'index',
			)
		);
		return $c->detach;
	}
    $c->stash->{token_domains} = [$c->d->rs('Token::Domain')->search()->all];
}

sub domain :Chained('po') :PathPart('') :CaptureArgs(1) {
	my ( $self, $c, $domain ) = @_;
	$c->stash->{token_domain} = $c->d->rs('Token::Domain')->find({ key => $domain });
	if (!$c->stash->{token_domain}) {
		$c->response->redirect($c->chained_uri('Translate::Po','index'));
		return $c->detach;
	}
}

sub compare :Chained('domain') :PathPart('') :Args(0) {
	my ( $self, $c ) = @_;
	$c->stash->{compare_result} = $c->stash->{token_domain}->analyze_po_entries(values %{$c->stash->{po}->{tokens}});
}

sub migrate :Chained('domain') :PathPart('migrate') :Args(0) {
	my ( $self, $c ) = @_;
	if (!$c->user || !$c->user->admin) {
		$c->response->redirect($c->chained_uri(
			'Translate::Po',
			'compare',
			$c->stash->{po_filename},
			$c->req->param('token_domain'),
		));
		return $c->detach;
	}
	$c->stash->{new_tokens} = [$c->stash->{token_domain}->migrate_po_entries(values %{$c->stash->{po}->{tokens}})];
	file($c->d->config->cachedir,'po',$c->stash->{po_filename})->remove;
}

__PACKAGE__->meta->make_immutable;

1;
