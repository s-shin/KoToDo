#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use DBI;
use DateTime;
use FindBin;
use lib "$FindBin::Bin/../lib";
use KoToDo::Model;

my $create_table = shift;

my $dbh = KoToDo::Model->connect_mysql(
    "kotodo", $ENV{MYSQL_USER}, $ENV{MYSQL_PASSWORD});

# 1をいれよう
if ($create_table) {
    $dbh->do(q{
        CREATE TABLE todos (
            id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
            name TEXT NOT NULL,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            created_at TIMESTAMP NOT NULL
        )
    });
}

my $model = KoToDo::Model->new($dbh);
$model->fast_insert('todos' => +{
    name => "Hello, world! こんにちは、世界！",
    created_at => DateTime->now(time_zone => 'local'),
});

