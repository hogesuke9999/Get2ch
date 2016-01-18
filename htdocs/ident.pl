#!/usr/bin/perl

# load CGI routines
use CGI;
use CGI::Session;

# create new CGI object
my $cgi = CGI->new;

# オブジェクトの初期化
my $session = new CGI::Session("driver:File", undef, {Directory=>'/tmp'});

# 有効なセッションIDを取得
my $cgi_session = $session->id();

print $cgi->charset("utf-8");

# create the HTTP header
print $cgi->header('text/html' -charset => "utf-8",);

# start the HTML
print $cgi->start_html(-title => '2ちゃんねる スレッド一覧', -lang => 'ja', -encoding => 'utf-8');

my $user_name = $session->param('user_name');
if($user_name == "") {
	$user_name = $cgi->param('user_name');
	print "User Name : " . $user_name . "<br>\n";
	if($user_name == "") {
		print $cgi->start_form("post","ident.pl");
	#	print "<form action=\"ident.pl\" method=\"post\">\n";
		print "<table>\n";
		print "<tr>\n";
		print "<td>" . "User Name : " . "</td>\n";
		print "<td>";
		print $cgi->textfield('user_name','',16,16);
	#	print "<input type=\"text\" name=\"user_name\" size=\"16\">";
		print "</td>\n";
		print "</tr>\n";
		print "<tr>\n";
		print "<td>" . "Password  : " . "</td>\n";
		print "<td>";
		print $cgi->textfield('user_pass','',16,16);
	#	print "<input type=\"text\" name=\"user_pass\" size=\"16\">";
		print "</td>\n";
		print "</tr>\n";
		print "</table>\n";
		print $cgi->submit('button','送信');
	#	print "<input type=\"submit\" value=\"送信\">\n";
	#	print "</form>\n";
		print $cgi->end_form;
	}
} else {
	print "User Name : " . $user_name . "<br>\n";
}

# end the HTML
print $cgi->end_html;
