package DDGC::DB::Result::Token::Language::Translation;
# ABSTRACT: A translation

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use Regexp::Common 'profanity';
use DateTime;
use Locale::Simple;

use namespace::autoclean;

table 'token_language_translation';

# Yes, this isn't how XSS is handled - we simply want to reduce moderation overhead
my $html_re = qr/<[^\w<>]*(?:[^<>"'\s]*:)?[^\w<>]*(?:\W*s\W*c\W*r\W*i\W*p\W*t|\W*f\W*o\W*r\W*m|\W*s\W*t\W*y\W*l\W*e|\W*s\W*v\W*g|\W*m\W*a\W*r\W*q\W*u\W*e\W*e|(?:\W*l\W*i\W*n\W*k|\W*o\W*b\W*j\W*e\W*c\W*t|\W*e\W*m\W*b\W*e\W*d|\W*a\W*p\W*p\W*l\W*e\W*t|\W*p\W*a\W*r\W*a\W*m|\W*i?\W*f\W*r\W*a\W*m\W*e|\W*b\W*a\W*s\W*e|\W*b\W*o\W*d\W*y|\W*m\W*e\W*t\W*a|\W*i\W*m\W*a?\W*g\W*e?|\W*v\W*i\W*d\W*e\W*o|\W*a\W*u\W*d\W*i\W*o|\W*b\W*i\W*n\W*d\W*i\W*n\W*g\W*s|\W*s\W*e\W*t|\W*i\W*s\W*i\W*n\W*d\W*e\W*x|\W*a\W*n\W*i\W*m\W*a\W*t\W*e)[^>\w])|(?:<\w[\s\S]*[\s\0\/]|['"])(?:formaction|style|background|src|lowsrc|ping|on(?:d(?:e(?:vice(?:(?:orienta|mo)tion|proximity|found|light)|livery(?:success|error)|activate)|r(?:ag(?:e(?:n(?:ter|d)|xit)|(?:gestur|leav)e|start|drop|over)?|op)|i(?:s(?:c(?:hargingtimechange|onnect(?:ing|ed))|abled)|aling)|ata(?:setc(?:omplete|hanged)|(?:availabl|chang)e|error)|urationchange|ownloading|blclick)|Moz(?:M(?:agnifyGesture(?:Update|Start)?|ouse(?:PixelScroll|Hittest))|S(?:wipeGesture(?:Update|Start|End)?|crolledAreaChanged)|(?:(?:Press)?TapGestur|BeforeResiz)e|EdgeUI(?:C(?:omplet|ancel)|Start)ed|RotateGesture(?:Update|Start)?|A(?:udioAvailable|fterPaint))|c(?:o(?:m(?:p(?:osition(?:update|start|end)|lete)|mand(?:update)?)|n(?:t(?:rolselect|extmenu)|nect(?:ing|ed))|py)|a(?:(?:llschang|ch)ed|nplay(?:through)?|rdstatechange)|h(?:(?:arging(?:time)?ch)?ange|ecking)|(?:fstate|ell)change|u(?:echange|t)|l(?:ick|ose))|m(?:o(?:z(?:pointerlock(?:change|error)|(?:orientation|time)change|fullscreen(?:change|error)|network(?:down|up)load)|use(?:(?:lea|mo)ve|o(?:ver|ut)|enter|wheel|down|up)|ve(?:start|end)?)|essage|ark)|s(?:t(?:a(?:t(?:uschanged|echange)|lled|rt)|k(?:sessione|comma)nd|op)|e(?:ek(?:complete|ing|ed)|(?:lec(?:tstar)?)?t|n(?:ding|t))|u(?:ccess|spend|bmit)|peech(?:start|end)|ound(?:start|end)|croll|how)|b(?:e(?:for(?:e(?:(?:scriptexecu|activa)te|u(?:nload|pdate)|p(?:aste|rint)|c(?:opy|ut)|editfocus)|deactivate)|gin(?:Event)?)|oun(?:dary|ce)|l(?:ocked|ur)|roadcast|usy)|a(?:n(?:imation(?:iteration|start|end)|tennastatechange)|fter(?:(?:scriptexecu|upda)te|print)|udio(?:process|start|end)|d(?:apteradded|dtrack)|ctivate|lerting|bort)|DOM(?:Node(?:Inserted(?:IntoDocument)?|Removed(?:FromDocument)?)|(?:CharacterData|Subtree)Modified|A(?:ttrModified|ctivate)|Focus(?:Out|In)|MouseScroll)|r(?:e(?:s(?:u(?:m(?:ing|e)|lt)|ize|et)|adystatechange|pea(?:tEven)?t|movetrack|trieving|ceived)|ow(?:s(?:inserted|delete)|e(?:nter|xit))|atechange)|p(?:op(?:up(?:hid(?:den|ing)|show(?:ing|n))|state)|a(?:ge(?:hide|show)|(?:st|us)e|int)|ro(?:pertychange|gress)|lay(?:ing)?)|t(?:ouch(?:(?:lea|mo)ve|en(?:ter|d)|cancel|start)|ime(?:update|out)|ransitionend|ext)|u(?:s(?:erproximity|sdreceived)|p(?:gradeneeded|dateready)|n(?:derflow|load))|f(?:o(?:rm(?:change|input)|cus(?:out|in)?)|i(?:lterchange|nish)|ailed)|l(?:o(?:ad(?:e(?:d(?:meta)?data|nd)|start)?|secapture)|evelchange|y)|g(?:amepad(?:(?:dis)?connected|button(?:down|up)|axismove)|et)|e(?:n(?:d(?:Event|ed)?|abled|ter)|rror(?:update)?|mptied|xit)|i(?:cc(?:cardlockerror|infochange)|n(?:coming|valid|put))|o(?:(?:(?:ff|n)lin|bsolet)e|verflow(?:changed)?|pen)|SVG(?:(?:Unl|L)oad|Resize|Scroll|Abort|Error|Zoom)|h(?:e(?:adphoneschange|l[dp])|ashchange|olding)|v(?:o(?:lum|ic)e|ersion)change|w(?:a(?:it|rn)ing|heel)|key(?:press|down|up)|(?:AppComman|Loa)d|no(?:update|match)|Request|zoom))[\s\0]*=/;

