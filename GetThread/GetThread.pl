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
	my $cnt = 1;
	foreach my $line ( @page ) {
		print $cnt . " : " . $line . "\n";
	}
} else {
	die $response->status_line;
}
