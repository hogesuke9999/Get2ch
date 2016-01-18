#!/usr/bin/perl

# スレッド一覧の表示用Webページ

# load CGI routines
use CGI;

# create new CGI object
my $cgi = CGI->new;

print $cgi->charset("utf-8");

# create the HTTP header
print $cgi->header('text/html' -charset => "utf-8",);

# start the HTML
print $cgi->start_html(-title => '2ちゃんねる スレッド一覧', -lang => 'ja', -encoding => 'utf-8');


my $remote_user = $cgi->remote_user();

# level 1 header
print $cgi->h1('2ちゃんねる スレッド一覧');

print "\n";
print "ユーザ名 : " . $remote_user . "<br>\n";

print "\n";

print "<table border='1'>\n";
	print "<tr>\n";
		print "<th>ID</th>\n";
		print "<th>スレッド</th>\n";
	print "</tr>\n";
print "</table>\n";

# end the HTML
print $cgi->end_html;
