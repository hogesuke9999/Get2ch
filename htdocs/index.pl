#!/usr/bin/perl

# load CGI routines
use CGI;
use CGI::Session;

my $user_name, $user_pass ;
my $login_flag = 0;

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

print $cgi->start_form("post", "index.pl");

# level 1 header
print $cgi->h1('2ちゃんねる スレッド一覧');

$button_name = $cgi->param('button');
if( $button_name eq "送信") {
        $user_name = $cgi->param('user_name');
        $user_pass = $cgi->param('user_pass');

        if($user_name eq $user_pass){
                $cgi_session->param("user_name", $user_name);
                $login_flag = 1;
        }
}

if( $button_name eq "ログアウト") {
        print "ログアウトしました" .  $cgi->br . "\n";
        $cgi_session->delete();
} else {
        $user_name = $cgi_session->param("user_name");
        if($user_name ne "") {
                print "User Name : " . $user_name . "\n";
                print $cgi->submit('button', 'ログアウト');
                $login_flag = 1;
        }
}

if($login_flag == 0) {
#        print "<table>\n";
#        print "<tr>\n";
#        print "<td>" . "User Name : " . "</td>\n";
#        print "<td>";
#        print $cgi->textfield('user_name', '', 16, 16);
#        print "</td>\n";
#        print "</tr>\n";
#        print "<tr>\n";
#        print "<td>" . "Password : " . "</td>\n";
#        print "<td>";
#        print $cgi->textfield('user_pass', '', 16, 16);
#        print "</td>\n";
#        print "</tr>\n";
#        print "</table>\n";
#        print $cgi->submit('button', '送信');
        print $cgi->table({-border => "1"}, "\n" .
                $cgi -> Tr(
                        $cgi -> td("User Name : ") .
                        $cgi -> td($cgi->textfield('user_name', '', 16, 16))
                ) .
                $cgi -> Tr(
                        $cgi -> td("Password : ") .
                        $cgi -> td($cgi->textfield('user_pass', '', 16, 16))
                )
        );
        print $cgi->submit('button', '送信');
}

print $cgi->end_form;

print $cgi->hr . "\n";
print $cgi->a({href=>"index.pl"}, "再表示");

# end the HTML
print $cgi->end_html;

exit;
