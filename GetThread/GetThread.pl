#!/usr/bin/perl

use LWP::UserAgent;

my $ua = LWP::UserAgent->new;
$ua->timeout(10);
$ua->env_proxy;
$ua->agent("");

my $URL = "http://daily.2ch.net/test/read.cgi/newsplus/1453205001/-3";

my $response = $ua->get($URL);

if ($response->is_success) {
	my @page = split( '\n', $response->content );
	foreach my $line ( @page ) {
		if ( $line =~ '^<dt>1' ) {
			my ( $message ) = ( $line =~ /<dt>1(.*)$/) ;
			my $message_utf8 = encode('utf-8', decode('sjis', $message));

			print $message_utf8 . "\n";
		}
	}
} else {
	die $response->status_line;
}