sub u { shift->token_language->u }

sub event_related {
	my ( $self ) = @_;
	my @related = $self->token_language->event_related;
	push @related, ['DDGC::DB::Result::Token::Language', $self->token_language_id];
	return @related;
}

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

column msgstr0 => {
	data_type => 'text',
	is_nullable => 0,
};
sub msgstr { shift->msgstr0(@_) }

column msgstr1 => {
	data_type => 'text',
	is_nullable => 1,
};

column msgstr2 => {
	data_type => 'text',
	is_nullable => 1,
};

column msgstr3 => {
	data_type => 'text',
	is_nullable => 1,
};

column msgstr4 => {
	data_type => 'text',
	is_nullable => 1,
};

column msgstr5 => {
	data_type => 'text',
	is_nullable => 1,
};

sub msgstr_index_max { 5 }

column data => {
	data_type => 'text',
	is_nullable => 1,
	serializer_class => 'YAML',
};

column notes => {
	data_type => 'text',
	is_nullable => 1,
};

column token_language_id => {
	data_type => 'bigint',
	is_nullable => 0,
};

column check_result => {
	data_type => 'int',
	is_nullable => 1,
};

column check_timestamp => {
	data_type => 'timestamp with time zone',
	is_nullable => 1,
};
sub checked { shift->check_timestamp ? 1 : 0 }

column check_users_id => {
	data_type => 'bigint',
	is_nullable => 1,
};

sub invalid {
	my ( $self ) = @_;
	return ( $self->checked && !$self->check_result )
		? 1
		: 0;
}

#column users_id => {
#	data_type => 'bigint',
#	is_nullable => 1,
#};

