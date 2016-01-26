#!/usr/bin/perl

use CGI;

# create new CGI object
my $cgi = CGI->new;

$cgi->charset("utf-8");

# create the HTTP header
print $cgi->header(
	-type => 'text/html',
	-charset => 'utf-8'
);

# start the HTML
print $cgi->start_html(
	-title => 'Tableサイズ・Windowサイズ',
	-lang => 'ja',
	-encoding => 'utf-8',
	-style => {'src' => '/get2ch/css/tablestyle.css'},
	-script => {
		-language => 'JavaScript',
		-type => 'JAVASCRIPT',
		-src  => '/get2ch/css/tablesize.js'
	}
);

print $cgi->h1('Tableサイズ・Windowサイズ');
print "\n";
# print "<p>ウィンドウサイズ：<span id=\"WinSize\"></span></p>\n";
print "<script type=\"text/javascript\">\n";
print "getWindowSize();\n";
print "</script>\n";
# print "function getWindowSize() {\n";
# print "	var sW,sH,s;\n";
# print "	sW = window.innerWidth;\n";
# print "	sH = window.innerHeight;\n";
# print "	s = \"横幅 = \" + sW + \" / 高さ = \" + sH;\n";
# print "	document.getElementById(\"WinSize\").innerHTML = s;\n";

print "<table border=1 class=\"tablestyle\">\n";

print "<tr>\n";
print "<th class=id>ID</th>\n";
print "<th class=subject>件名</th>\n";
print "</tr>\n";

print "<tr>\n";
print "<td class=id>あああああ</td>\n";
print "<td class=subject>あいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえお</td>\n";
print "</tr>\n";

print "<tr>\n";
print "<td class=id>あああああ</td>\n";
print "<td class=subject>あいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえお</td>\n";
print "</tr>\n";

print "</table>\n";

# end the HTML
print $cgi->end_html;
