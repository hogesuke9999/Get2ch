#!/usr/bin/perl

# 読み込みフラグの設定処理

use DBI;

our $DB_NAME = "get2ch";
our $DB_USER = "get2ch";
our $DB_PASS = "get2chpass";
our $DB_HOST = "127.0.0.1";
our $DB_PORT = "5432";

my $user_id = 3;

my $db = DBI->connect("dbi:Pg:dbname=$DB_NAME;host=$DB_HOST;port=$DB_PORT","$DB_USER","$DB_PASS") or die "$!\n Error: failed to connect to DB.\n";

my $sql = "select subjects.id, subjects.tag, subjects.subject
		from subjects LEFT JOIN checkflag
		ON subjects.id = checkflag.subjects_id
		and checkflag.users_id = '" . $user_id . "'
		where checkflag.flag is NULL
		limit 20;";
# print "SQL = " . $sql . "\n";
my $sth = $db->prepare($sql);
$sth->execute;

while (my $arr_ref = $sth->fetchrow_arrayref) {
	my ($TABLE_id, $TABLE_tag, $TABLE_subject) = @$arr_ref;
	print $TABLE_id . " : " . $TABLE_subject . "\n";

	my $sql_w = "insert into checkflag (subjects_id, subjects_tag, users_id, flag, checkdate)
		     values('" . $TABLE_id . "', '" . $TABLE_tag . "', '" . $user_id . "', '1', now());";
	$db->do($sql_w);
# print "SQL = " . $sql_w . "\n";
}
$sth->finish;

$db->disconnect;
