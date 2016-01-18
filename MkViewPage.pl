#!/usr/bin/perl

# load CGI routines
use CGI;

# create new CGI object
my $q = CGI->new;

# create the HTTP header
print $q->header();

# start the HTML
print $q->start_html('hello world');

# level 1 header
print $q->h1('hello world');

# end the HTML
print $q->end_html;
