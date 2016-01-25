#!/usr/bin/perl

use CGI;

# create new CGI object
my $cgi = CGI->new;

$cgi->charset("utf-8");

# create the HTTP header
print $cgi->header( -type => 'text/html', -charset => 'utf-8');

# start the HTML
print $cgi->start_html(-title => 'Tableサイズ・Windowサイズ', -lang => 'ja', -encoding => 'utf-8');

print $cgi->h1('Tableサイズ・Windowサイズ');

# end the HTML
print $cgi->end_html;
