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

# level 1 header
print $cgi->h1('2ちゃんねる スレッド一覧');

print "\n"

print "<table>\n"
	print "<th>\n"
		print "<td>ID</td>\n"
		print "<td>スレッド</td>\n"
	print "</th>\n"
print "</table>\n"

# end the HTML
print $cgi->end_html;
