package DDGC::Web::Role::ScreenshotForm;
# ABSTRACT: Form stashing for screenshot IDs (and other stuff perhaps)

use Moose::Role;

sub screenshot_form {
	my ( $self, $c ) = @_;
	$c->stash->{form_id} = $c->req->param('form_id') || $c->next_form_id;
	$c->session->{forms} = {} unless defined $c->session->{forms};
	$c->session->{forms}->{$c->stash->{form_id}} = {}
		unless defined $c->session->{forms}->{$c->stash->{form_id}};
	my @screenshot_ids;
	if (defined $c->session->{forms}->{$c->stash->{form_id}}->{screenshots}) {
		@screenshot_ids = @{$c->session->{forms}->{$c->stash->{form_id}}->{screenshots}};
	} elsif (defined $c->stash->{thread}) {
		@screenshot_ids = $c->stash->{thread}->sorted_screenshots->ids;
		$c->session->{forms}->{$c->stash->{form_id}}->{screenshots} = [@screenshot_ids];
	}
	$c->stash->{screenshots} = [ $c->d->rs('Screenshot')->search({
		id => { -in => [@screenshot_ids] },
	})->all ];
}

sub screenshot_ids {
	my ( $self, $c ) = @_;
	if (defined $c->session->{forms}->{$c->stash->{form_id}}->{screenshots}) {
		return @{$c->session->{forms}->{$c->stash->{form_id}}->{screenshots}};
	}
	return ();
}

1;
