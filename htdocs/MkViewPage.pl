#!/usr/bin/perl

# スレッド一覧の表示用Webページ

# load CGI routines
use CGI;

# load DBI routines
use DBI;

# For PostgreSQL Connect Setting
our $DB_NAME = "get2ch";
our $DB_USER = "get2ch";
our $DB_PASS = "get2chpass";
our $DB_HOST = "127.0.0.1";
our $DB_PORT = "5432";

my $db = DBI->connect("dbi:Pg:dbname=$DB_NAME;host=$DB_HOST;port=$DB_PORT","$DB_USER","$DB_PASS") or die "$!\n Error: failed to connect to DB.\n";

# create new CGI object
my $cgi = CGI->new;

print $cgi->charset("utf-8");

# create the HTTP header
print $cgi->header('text/html' -charset => "utf-8",);

# start the HTML
print $cgi->start_html(-title => '2ちゃんねる スレッド一覧', -lang => 'ja', -encoding => 'utf-8');

my $remote_user_name = $cgi->remote_user();
my $sql = "select id from users where name = '" . $remote_user_name . "';";
my $sth = $db->prepare($sql);
$sth->execute;

my $arr_ref = $sth->fetchrow_arrayref;
my ($remote_user_id) = @$arr_ref;
$sth->finish;

# level 1 header
print $cgi->h1('2ちゃんねる スレッド一覧');

print "\n";
print "ユーザ名 : " . $remote_user . "(" . $remote_user_id . ")<br>\n";

print "\n";

print "<table border='1'>\n";
	print "<tr>\n";
		print "<th>ID</th>\n";
		print "<th>スレッド</th>\n";
	print "</tr>\n";
print "</table>\n";

# end the HTML
print $cgi->end_html;
