use strict;
use warnings;
use utf8;
use Test::More tests => 2;
# use lib '../lib/';
# use Test::mysqld;
use DateTime;
use Data::Dumper;
use KoToDo::Model;

sub model {
    my $self = shift;
    $self->{__model} ||= KoToDo::Model->new(
        exists $ENV{MYSQL_USER}
        ? KoToDo::Model->connect_mysql(
            "kotodo", $ENV{MYSQL_USER}, $ENV{MYSQL_PASSWORD})
        : KoToDo::Model->connect_sqlite(
            "db/development.sqlite3")
    );
    $self->{__model}
}

subtest 'test_of_test' => sub{
    my $expect = "Hello KoToDo";
    my $row = model->insert('todos', {
            name => $expect,
            created_at => DateTime->now(time_zone => 'local'),
        });
    my $got = model->single('todos', {id => $row->id });
    is($got->name, $expect);
    model->delete('todos', {id => $row->id});
};

subtest 'like_search' => sub{
    my $query = 'search';
    #見つからない場合
    my $row = model->search_named(
        q{SELECT * FROM todos WHERE name LIKE :query},
            {query => "%" . $query . "%"}
    );
    my $got = $row->all;
    my $len = @$got;
    #見つからないときにallで取得すると、空配列になる
    is($len, 0);

    my $expect = "like search test";
    $row = model->insert('todos', {
            name => $expect,
            created_at => DateTime->now(time_zone => 'local'),
        });

    #見つかる場合 これを直書きしてください
    $row = model->search_named(
        q{SELECT * FROM todos WHERE name LIKE :query},
            {query => "%" . $query . "%"}
    );

    $got = $row->next;
    note explain $got->name;
    is($got->name, $expect);

    model->delete('todos', {name => $expect});
};
