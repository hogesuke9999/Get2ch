#!/usr/bin/perl

# スレッド一覧のDBへの登録

# use strict;
use LWP::UserAgent;
use Encode;
use DBI;

my $ConfFileName = $ARGV[0];
if($ConfFileName eq "") {
	print "GetThread.pl Get2chThread.conf\n";
	exit 1;
}

# データベース接続設定の読み込み
our $DB_NAME, $DB_USER, $DB_PASS, $DB_HOST, $DB_PORT;
require $ConfFileName;

# データベース接続用ハンドルを取得
my $db = DBI->connect("dbi:Pg:dbname=$DB_NAME;host=$DB_HOST;port=$DB_PORT", "$DB_USER","$DB_PASS")
			 or die "$!\n Error: failed to connect to DB.\n";

my $ua = LWP::UserAgent->new;
$ua->timeout(10);
$ua->env_proxy;
# $ua->agent("");

$sql_board = "select name, host, title from board;";
my $sth_board = $db->prepare($sql_board);
$sth_board->execute;

while (my $board_arr_ref = $sth_board->fetchrow_arrayref) {
	my ($board_name, $board_host, $board_title) = @$board_arr_ref;
	print "Name  : " . $board_name  . "\n";
	print "Host  : " . $board_host  . "\n";
	print "Title : " . $board_title . "\n";

	my $URL = $board_host . $board_name . "/subback.html";
	print "URL   : " . $URL . "\n";
	my $response = $ua->get($URL);
	if ($response->is_success) {
		my @page = split( '\n', $response->content );
		my $cnt = 1;
		foreach my $line ( @page ) {
# <a href="/test/read.cgi/bizplus/1429615860/l50">1: (　´∀｀)ﾏﾀｰﾘ雑談スレ　その６ (328)</a>
print "LINE = " . $line . "\n";
			if ( $line =~ '^<a href=.*</a>$' ) {
				my ( $thread_id, $thread_title ) = ( $line =~ /<a href="(\d+)\/.*: (.*)\(.\d*\)<\/a>/) ;
				my $thread_title_utf8 = encode('utf-8', decode('sjis', $thread_title));

				my $sql = "select count(*) from threads where id = '" . $thread_id . "';";
				my $sth = $db->prepare($sql);
				$sth->execute;

				my $arr_ref = $sth->fetchrow_arrayref;
				my ($thread_id_exist) = @$arr_ref;
				$sth->finish;

				if ( $thread_id_exist == 0 ) {
					print $cnt . " : " . $thread_id . "(" . $thread_id_exist . ") = " . $thread_title_utf8 . "\n";
#					my $sql = "insert into threads (id, board_name, createtime, title) values ('" . $thread_id . "', '" . $board_name . "', now(), '" . $thread_title_utf8 . "');";
					my $sql = "insert into threads (id, board_name, createtime, title) values (?, ?, now(), ?);";
					my $sth = $db->prepare($sql);
					$sth->execute($thread_id, $board_name, $thread_title_utf8);
#					$db->do($sql);
				}
			}
			$cnt = $cnt + 1;
		}
	} else {
		die $response->status_line;
	}
}

$sth_board->finish;

$db->disconnect;
