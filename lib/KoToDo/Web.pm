package KoToDo::Web;

use strict;
use warnings;
use utf8;
use Kossy;
use KoToDo::Model;
use DateTime;

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

get '/' => [qw/flash/] => sub {
    my ( $self, $c )  = @_;
    $c->render('index.tx', { greeting => "Hello" });
};

# 一覧ページ
get '/todos/' => [qw/flash/] => sub {
    my ($self, $c) = @_;
    my $todo_itr = $self->model->search('todos', {});
    $c->render('todos/index.tx', {todo_itr => $todo_itr});
};

# 個別ページ
get '/todos/:id' => [qw/flash/] => sub {
    my ($self, $c) = @_;
    my $todo = $self->model->single('todos', {id => $c->args->{id}});
    $c->render('todos/show.tx', {todo => $todo});
};

# 更新ページ
get '/todos/:id/edit' => [qw/flash/] => sub {
    my ($self, $c) = @_;
    my $id = $c->args->{id};
    my $todo = $self->model->single('todos', {id => $c->args->{id}});
    $c->render('todos/edit.tx', {todo => $todo});
};

# 更新処理
post '/todos/:id/update' => [qw/flash/] => sub {
    my ($self, $c) = @_;
    my $id = $c->args->{id};
    my $name = $c->req->param('name');
    $self->model->update('todos', {
        name => $name,
    }, {
        id => $id,
    });
    $c->redirect('/todos/')
};

# 削除処理
get '/todos/:id/delete' => [qw/flash/] => sub {
    my ($self, $c) = @_;
    my $id = $c->args->{id};
    $self->model->delete('todos', {id => $id});
    # TODO: 削除処理
    $c->redirect('/todos/');
};

# 作成
post '/todos/' => [qw/flash/] => sub {
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
    $c->redirect('/todos/');
};

1;

