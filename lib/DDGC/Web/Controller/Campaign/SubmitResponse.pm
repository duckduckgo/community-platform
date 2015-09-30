package DDGC::Web::Controller::Campaign::SubmitResponse;
# ABSTRACT: Retrieve / mail responses for Share Campaign

use Moose;
BEGIN { extends 'Catalyst::Controller'; }

use DDGC::Config;
use Try::Tiny;
use DateTime;
use DateTime::Duration;
use Email::Valid;

sub base :Chained('/base') :PathPart('campaign') :CaptureArgs(0) {
	my ( $self, $c ) = @_;
	$c->stash->{not_last_url} = 1;
	if (!$c->user) {
		$c->response->status(403);
		$c->stash->{x} = { ok => 0, errstr => "Not logged in!"};
		$c->forward( $c->view('JSON') );
		return $c->detach;
	}
	elsif (!$c->req->param('campaign_name')) {
		$c->response->status(403);
		$c->stash->{x} = {
			ok => 0, no_campaign => 1,
			errstr => "No campaign info supplied!"
		};
		$c->forward( $c->view('JSON') );
		return $c->detach;
	}
	elsif ($c->user->responded_campaign($c->req->param('campaign_name'))) {
		$c->response->status(403);
		$c->stash->{x} = {
			ok => 0, already_responded => 1,
			errstr => "You already responded to these questions. Thank you!"
		};
		$c->forward( $c->view('JSON') );
		return $c->detach;
	}
	elsif ($c->user->get_first_available_campaign ne $c->req->param('campaign_name')) {
		$c->response->status(403);
		$c->stash->{x} = {
			ok => 0, no_access_yet => 1,
			errstr => "This is not yet open",
		};
		$c->forward( $c->view('JSON') );
		return $c->detach;
	}
}

