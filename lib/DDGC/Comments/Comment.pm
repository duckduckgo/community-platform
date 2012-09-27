package DDGC::Comments::Comment;

use Moose;
use URI::Find::Simple 'change_uris';

has db => (
	isa => 'DDGC::DB::Result::Comment',
	is => 'ro',
	weak_ref => 1,
	required => 1,
	handles => [qw(
		id
		users_id
		context
		context_id
		created
		updated
		parent_id
		user
		parent
	)],
	# DOES NOT HANDLE 'children'!!!! CAUSE WE HANDLE THAT ON OUR OWN!!!
);

has children => (
	isa => 'ArrayRef[DDGC::Comments::Comment]',
	is => 'ro',
	required => 1,
);

sub has_children {
	my ( $self ) = @_;
	return @{$self->children} ? 1 : 0;
}

sub content {
    my $content = shift->db->content;
    $content =~ s/&/&amp;/g; $content =~ s/>/&gt;/g; $content =~ s/</&lt;/g; $content =~ s/\n/<br>/g;
    $content = change_uris($content, sub { "<a href=\"$_[0]\">$_[0]</a>" } );
}

has comments_context => (
	isa => 'DDGC::Comments',
	is => 'ro',
	required => 1,
	weak_ref => 1,
);

1;
