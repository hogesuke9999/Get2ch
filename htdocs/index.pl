#!/usr/bin/perl

# load CGI / routines
use CGI;
use CGI::Session;
use DBI;

# For PostgreSQL Connect Setting
our $DB_NAME = "get2ch";
our $DB_USER = "get2ch";
our $DB_PASS = "get2chpass";
our $DB_HOST = "127.0.0.1";
our $DB_PORT = "5432";

# 変数初期化
my $user_name, $user_pass, $user_id ;
my $login_flag = 0;

# DB接続オブジェクトの初期化
my $db = DBI->connect("dbi:Pg:dbname=$DB_NAME;host=$DB_HOST;port=$DB_PORT","$DB_USER","$DB_PASS") or die "$!\n Error: failed to connect to DB.\n";

# CGIオブジェクトの初期化
my $cgi_session = new CGI::Session("driver:File", undef, {Directory=>'/tmp'});
$cgi_session->expire("+1h");

my $cgi = CGI->new;

# create the HTTP header
print $cgi->header(
	-charset => "utf-8",
	-cookie => $cgi->cookie(-name=>'CGISESSID', -value=>$cgi_session->id())
);

# start the HTML
print $cgi->start_html(-title => '2ちゃんねる スレッド一覧', -lang => 'ja', -encoding => 'utf-8');

print $cgi->start_form("post", "index.pl");

# タイトル表示
print $cgi->h1('2ちゃんねる スレッド一覧');

$button_name = $cgi->param('button');
if( $button_name eq "送信") {
	$user_name = $cgi->param('user_name');
	$user_pass = $cgi->param('user_pass');

        my $sql = "select password from users where name = '" . $user_name . "';";
        my $sth = $db->prepare($sql);
        $sth->execute;

        my $arr_ref = $sth->fetchrow_arrayref;
        my ($TABLE_users_password) = @$arr_ref;
        $sth->finish;

	if($user_pass eq $TABLE_users_password){
		print "ログインしました" .  $cgi->br . "\n";
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
		my $sql = "select id from users where name = '" . $user_name . "';";
		my $sth = $db->prepare($sql);
		$sth->execute;

		my $arr_ref = $sth->fetchrow_arrayref;
		($user_id) = @$arr_ref;
		$sth->finish;

		print "ユーザ名 : " . $user_name . " (" . $user_id . ") \n";
		print $cgi->submit('button', 'ログアウト');
		$login_flag = 1;
	}
}

if($login_flag == 0) {
        # ログイン未実施
        print $cgi->table({-border => "0"}, "\n" .
                $cgi -> Tr(
                        "\n" .
                        $cgi -> td("User Name : ") .
                        $cgi -> td($cgi->textfield('user_name', '', 16, 16)) .
                        "\n"
                ) .
                "\n" .
                $cgi -> Tr(
                        "\n" .
                        $cgi -> td("Password : ") .
                        $cgi -> td($cgi->textfield('user_pass', '', 16, 16)) .
                        "\n"
                )
        );
        print $cgi->submit('button', '送信');
} else {
	# ログイン済み
	print "<table border='1'>\n";

	print "<tr>\n";
	print "<th>ID</th>\n";
	print "<th>スレッド</th>\n";
	print "</tr>\n";

	my $sql = "select subjects.id, subjects.tag, subjects.subject
		from subjects LEFT JOIN checkflag
		ON subjects.id = checkflag.subjects_id
		and checkflag.users_id = '" . $user_id . "'
		where checkflag.flag is NULL
		order by datetime limit 15;";
	my $sth = $db->prepare($sql);
	$sth->execute;

	while (my $arr_ref = $sth->fetchrow_arrayref) {
		my ($TABLE_id, $TABLE_tag, $TABLE_subject) = @$arr_ref;
		print "<tr>\n";
		print "<td>" . $TABLE_id . "</td><td>" . $TABLE_subject . "</td>\n";
		print "</tr>\n";

#		my $sql_w = "insert into checkflag (subjects_id, subjects_tag, users_id, flag, checkdate)
#			values('" . $TABLE_id . "', '" . $TABLE_tag . "', '" . $user_id . "', '1', now());";
#		$db->do($sql_w);
	}
	$sth->finish;

	print "</table>\n";
#        print "SQL = " . $sql . "<br>\n";
}

print $cgi->end_form;

print $cgi->hr . "\n";
print $cgi->a({href=>"index.pl"}, "再表示");

# end the HTML
print $cgi->end_html;

$db->disconnect;

exit;
