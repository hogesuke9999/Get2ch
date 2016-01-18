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

# end the HTML
print $cgi->end_html;
