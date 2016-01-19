#!/usr/bin/perl

# load CGI routines
use CGI;
use CGI::Session;

# オブジェクトの初期化
my $cgi_session = new CGI::Session("driver:File", undef, {Directory=>'/tmp'});
$cgi_session->expire("+1h");

# create new CGI object
my $cgi = CGI->new;

# create the HTTP header
print $cgi->header(
 -charset => "utf-8",
 -cookie => $cgi->cookie(-name=>'CGISESSID', -value=>$cgi_session->id())
);

# start the HTML
print $cgi->start_html(-title => '2ちゃんねる スレッド一覧', -lang => 'ja', -encoding => 'utf-8');

$button_name = $cgi->param('button');
print "ボタン : " . $button_name . "<br>\n";

print $cgi->start_form("post", "index.pl");
print $cgi->submit('button','送信');
print $cgi->submit('button','ログアウト');
print $cgi->end_form;

print "<hr>\n";
print "<a href=\"ident.pl\">再表示</a>\n";

# end the HTML
print $cgi->end_html;

exit;





my $user_name = $cgi_session->param("user_name");
if($user_name eq "") {
#	print "セッションに登録されていません<br>\n";
	$user_name = $cgi->param('user_name');
	$user_pass = $cgi->param('user_pass');

	if($user_name eq "") {
		print "認証が行われていません<br>\n";
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
	} else {
#		print "認証が行われています<br>\n";
		print "User Name     : " . $user_name . "<br>\n";
		print "User Password : " . $user_pass . "<br>\n";
		if($user_name eq $user_pass){
#			print "セッションに登録します<br>\n";
			$cgi_session->param("user_name", $user_name);
#			$cgi_session->flush();
		}
	}
} else {
#	print "セッションに登録されています<br>\n";
        print "認証済み<br>\n";
	print "User Name : " . $user_name . "<br>\n";
}
