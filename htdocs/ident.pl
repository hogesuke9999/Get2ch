#!/usr/bin/perl

# load CGI routines
use CGI;
use CGI::Session;

# オブジェクトの初期化
my $cgi_session = new CGI::Session("driver:File", undef, {Directory=>'/tmp'});
$cgi_session->expire("+1h");

# create new CGI object
my $cgi = CGI->new;

# # 有効なセッションIDを取得
# my $cgi_session = $cgi_session->id();

print $cgi->charset("utf-8");

# create the HTTP header
# print $cgi->header('text/html' -charset => "utf-8",);
print $cgi_session->header(-charset => 'utf-8');
print $cgi_session->id();


# start the HTML
print $cgi->start_html(-title => '2ちゃんねる スレッド一覧', -lang => 'ja', -encoding => 'utf-8');

my $user_name = $cgi_session->param("user_name");
if($user_name eq "") {
	print "セッションに登録されていません<br>\n";
	$user_name = $cgi->param('user_name');
	$user_pass = $cgi->param('user_pass');
	if($user_name eq "") {
		print "認証が行われていません<br>\n";
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
	} else {
		print "認証が行われています<br>\n";
		print "User Name     : " . $user_name . "<br>\n";
		print "User Password : " . $user_pass . "<br>\n";
		if($user_name eq $user_pass){
			print "セッションに登録します<br>\n";
			$cgi_session->param("user_name", $user_name);
#			$cgi_session->flush();
		}
	}
} else {
	print "セッションに登録されています<br>\n";
	print "User Name : " . $user_name . "<br>\n";
}
print "<a href=\"ident.pl\">再表示</a>\n";

# end the HTML
print $cgi->end_html;