sub respond : Chained('base') : PathPart('respond') : Args(0) {
	my ( $self, $c ) = @_;
	$c->require_action_token;
	$c->stash->{referer} = $c->session->{wear_referer};

	my $to = $c->d->config->share_email // 'sharewear@duckduckgo.com';
	my $from = 'noreply@duck.co';
	my $username = $c->user->username;
	my $campaign_name = $c->req->param('campaign_name');;
	my $campaign = $c->d->config->campaigns->{ $campaign_name };
	my $short_response = 0;
	my $flag_response = 0;

	if ( $campaign_name eq 'share' && length( $c->req->param( 'question1' ) ) < 35 ) {
		$c->response->status(403);
		$c->stash->{x} = {
			ok => 0, fields_empty => 1,
			errstr => "Please provide a little more info on how you discovered DuckDuckGo.",
		};
		$c->forward( $c->view('JSON') );
		return $c->detach;
	}

	my $response_length = length(
		$c->req->param( 'question1' ) . $c->req->param( 'question2' ) .
		$c->req->param( 'question3' ) . $c->req->param( 'question4' ) .
		$c->req->param( 'question5' ) . $c->req->param( 'question6' )
	);

	if ( $response_length < $campaign->{min_length} + 20 ) {
		$flag_response = 1;
		if ( $response_length < $campaign->{min_length} ) {
			$short_response = 1;
		}
	}

	for (1..6) {
		next if ( ! $campaign->{ 'question' . $_ } );
		if (!$c->req->param( 'question' . $_ )) {
			$short_response = 1;
		}
		$c->stash->{ 'question' . $_ } = $campaign->{ 'question' . $_ };
		$c->stash->{ 'answer' . $_ } = $c->req->param( 'question' . $_ );
	}

	if ($short_response) {
		$c->response->status(403);
		$c->stash->{x} = {
			ok => 0, fields_empty => 1,
			errstr => "Your responses are too short. Please add more explanation.",
		};
		$c->forward( $c->view('JSON') );
		return $c->detach;
	}

	if ($c->req->param('question7')) {
		$c->stash->{campaign_email} = Email::Valid->address($c->req->param('question7'));
		if (!$c->stash->{campaign_email}) {
			$c->response->status(403);
			$c->stash->{x} = {
				ok => 0, invalid_email => 1,
				errstr => "This email address appears to be invalid.",
			};
			$c->forward( $c->view('JSON') );
			return $c->detach;
		}

		if (lc($c->stash->{campaign_email}) eq lc($c->user->email)) {
			$c->stash->{campaign_email_is_account_email} = 1;
		}
		else {
			my $data = $c->user->data || {};
			$data->{wear_email_verify_token} = $c->d->uid;
			$c->user->update({ data => $data });
			$c->stash->{wear_email_verify_link} =
			    $c->chained_uri('My','wear_email_verify',$c->user->lowercase_username,$data->{wear_email_verify_token});
			my $error = 0;
			try {
				$c->d->postman->template_mail(
					1, $c->stash->{campaign_email}, $from,
					'[DuckDuckGo Community] ' . $c->user->username . ', thank you for participating in Share it & Wear it. Please verify your email address.',
					'wearemail',$c->stash);
			}
			catch {
				$error = 1;
			};

			if ($error) {
				$c->response->status(500);
				$c->stash->{x} = {
					ok => 0, mailer_error => 1,
					errstr => "Sorry, there was a problem submitting your response. Please try again later."
				};
				$c->forward( $c->view('JSON') );
				return $c->detach;
			}

		}
	}

	my $subject_extra = '';
	my $bad_response;
	if ($campaign_name eq 'share') {
		my @first = (
			'coupon', 'facebook',
			'freebie', 'free',
		);
		my @second = (
			'now',
			'right now',
			'just did',
			'just now',
			'just signed up',
			'just downloaded',
			'just started',
			'new',
			"i'm new",
			'im new',
		);
		$bad_response = grep { _answer_is_mostly( lc($c->req->param('question1')), $_ ) } @first;
		$bad_response = grep { _answer_is_mostly( lc($c->req->param('question2')), $_ ) } @second if !$bad_response;

		if ( $c->stash->{referer} ) {

			$bad_response =
				grep { index( $c->stash->{referer}, $_ ) >= 0 }
					( qw/ coupon freebie free deal steal discount / );

			my $uri = URI->new( $c->stash->{referer} );
			my $domain = $uri->host;
			$bad_response =
				grep { $domain =~ /$_$/ }
					( qw/ .biz .info .deals / );

			$flag_response =
				grep { $domain =~ /$_/ }
					(qw/ facebook twitter reddit /);

		}

		$flag_response = ( lc( $c->req->param( 'question4' ) ) ne 'yes' );

		my $q5 = lc( $c->req->param( 'question5' ) );
		my @fifth = (
			'none',
			"don't know",
			'dont know',
			"all of them",
			"all",
			"unsure",
			"duckduckgo",
			"google",
			"answer",
			'?',
		);
		$flag_response = grep { _answer_is_mostly( $q5, $_ ) } @fifth if !$flag_response;

		my $q6 = lc( $c->req->param( 'question6' ) );
		my @sixth = (
			'!bang',
			'none',
			"don't know",
			'dont know',
			"all of them",
			"all",
			"unsure",
			"duckduckgo",
			"google",
			"bang",
			'?'
		);
		$flag_response = grep { _answer_is_mostly( $q6, $_ ) } @sixth if !$flag_response;

		for my $n (1..6) {
			my $q = lc( $c->req->param( "question$n" ) );
			$flag_response = grep { index( $q, $_ ) >= 0 }
				( qw/ qwe asd zxc / );
		}

		($flag_response) && ($subject_extra = '** NEEDS REVIEW ** ');
		($bad_response) && ($subject_extra = '** BAD RESPONSE ** ');
		my $report_url = $c->chained_uri( 'Admin::Campaign', 'bad_user_response', { user => $username, campaign => $campaign_name} );
		$c->stash->{'extra'} = <<"BAD_RESPONSE_LINK"
		<a href="$report_url">
			Report bad responses
		</a>
BAD_RESPONSE_LINK
	}

	my $subject = "${subject_extra}$campaign_name response from $username";
	my $error = 0;
	try {
		$c->d->postman->template_mail(
			1, $to, $from, $subject, 'campaign', $c->stash
		);
	}
	catch {
		$error = 1;
	};

	if ($error) {
		$c->response->status(500);
		$c->stash->{x} = {
			ok => 0, mailer_error => 1,
			errstr => "Sorry, there was a problem submitting your response. Please try again later."
		};
		$c->forward( $c->view('JSON') );
		return $c->detach;
	}

	my $response = $c->user->set_responded_campaign($campaign_name);
	$response->update( ($c->stash->{campaign_email_is_account_email}) ?
		{ campaign_email_is_account_email => 1 } :
		{ campaign_email => $c->stash->{campaign_email} }
	);
	($bad_response) && $response->update({ bad_response => 1 });

	my $return_on;
	my $coupon;

	if ($campaign_name eq 'share') {
		$return_on = (DateTime->now + DateTime::Duration->new( days => 30 ))->strftime("%B %e");
	}
	if ($campaign_name eq 'share_followup') {
		$coupon = $c->user->get_coupon($campaign_name, { create => 1 }) || "NO COUPON :(";
	}
	$c->stash->{x} = {
		ok => 1, return_on => $return_on, coupon => $coupon,
		campaign_id => $c->req->param('campaign_id'),
	};
	$c->forward( $c->view('JSON') );
	return $c->detach;
}

sub _answer_is_mostly {
	my ($answer, $text) = @_;
	return 0 if (length($answer) > (length($text) + 5));
	return 1 if (index($answer, $text) >= 0);
	return 0;
}

__PACKAGE__->meta->make_immutable;

1;

