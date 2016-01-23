#!/bin/perl

use LWP::UserAgent;
use Encode;

my $ua = LWP::UserAgent->new;
$ua->timeout(10);
$ua->env_proxy;
$ua->agent("");

my @threadlist = ( 'newsplus', 'mnewsplus', 'bizplus', 'plus' );

my $bbstable = "http://www.2ch.net/bbstable.html";

my $response = $ua->get($bbstable);

if ($response->is_success) {
	my @page = split( '\n', $response->content );
	foreach my $line ( @page ) {
		if ( $line =~ '<A HREF=http://.*</A>' ) {
			my ( $thread_url, $thread_title ) = ( $line =~ /<A HREF=(.*)>(.*)<\/A>$/) ;
			my ( $thread_host, $thread_name ) = ( $thread_url =~ /^(.*)\/(.*)\// );
			my $thread_title_utf8 = encode('utf-8', decode('sjis', $thread_title));

			if ( grep { $_ eq $thread_name } @threadlist ) {
				print $thread_host . " : " . $thread_name . " = " . $thread_title_utf8 . "\n";
			}
		}
	}
} else {
	die $response->status_line;
}
