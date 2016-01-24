#!/usr/bin/perl

use LWP::UserAgent;
use Encode;
use CGI;
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

my ($ThreadHost, $ThreadName);
my $ErrorFlag = 0 ;

# DB接続オブジェクトの初期化
my $db = DBI->connect("dbi:Pg:dbname=$DB_NAME;host=$DB_HOST;port=$DB_PORT","$DB_USER","$DB_PASS") or die "$!\n Error: failed to connect to DB.\n";

# my $URL = "http://daily.2ch.net/test/read.cgi/newsplus/1453205001/-3";

# $ThreadListFile = "/opt/Get2ch/ThreadList.conf";
# my $ThreadList = require $ThreadListFile;
# print $ThreadList -> {'newsplus'}{'threadhost'} . "\n";
# print $ThreadList -> {'newsplus'}{'threadname'} . "\n";

# create new CGI object
my $cgi = CGI->new;

$cgi->charset("utf-8");

# create the HTTP header
print $cgi->header( -type => 'text/html', -charset => 'utf-8');
#print $cgi->header('text/html' -type => 'text/html', -charset => "utf-8",);
# print $cgi->header(-type => 'text/html',-charset => "utf-8",);

# start the HTML
print $cgi->start_html(-title => '2ちゃんねる スレッド', -lang => 'ja', -encoding => 'utf-8');

my $PUT_id  = $cgi->param('id');
if($PUT_id eq "") {
	print "[Error]スレッドIDが指定されていません\n";
	$ErrorFlag = 1 ;
}

my $PUT_tag = $cgi->param('tag');
if($PUT_tag eq "") {
	print "[Error]板が指定されていません\n";
	$ErrorFlag = 1 ;
} else {
	my $sql = "select host, title from board where name = ?;";
	my $sth = $db->prepare($sql);
	$sth->execute($PUT_tag);
	my $arr_ref = $sth->fetchrow_arrayref;
	($ThreadHost, $ThreadName) = @$arr_ref;

	if($ThreadHost eq "") {
		print "[Error]ホストが取得できません\n";
		$ErrorFlag = 1 ;
	}
	if($ThreadName eq "") {
		print "[Error]スレッド名が取得できません\n";
		$ErrorFlag = 1 ;
	}
}

if($ErrorFlag == 0) {
#	print "<a href=\"#\" onClick=\"window.close(); return false;\">閉じる</a>\n";
#	print "<br>\n";

	print "<a href=\"#\" onClick=\"window.close(); return false;\">";
	print "<img src=\"/get2ch/css/button_l.png\"                height=\"40\">";
	print "<img src=\"/get2ch/css/button_c.png\"  width=\"300\" height=\"40\">";
	print "<img src=\"/get2ch/css/button_nm.png\"               height=\"40\">";
	print "<img src=\"/get2ch/css/button_c.png\"  width=\"300\" height=\"40\">";
	print "<img src=\"/get2ch/css/button_r.png\"                height=\"40\">";
	print "</a>\n";
	print "<br>\n";

#	http://uni.open2ch.net/newsplus/dat/1453600222.dat
	# my $URL = "http://daily.2ch.net/test/read.cgi/newsplus/1453205001/-3";
	my $URL = $ThreadHost . $PUT_tag . "/dat/" . $PUT_id . ".dat";
	print "参照URL : " . $cgi->a({href=>$URL}, $URL) . "<br>\n";

	my $response = $ua->get($URL);

	if ($response->is_success) {
		my @page = split( '\n', $response->content );
		foreach my $line ( @page ) {
			if ( $line =~ '^<dt>1' ) {
				my ( $message_body ) = ( $line =~ /<dt>1.*<dd>(.*)$/) ;
				my $message_body_utf8 = encode('utf-8', decode('sjis', $message_body));

				print "<p>";
				print $message_body_utf8 . "\n";
				print "</p>\n";
			}
		}
	} else {
		die $response->status_line;
	}
}

# end the HTML
print $cgi->end_html;

$db->disconnect;
