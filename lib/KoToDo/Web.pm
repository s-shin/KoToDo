package KoToDo::Web;

use strict;
use warnings;
use utf8;
use Kossy;
use KoToDo::Model;
use DateTime;
use Data::Dumper;

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

# flashミドルウェア
filter 'flash' => sub {
    my $app = shift;
    sub {
        my ($self, $c) = @_;
        $c->stash->{flash} = $self->{flash};
        $self->{flash} = {};
        $app->($self, $c);
    }
};

#----------------------------------------
# URL: /
#----------------------------------------

get '/' => [qw/flash/] => sub {
    my ( $self, $c )  = @_;
    $c->render('index.tx', { greeting => "Hello", num => 1 });
};

#----------------------------------------
# URL: /todos/
#----------------------------------------

# 一覧ページ
get '/todos.json' => [qw/flash/] => sub {
    my ($self, $c) = @_;
    my $todo_itr = $self->model->search('todos', {});
    my $rows = $todo_itr->all;
    my @data = map {
      id   => $_->id+0,     name => $_->name, 
      is_done => $_->is_done+0, deadline => $_->deadline, 
      comment =>  $_->comment, 
      updated_at => $_->updated_at, 
      created_at => $_->created_at 
    } , @{$rows};
    $c->render_json(+{todos=>\@data});
};

# 個別ページ
get '/todos/:id.json' => [qw/flash/] => sub {
  my ($self, $c) = @_;
  my $todo = $self->model->single('todos', {id => $c->args->{id}});
  $c->render_json(+{ 
    todo => +{
      id => $todo->id+0, name => $todo->name, 
      is_done => $todo->is_done+0, 
      deadline => $todo->deadline, 
      comment => $todo->comment, 
      updated_at => $todo->updated_at, 
      created_at => $todo->created_at
    } 
  });
};

# 更新ページ
get '/todos/:id.json/edit' => [qw/flash/] => sub {
    my ($self, $c) = @_;
    my $id = $c->args->{id};
    # TODO 失敗した時の例外処理
    my $todo = $self->model->single('todos', {id => $c->args->{id}});
    $c->render_json( { status=>1 } );
};

# 更新処理
post '/todos/:id.json/update' => [qw/flash/] => sub {
    my ($self, $c) = @_;
    my $id = $c->args->{id};
    my $name = $c->req->param('name');
    $self->model->update('todos', {
      name => $name,
    }, {
      id => $id,
    });
    $c->render_json( { status=>1 } )
};

# 削除処理
get '/todos/:id.json/delete' => [qw/flash/] => sub {
    my ($self, $c) = @_;
    my $id = $c->args->{id};
    $self->model->delete('todos', {id => $id});
    $c->render_json({status => 1});
};

# 作成
post '/todos/new' => [qw/flash/] => sub {
    my ($self, $c) = @_;
    my $name = $c->req->param('name');
    # TODO: 保存成功か確認
    $self->model->insert('todos', {
        name => $name,
        created_at => DateTime->now(time_zone => 'local'),
    });
    $self->{flash} = {
        result => 'Save successful.',
    };
    $c->render_json({status => 1});
};

1;

