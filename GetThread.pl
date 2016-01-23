#!/usr/bin/perl

# スレッド一覧のDBへの登録

# use strict;
use LWP::UserAgent;
use Encode;
use DBI;

my $ConfFileName = $ARGV[0];
if($ConfFileName eq "") {
	print "Get2chThread.pl Get2chThread.conf\n";
	exit 1;
}

# データベース接続設定の読み込み
our $DB_NAME, $DB_USER, $DB_PASS, $DB_HOST, $DB_PORT;
require $ConfFileName;

# print "DB_NAME = " . $DB_NAME . "\n";
# print "DB_USER = " . $DB_USER . "\n";
# print "DB_PASS = " . $DB_PASS . "\n";
# print "DB_HOST = " . $DB_HOST . "\n";
# print "DB_PORT = " . $DB_PORT . "\n";


# データベース接続用ハンドルを取得
my $db = DBI->connect("dbi:Pg:dbname=$DB_NAME;host=$DB_HOST;port=$DB_PORT", "$DB_USER","$DB_PASS")
			 or die "$!\n Error: failed to connect to DB.\n";

my $ua = LWP::UserAgent->new;
$ua->timeout(10);
$ua->env_proxy;
$ua->agent("");

# my $ThreadList = require $ThreadListFile;
# print $ThreadList -> {'newsplus'}{'threadhost'} . "\n";
# print $ThreadList -> {'newsplus'}{'threadname'} . "\n";

$sql = "select name, host, title from board;";
my $sth = $db->prepare($sql);
$sth->execute;

while (my $arr_ref = $sth->fetchrow_arrayref) {
	my ($board_name, $board_host, $board_title) = @$arr_ref;
	print "Name  : " . $board_name  . "\n";
	print "Host  : " . $board_host  . "\n";
	print "Title : " . $board_title . "\n";
}
$sth->finish;

$db->disconnect;

exit;

for my $ThreadList_tag (sort keys %$ThreadList) {
	print "ThreadName = " . $ThreadList -> {$ThreadList_tag}{'threadname'} . "\n";
	print "ThreadHost = " . $ThreadList -> {$ThreadList_tag}{'threadhost'} . "\n";
	print "\n";

	my $response = $ua->get($ThreadList -> {$ThreadList_tag}{'threadhost'} . "/" . $ThreadList_tag . "/subback.html");

	if ($response->is_success) {
		my @page = split( '\n', $response->content );
		my $cnt = 1;
		foreach my $line ( @page ) {
			# <a href="1452481229/l50">855: 【社会】震災４年１０か月 ボランティアが不明者捜索 [無断転載禁止]&#169;2ch.net (15)</a>
			if ( $line =~ '^<a href=.*</a>$' ) {
				my ( $id, $title ) = ( $line =~ /<a href="(\d+)\/.*: (.*)\(.\d*\)<\/a>/) ;
				my $title_utf8 = encode('utf-8', decode('sjis', $title));

				my $sql = "select count(*) from subjects where id = '" . $id . "';";
				my $sth = $db->prepare($sql);
				$sth->execute;

				my $arr_ref = $sth->fetchrow_arrayref;
				my ($id_exist) = @$arr_ref;
				$sth->finish;

				if ( $id_exist == 0 ) {
					print $cnt . " : " . $id . "(" . $id_exist . ") = " . $title_utf8 . "\n";
					my $sql = "insert into subjects (id, tag, datetime, subject) values ('" . $id . "', '" . $ThreadList_tag . "', now(), '" . $title_utf8 . "');";
# print "SQL = " . $sql . "\n";
					$db->do($sql);
				}
			}
			$cnt = $cnt + 1;
		}
	} else {
		die $response->status_line;
	}
};

$db->disconnect;
