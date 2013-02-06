package DDGC::Web::Controller::Duckpan;
use Moose;
use namespace::autoclean;

use DDGC::Config;
use Dist::Data;
use Path::Class;
use Pod::Simple::XHTML;

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/base') :PathPart('duckpan') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
    $c->stash->{title} = 'DuckPAN';
    $c->stash->{duckpan} = $c->d->duckpan;
    $c->add_bc('DuckPAN', $c->chained_uri('duckpan','index'));
}

sub do :Chained('base') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
}

sub index :Chained('do') :Args(0) {
    my ( $self, $c ) = @_;
}

sub logged_in :Chained('do') :PathPart('') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
    if (!$c->user) {
        $c->response->redirect($c->chained_uri('My','login'));
        return $c->detach;
    }
}

sub upload :Chained('do') :Args(0) {
    my ( $self, $c ) = @_;
	if (!$c->user) {
		$c->res->code(403);
		$c->stash->{no_user} = 1;
		return $c->detach;
	}
	my $uploader = $c->user->username;
	my $upload = $c->req->upload('pause99_add_uri_httpupload');
	my $filename = $c->d->config->cachedir.'/'.$upload->filename;
	$upload->copy_to($filename);
	$c->stash->{duckpan_return} = $c->d->duckpan->add_user_distribution($c->user,$filename);
	$c->res->code(403) if (ref $c->stash->{duckpan_return} eq 'HASH');
}

sub module :Chained('base') :CaptureArgs(1) {
    my ( $self, $c, $module ) = @_;
	$c->stash->{duckpan_module} = $module;
	$c->stash->{duckpan_dist_filename} = $c->stash->{duckpan}->modules->{$module};
	return $c->go($c->controller('Root'),'default') unless $c->stash->{duckpan_dist_filename};
	my $f = file($c->stash->{duckpan_dist_filename});
	$c->stash->{duckpan_dist} = Dist::Data->new(
		dir => dir($c->d->config->duckpandir,'x',$f->basename)->stringify,
		filename => $c->stash->{duckpan_dist_filename},
	);
	$c->stash->{duckpan_dist}->extract_distribution;
	$c->add_bc($module, $c->chained_uri('Duckpan','module_index',$module));
}

has pod_parser => (
	isa => 'Pod::Simple::XHTML',
	is => 'ro',
	lazy_build => 1,
);

sub _build_pod_parser {
	my $psx = Pod::Simple::XHTML->new();
	$psx->html_charset('UTF-8');
	$psx->html_header("");
	$psx->html_footer("");
	$psx->index(1);
	return $psx;
}

sub get_html_from_pod {
	my ( $self, $file ) = @_;
	$self->pod_parser->output_string(\my $html);
	$self->pod_parser->parse_file($file);
	return $html;
}

sub module_index :Chained('module') :PathPart('') :Args(0) {
    my ( $self, $c ) = @_;
	$c->stash->{duckpan_module_pod} = $self->get_html_from_pod(
		$c->stash->{duckpan_dist}->file($c->stash->{duckpan_dist}->packages->{$c->stash->{duckpan_module}}->{file})
	);
}

# TODO: Goes into a static generation procedure

# sub module_index :Chained('module') :PathPart('') :Args(0) {
    # my ( $self, $c ) = @_;
	# if ($c->stash->{duckpan_dist}) {
		# my $p = Pod::HTMLEmbed->new;
		# my $filename = $c->stash->{duckpan_dist}->packages->{$c->stash->{duckpan_module}}->{file};
		# $c->stash->{module_pod} = $p->load($c->stash->{duckpan_dist}->file($filename));
	# }
# }

# sub release :Chained('base') :CaptureArgs(2) {
    # my ( $self, $c, $name, $version ) = @_;
	# my ( $release ) = $c->d->db->resultset('DuckPAN::Release')->search({
		# name => $name,
		# version => $version,
	# })->all;
	# return unless $release;
	# $c->stash->{duckpan_release} = $release;
	# $c->stash->{duckpan_dist} = Dist::Data->new($c->d->config->duckpandir.'/'.$release->filename);
# }
# sub release_index :Chained('release') :PathPart('') :Args(0) {}

__PACKAGE__->meta->make_immutable;

1;
