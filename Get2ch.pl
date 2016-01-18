#!/usr/bin/perl

# スレッド一覧の読み込み・表示のサンプル

use LWP::UserAgent;
use Encode;

my $ua = LWP::UserAgent->new;
$ua->timeout(10);
$ua->env_proxy;
$ua->agent("");

# my $response = $ua->get('http://daily.2ch.net/newsplus/subback.html');
my $response = $ua->get('http://localhost/subback.html');

if ($response->is_success) {
	my @page = split( '\n', $response->content );
	my $cnt = 1;
	foreach my $line ( @page ) {
		# <a href="1452481229/l50">855: 【社会】震災４年１０か月 ボランティアが不明者捜索 [無断転載禁止]&#169;2ch.net (15)</a>
		if ( $line =~ '^<a href=.*</a>$' ) {
			my ( $id, $title ) = ( $line =~ /<a href="(\d+)\/.*: (.*)<\/a>/) ;
			my $title_utf8 = encode('utf-8', decode('sjis', $title));
			print $cnt . " : " . $id . "=" . $title_utf8 . "\n";
		}
		$cnt = $cnt + 1;
	}
#	print $page[1] . "\n";
#	print $page[2] . "\n";
#	while ( $response->content ) {
#		print $_;
#	}
#	print $response->content;  # or whatever
} else {
	die $response->status_line;
}
