#!/usr/bin/perl

# スレッド一覧の表示用Webページ

# load CGI routines
use CGI;

# create new CGI object
my $q = CGI->new;

# create the HTTP header
print $q->header('text/html');

# start the HTML
print $q->start_html('hello world');

# level 1 header
print $q->h1('hello world');

# end the HTML
print $q->end_html;
