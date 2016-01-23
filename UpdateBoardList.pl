#!/bin/perl

use LWP::UserAgent;
use Encode;

my $ua = LWP::UserAgent->new;
$ua->timeout(10);
$ua->env_proxy;
$ua->agent("");

my @boardlist = ( 'newsplus', 'mnewsplus', 'bizplus', 'plus' );

my $bbstable = "http://www.2ch.net/bbstable.html";

my $response = $ua->get($bbstable);

if ($response->is_success) {
	my @page = split( '\n', $response->content );
	foreach my $line ( @page ) {
		if ( $line =~ '<A HREF=http://.*</A>' ) {
			my ( $board_url, $board_title ) = ( $line =~ /<A HREF=(.*)>(.*)<\/A>$/) ;
			my ( $board_host, $board_name ) = ( $board_url =~ /^(.*\/)(.*)\// );
			my $board_title_utf8 = encode('utf-8', decode('sjis', $board_title));

			if ( grep { $_ eq $board_name } @boardlist ) {
				print $board_host . " : " . $board_name . " = " . $board_title_utf8 . "\n";
#				$sql = "select count(*) from board where name = '" . $thread_name . "';";
			}
		}
	}
} else {
	die $response->status_line;
}
