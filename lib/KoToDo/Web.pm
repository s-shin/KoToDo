package KoToDo::Web;

use strict;
use warnings;
use utf8;
use Kossy;
use KoToDo::Model;
use DateTime;
use Data::Dumper;
use DateTime::Format::Strptime;
use JSON;
my $_JSON = JSON->new()->allow_blessed(1)->convert_blessed(1)->ascii(1);

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

# 日付文字列
# %Y-%m-%d => PerlのDateTimeに!!
sub convert_datetime {
  my ($self, $str) = @_;
  
  my $strp = DateTime::Format::Strptime->new(
    pattern   => '%Y-%m-%d',  
    time_zone => 'Asia/Tokyo', 
  );

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

#----------------------------------------------
# 以降API
#----------------------------------------------

my $API = "api";

# 返り値JSON
my $success = {status => 1};
my $failure = {status => 0};

# 一覧ページ
my $get_todos = sub {
    my ($self, $c) = @_;
    
    # q: 検索キーワード
    # p: ページ番号 0~
    # from: deadlineでの開始日付
    # to: deadline検索でのおわり日付
    my $q = $c->req->param("q") || "";
    my $p = $c->req->param("p") || 0;
    my $from  = $c->req->param("from");
    my $to    = $c->req->param("to");
    
    # TODO パラメータのvalidator

    my $limit = 10; # 1ページの表示上限

    my $todo_itr;
    if ($from || $to) {
        unless ($from) {
          $from = "0000-01-01";
          # デフォルト値（こんなに小さくなくてもいい？）
        }
        unless ($to) {
          $to = "9999-12-31";
          # デフォルト値（こんなに大きくなくてもいい？）
        }
        $todo_itr = $self->model->search_named(
            q{SELECT * FROM todos WHERE name LIKE :query AND DATE(deadline) BETWEEN :from AND :to ORDER BY deadline DESC LIMIT :offset, :limit}, 
              {query => "%".$q."%",  from=>$from, to=>$to, limit => $limit, offset=> ($p-1)*$limit}
        );
    } else {
        $todo_itr = $self->model->search_named(
            q{SELECT * FROM todos WHERE name LIKE :query ORDER BY deadline DESC LIMIT :offset, :limit}, 
            {query => "%".$q."%", limit => $limit, offset=> $p*$limit}
        );
    }

# LIKEをorで連ねると上手くいかない... 
#    my $todo_itr = $self->model->search_named(
#      q{SELECT * FROM todos WHERE name LIKE :query1 or comment LIKE :query2 AND DATE(deadline) BETWEEN :from AND :to LIMIT :offset, :limit}, 
#      {query1 => $pattern, query2=>$pattern,  from=>$from, to=>$to, limit => $limit, offset=> $p*$limit}
#    );

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
get "/$API/todos/" => $get_todos;
get "/$API/todos.json" => $get_todos;

# 個別ページ
my $get_todo = sub {
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
get "/$API/todos/:id" => $get_todo;
get "/$API/todos/:id.json" => $get_todo;

# 更新処理
my $update_todo = sub {
    my ($self, $c) = @_;
    my $id = $c->args->{id};
    my $name = $c->req->param('name');
    my $comment = $c->req->param('comment');
    my $deadline_str = $c->req->param('deadline');

    my $deadline = $self->convert_datetime($deadline_str);

    $self->model->update('todos', {
      name => $name,
      comment => $comment, 
      deadline => $deadline,   
    }, {
      id => $id,
    });
    $c->render_json( { status=>1 } )
};
router 'PUT' => "/$API/todos/:id" => $update_todo;
post "/$API/todos/:id.json/update" => $update_todo;

# 削除処理
my $delete_todo = sub {
    my ($self, $c) = @_;
    my $id = $c->args->{id};
    $self->model->delete('todos', {id => $id});
    $c->render_json({status => 1});
};
router 'DELETE' => "/$API/todos/:id" => $delete_todo;
get "/$API/todos/:id.json/delete" => $delete_todo;

# 作成
my $create_todo = sub {
    my ($self, $c) = @_;
    my $name = $c->req->param('name');
    my $comment = $c->req->param('comment');
    my $deadline_str = $c->req->param('deadline');
    my $deadline = $self->convert_datetime($deadline_str);

    # Backboneのサポート
    my $data = $c->req->param('model');
    if ($data) {
        $data = $_JSON->decode($data);
        $name = $data->{name};
        $comment = $data->{comment};
        $deadline = undef;
    }
    
    # TODO: 保存成功か確認
    $self->model->insert('todos', {
        name => $name,
        comment => $comment, 
        deadline => $deadline,
        created_at => DateTime->now(time_zone => 'local'),
    });
    $self->{flash} = {
        result => 'Save successful.',
    };
    $c->render_json({status => 1});
};
post "/$API/todos/" => $create_todo;
post "/$API/todos/new" => $create_todo;

1;

