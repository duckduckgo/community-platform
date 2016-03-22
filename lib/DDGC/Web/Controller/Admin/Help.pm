package DDGC::Web::Controller::Admin::Help;
# ABSTRACT: Help administration web controller class

use Moose;
BEGIN { extends 'Catalyst::Controller'; }

use HTML::TokeParser;

use namespace::autoclean;

sub base :Chained('/admin/base') :PathPart('help') :CaptureArgs(0) {
	my ( $self, $c ) = @_;
	$c->add_bc('Help editor', $c->chained_uri('Admin::Help','index'));

	$c->stash->{help_language} = $c->d->rs('Language')->search({ locale => 'en_US' })->one_row;
	die 'english not found?!?!?' unless $c->stash->{help_language};
	$c->stash->{help_language_id} = $c->stash->{help_language}->id;
}

sub index :Chained('base') :PathPart('') :Args(0) {
	my ( $self, $c ) = @_;
	$c->bc_index;

	if ($c->req->param('save_help')) {
		my %data;
		for (keys %{$c->req->params}) {
			if ($_ =~ m/^help_(\d+)_(.+)$/) {
				my $id = $1;
				my $key = $2;
				$data{$id} = {} unless defined $data{$id};
				$data{$id}->{$key} = $c->req->param($_);
			}
		}
		for my $id (keys %data) {
			my %values = %{$data{$id}};
			my %help_values;
			my %help_content_values;
			for (keys %values) {
				if ($_ =~ m/^content_(.*)$/) {
					$help_content_values{$1} = $values{$_};
				} else {
					$help_values{$_} = $values{$_};
				}
			}
			my $help;
			if ($id > 0) {
				$help = $c->d->rs('Help')->find($id);
				die "help id ".$_." not found" unless $help;
				$help_values{help_category_id} ||= undef;
				for (keys %help_values) {
					$help->$_($help_values{$_});
				}
				$help->update;
			} else {
				$help = $c->d->rs('Help')->create(\%help_values);
			}
			$c->stash->{changed_help_id} = $help->id;
			my $help_content = $help->search_related('help_contents',{
				language_id => $c->stash->{help_language_id},
			})->one_row;
			if ($help_content) {
				for (keys %help_content_values) {
					$help_content->$_($help_content_values{$_});
				}
				$help_content->update;
			} else {
				$help_content_values{language_id} = $c->stash->{help_language_id};
				$help_content = $help->create_related(
					'help_contents',
					\%help_content_values
				);
			}

			# Now it exists! Index that article.
			$c->d->help->index(
				uri => $help_content->id,
				body => $help_content->content,
				language_id => $help_content->language_id,
				id => $help->id,
				title => $help_content->title,
				is_html => $help_content->raw_html,
				is_markup => !$help_content->raw_html,
			);
		}
	}

	$c->stash->{category_options} = [map {
		{ value => $_->id, text => $_->key }
	} $c->d->rs('Help::Category')->search({},{
		order_by => { -asc => 'me.key' },
	})->all];

	$c->stash->{helps} = [ $c->d->rs('Help')->search({},{
		order_by => [ { -asc => 'help_category.sort' }, { -asc => 'me.sort' } ],
		prefetch => [ 'help_contents', { help_category => [ 'help_category_contents','helps' ] } ],
	})->all ];

}

sub categories :Chained('base') :Args(0) {
	my ( $self, $c ) = @_;
	$c->add_bc('Categories editor');

	if ($c->req->param('save_category')) {
		my %data;
		for (keys %{$c->req->params}) {
			if ($_ =~ m/^category_(\d+)_(.+)$/) {
				my $id = $1;
				my $key = $2;
				$data{$id} = {} unless defined $data{$id};
				$data{$id}->{$key} = $c->req->param($_);
			}
		}
		for my $id (keys %data) {
			my %values = %{$data{$id}};
			my %category_values;
			my %category_content_values;
			for (keys %values) {
				if ($_ =~ m/^content_(.*)$/) {
					$category_content_values{$1} = $values{$_};
				} else {
					$category_values{$_} = $values{$_};
				}
			}
			my $category;
			if ($id > 0) {
				$category = $c->d->rs('Help::Category')->find($id);
				die "help category id ".$_." not found" unless $category;
				for (keys %category_values) {
					$category->$_($category_values{$_});
				}
				$category->update;
			} else {
				$category = $c->d->rs('Help::Category')->create(\%category_values);
			}
			$c->stash->{changed_category_id} = $category->id;
			my $help_category_content = $category->search_related('help_category_contents',{
				language_id => $c->stash->{help_language_id},
			})->one_row;
			if ($help_category_content) {
				for (keys %category_content_values) {
					$help_category_content->$_($category_content_values{$_});
				}
				$help_category_content->update;
			} else {
				$category_content_values{language_id} = $c->stash->{help_language_id};
				$help_category_content = $category->create_related(
					'help_category_contents',
					\%category_content_values
				);
			}
		}
	}

	$c->stash->{categories} = [ $c->d->rs('Help::Category')->search({},{
		order_by => { -asc => 'me.sort' },
	})->all ];

}

sub media :Chained('base') :Args(2) {
	my ( $self, $c, $category_key, $help_key ) = @_;
	$c->stash->{help_category} = $c->d->rs('Help::Category')->find({ key => $category_key });
	$c->stash->{help} = $c->stash->{help_category}->search_related('helps',{
		key => $help_key,
	})->one_row;
	if (!$c->stash->{help}->content_by_language_id($c->stash->{help_language_id})->raw_html) {
		$c->stash->{no_raw_html} = 1;
		return $c->detach;
	}
	my $html = $c->stash->{help}->content_by_language_id($c->stash->{help_language_id})->content;
	my $p = HTML::TokeParser->new(\$html);
	my %files;
	my $help_user = $c->d->find_user($c->d->is_live ? 'help' : 'testone')->db;
	while (my $img = $p->get_tag("img")) {
		my $src = $img->[1]->{src};
		my $file;
		if ($src =~ m!^/customer/portal/attachments/!) {
			$file = $c->d->resultset('Media')->create_via_url($help_user,'http://help.dukgo.com'.$src);
		} elsif ($src =~ m!^https{0,1}://!) {
			$file = $c->d->resultset('Media')->create_via_url($help_user,$src);
		}
		if ($file) {
			$files{$src} = '/media/'.$file->filename;
			$html =~ s/{\Q$src\E}/$files{$src}/g;
			my $help_content = $c->stash->{help}->content_by_language_id($c->stash->{help_language_id});
			$help_content->content($html);
			$help_content->update;
		}
	}
	$c->stash->{media_files} = \%files;
}

no Moose;
__PACKAGE__->meta->make_immutable;
