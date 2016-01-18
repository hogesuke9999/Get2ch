#!/usr/bin/perl

# スレッド一覧のDBへの登録

use LWP::UserAgent;
use Encode;
use DBI;

our $DB_NAME = "get2ch";
our $DB_USER = "get2ch";
our $DB_PASS = "get2chpass";
our $DB_HOST = "127.0.0.1";
our $DB_PORT = "5432";

my $db = DBI->connect("dbi:Pg:dbname=$DB_NAME;host=$DB_HOST;port=$DB_PORT","$DB_USER","$DB_PASS") or die "$!\n Error: failed to connect to DB.\n";

my $ua = LWP::UserAgent->new;
$ua->timeout(10);
$ua->env_proxy;
$ua->agent("");

# my $response = $ua->get('http://localhost/subback.html');
my $response = $ua->get('http://daily.2ch.net/newsplus/subback.html');

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
				my $sql = "insert into subjects (id, tag, datetime, subject) values ('" . $id . "', 'newsplus', now(), '" . $title_utf8 . "');";
				$db->do($sql);
			}
		}
		$cnt = $cnt + 1;
	}
} else {
	die $response->status_line;
}

$db->disconnect;
