#!/usr/bin/perl

use LWP::UserAgent;
use Encode;
use CGI;

my $ua = LWP::UserAgent->new;
$ua->timeout(10);
$ua->env_proxy;
$ua->agent("");

my $URL = "http://daily.2ch.net/test/read.cgi/newsplus/1453205001/-3";

# create new CGI object
my $cgi = CGI->new;

print $cgi->charset("utf-8");

# create the HTTP header
print $cgi->header('text/html' -charset => "utf-8",);

# start the HTML
print $cgi->start_html(-title => '2ちゃんねる スレッド', -lang => 'ja', -encoding => 'utf-8');

my $response = $ua->get($URL);

if ($response->is_success) {
	my @page = split( '\n', $response->content );
	foreach my $line ( @page ) {
		if ( $line =~ '^<dt>1' ) {
			my ( $message_date, $message_body ) = ( $line =~ /<dt>1.*<\/a>(.*)<dd>(.*)$/) ;
			my $message_date_utf8 = encode('utf-8', decode('sjis', $message_datetime));
			my $message_body_utf8 = encode('utf-8', decode('sjis', $message_body));

			print $message_date_utf8 . "\n";
			print $message_body_utf8 . "\n";
		}
	}
} else {
	die $response->status_line;
}


# end the HTML
print $cgi->end_html;