column username => {
	data_type => 'text',
	is_nullable => 0,
};

column created => {
	data_type => 'timestamp with time zone',
	set_on_create => 1,
};

column updated => {
	data_type => 'timestamp with time zone',
	set_on_create => 1,
	set_on_update => 1,
};

#belongs_to 'user', 'DDGC::DB::Result::User', 'users_id';
belongs_to 'user', 'DDGC::DB::Result::User', { 'foreign.username' => 'self.username' };
belongs_to 'check_user', 'DDGC::DB::Result::User', 'check_users_id', { join_type => 'left' };

belongs_to 'token_language', 'DDGC::DB::Result::Token::Language', 'token_language_id', {
	on_delete => 'cascade',
};

has_many 'token_language_translation_votes', 'DDGC::DB::Result::Token::Language::Translation::Vote', 'token_language_translation_id', {
	cascade_delete => 1,
};
sub votes { shift->token_language_translation_votes(@_) }

before insert => sub {
	my ( $self ) = @_;
	$self->sprintf_check;
	$self->basic_content_checks;
};

after insert => sub {
  my ( $self ) = @_;
  $self->add_event('create');
  $self->user->add_context_notification('translation_votes',$self);
};

sub user_voted {
	my ( $self, $user ) = @_;
	my $result = $self->search_related('token_language_translation_votes',{
		users_id => $user->db->id,
	})->all;
}

sub force_check {
	my ( $self ) = @_;
	$self->sprintf_check;
	$self->basic_content_checks;
	$self->update;
}

sub sprintf_check {
	my ( $self ) = @_;
	return if $self->check_users_id;
	my $msgid = $self->token_language->token->msgid;
	$self->check_timestamp(DateTime->now);
	$self->check_result(Locale::Simple::sprintf_compare(
		$msgid,
		$self->msgstr0
	) ? 1 : 0);
	my $msgid_plural = $self->token_language->token->msgid_plural;
	if ($msgid_plural) {
		for my $keyno (1..$self->msgstr_index_max) {
			my $key = 'msgstr'.$keyno;
			next unless $self->$key;
			$self->check_result(Locale::Simple::sprintf_compare(
				$msgid_plural,
				$self->$key
			) ? 1 : 0);
		}
	}
}

sub basic_content_checks {
	my ( $self ) = @_;
	my @msgstrs = grep { $_ } map { my $msgstr = "msgstr$_" ; $self->$msgstr } 0..5;
	for my $msgstr ( @msgstrs ) {
		$self->check_result(0) if $msgstr =~ /$RE{profanity}/i;
		$self->check_result(0) if $msgstr =~ /$html_re/gi;
	}
}

sub vote_count {
	my ( $self ) = @_;
	$self->token_language_translation_votes->count;
}

sub set_check {
	my ( $self, $user, $check ) = @_;
	if ($user->translation_manager) {
		$self->check_result($check ? 1 : 0);
		$self->check_users_id($user->id);
		$self->check_timestamp(DateTime->now);
	} else {
		die "you are not a translation manager, you cant check the translation!";
	}
}

sub set_user_vote {
	my ( $self, $user, $vote ) = @_;
	return if $user->id == $self->user->id;
	return unless $user->can_speak($self->token_language->token_domain_language->language->locale);
	if ($vote) {
		my $voted = $self->search_related('token_language_translation_votes',{
			users_id => $user->db->id,
		})->one_row;
		unless ($voted) {
			$self->create_related('token_language_translation_votes',{
				users_id => $user->db->id,
			});
		}
	} else {
		$self->search_related('token_language_translation_votes',{
			users_id => $user->db->id,
		})->delete;
	}
}

sub key {
	my ( $self ) = @_;
	my $key;
	for (0..$self->msgstr_index_max) {
		my $func = 'msgstr'.$_;
		$key .= $self->$func ? $self->$func : '';
	}
	return $key;
}



no Moose;
__PACKAGE__->meta->make_immutable ( inline_constructor => 0 );
