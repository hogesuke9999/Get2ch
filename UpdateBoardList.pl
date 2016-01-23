#!/bin/perl

use LWP::UserAgent;
use Encode;
use DBI;

my $ua = LWP::UserAgent->new;
$ua->timeout(10);
$ua->env_proxy;
$ua->agent("");

# For PostgreSQL Connect Setting
our $DB_NAME = "get2ch";
our $DB_USER = "get2ch";
our $DB_PASS = "get2chpass";
our $DB_HOST = "127.0.0.1";
our $DB_PORT = "5432";

# DB接続オブジェクトの初期化
my $db = DBI->connect("dbi:Pg:dbname=$DB_NAME;host=$DB_HOST;port=$DB_PORT","$DB_USER","$DB_PASS") or die "$!\n Error: failed to connect to DB.\n";

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
				$sql = "select count(*) from board where name = '" . $thread_name . "';";
				my $sth = $db->prepare($sql);
				$sth->execute;

				my $arr_ref = $sth->fetchrow_arrayref;
				my ($thread_name_exist) = @$arr_ref;
				$sth->finish;
#				print $board_host . " : " . $board_name . "(" . $thread_name_exist . ") = " . $board_title_utf8 . "\n";
				if($thread_name_exist == 0) {
					$sql = "insert into board (name, host, title) values ('" . $board_name . "', '" . $board_host . "', '" . $board_title_utf8 . "');";
				} else {
					$sql = "update board set host = '" . $board_host . "', title = '" . $board_title_utf8 . "' where name = '" . $board_name . "'";
				}
				print "SQL = " . $sql . "\n";
				$db->do($sql);
			}
		}
	}
} else {
	die $response->status_line;
}

$db->disconnect;
