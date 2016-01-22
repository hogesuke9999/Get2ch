#!/usr/bin/perl

use LWP::UserAgent;
use Encode;
use CGI;

my $ua = LWP::UserAgent->new;
$ua->timeout(10);
$ua->env_proxy;
$ua->agent("");

# my $URL = "http://daily.2ch.net/test/read.cgi/newsplus/1453205001/-3";

$ThreadListFile = "/opt/Get2ch/ThreadList.conf";
my $ThreadList = require $ThreadListFile;
# print $ThreadList -> {'newsplus'}{'threadhost'} . "\n";
# print $ThreadList -> {'newsplus'}{'threadname'} . "\n";

# create new CGI object
my $cgi = CGI->new;

print $cgi->charset("utf-8");

# create the HTTP header
print $cgi->header('text/html' -charset => "utf-8",);

# start the HTML
print $cgi->start_html(-title => '2ちゃんねる スレッド', -lang => 'ja', -encoding => 'utf-8');

my $PUT_id  = $cgi->param('id');
my $PUT_tag = $cgi->param('tag');

if($PUT_tag ne "") {
	$ThreadHost = $ThreadList -> {$PUT_tag}{'threadhost'};
	$ThreadName = $ThreadList -> {$PUT_tag}{'threadname'};
}

# print "ID          : " . $PUT_id  . "<br>\n";
# print "Tag         : " . $PUT_tag . "<br>\n";
# print "Thread Host : " . $ThreadHost . "<br>\n";
# print "Thread Name : " . $ThreadName . "<br>\n";

# my $URL = "http://daily.2ch.net/test/read.cgi/newsplus/1453205001/-3";
my $URL = $ThreadHost . "test/read.cgi/" . $PUT_tag . "/" . $PUT_id . "/-1";
# print "URL = " . $URL . "<br>\n";

my $response = $ua->get($URL);

if ($response->is_success) {
	my @page = split( '\n', $response->content );
	foreach my $line ( @page ) {
		if ( $line =~ '^<dt>1' ) {
			my ( $message_date, $message_body ) = ( $line =~ /<dt>1.*<\/a>(.*)ID.*<dd>(.*)$/) ;
			my $message_date_utf8 = encode('utf-8', decode('sjis', $message_date));
			my $message_body_utf8 = encode('utf-8', decode('sjis', $message_body));

			print "<p>";
			print "投稿日時" . $message_date_utf8;
			print "</p>\n";
			print "<p>";
			print $message_body_utf8 . "\n";
			print "</p>\n";
		}
	}
} else {
	die $response->status_line;
}

# end the HTML
print $cgi->end_html;
