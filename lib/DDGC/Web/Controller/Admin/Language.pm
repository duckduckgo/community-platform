package DDGC::Web::Controller::Admin::Language;
# ABSTRACT: Language administration web controller class

use Moose;
BEGIN { extends 'Catalyst::Controller'; }

use namespace::autoclean;

sub base :Chained('/admin/base') :PathPart('language') :CaptureArgs(0) {
	my ( $self, $c ) = @_;
	$c->add_bc('Language editor', $c->chained_uri('Admin::Language','index'));
	$c->stash->{language_options} = [map {
		{ value => $_->id, text => $_->name_in_english }
	} $c->d->rs('Language')->search({},{
		order_by => { -asc => 'me.locale' },
	})->all];
	$c->stash->{country_options} = [map {
		{ value => $_->id, text => $_->name_in_english }
	} $c->d->rs('Country')->search({},{
		order_by => { -asc => 'me.name_in_english' },
	})->all];
}

sub index :Chained('base') :PathPart('') :Args(0) {
	my ( $self, $c ) = @_;
	$c->bc_index;

	if ($c->req->param('save_language')) {
		my %data;
		for (keys %{$c->req->params}) {
			if ($_ =~ m/^language_(\d+)_(.+)$/) {
				my $id = $1;
				my $key = $2;
				$data{$id} = {} unless defined $data{$id};
				$data{$id}->{$key} = $c->req->param($_);
			}
		}
		for my $id (keys %data) {
			my $values = $data{$id};
			for (keys %{$values}) {
				$values->{$_} = undef unless length($values->{$_});
			}
			if ($id > 0) {
				my $language = $c->d->rs('Language')->find($id);
				die "language id ".$_." not found" unless $language;
				for (keys %{$values}) {
					$language->$_($values->{$_});
				}
				$language->update;
				$c->stash->{changed_language_id} = $id;
			} else {
				for (keys %{$values}) {
					delete $values->{$_} unless defined $values->{$_};
				}
				my $new_language = $c->d->rs('Language')->create($values);
				$c->stash->{changed_language_id} = $new_language->id;
			}
		}
	}

	$c->stash->{languages} = [ $c->d->rs('Language')->search({},{
		order_by => { -desc => 'me.updated' },
	})->all ];

}

sub countries :Chained('base') :Args(0) {
	my ( $self, $c ) = @_;
	$c->add_bc('Country editor');

	if ($c->req->param('save_country')) {
		my %data;
		for (keys %{$c->req->params}) {
			if ($_ =~ m/^country_(\d+)_(.+)$/) {
				my $id = $1;
				my $key = $2;
				$data{$id} = {} unless defined $data{$id};
				$data{$id}->{$key} = $c->req->param($_);
			}
		}
		for my $id (keys %data) {
			my $values = $data{$id};
			for (keys %{$values}) {
				$values->{$_} = undef unless length($values->{$_});
			}
			if ($id > 0) {
				my $country = $c->d->rs('Country')->find($id);
				die "country id ".$_." not found" unless $country;
				for (keys %{$values}) {
					$country->$_($values->{$_});
				}
				$country->update;
				$c->stash->{changed_country_id} = $id;
			} else {
				for (keys %{$values}) {
					delete $values->{$_} unless defined $values->{$_};
				}
				my $new_language = $c->d->rs('Country')->create($values);
				$c->stash->{changed_country_id} = $new_language->id;
			}
		}
	}

	$c->stash->{countries} = [ $c->d->rs('Country')->search({},{
		order_by => { -desc => 'me.updated' },
	})->all ];

}

no Moose;
__PACKAGE__->meta->make_immutable;
