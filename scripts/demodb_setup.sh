#!/bin/bash

#mysqlのroot権限
user="root"
password="root"

#kotodoのアカウント
kotodo_user="kotodo"
kotodo_pass="kotodo"

dbname="kotodo"


db="CREATE DATABASE kotodo;\
GRANT ALL ON kotodo.* TO "$kotodo_user"@localhost IDENTIFIED BY '"$kotodo_pass"';"


create=" CREATE TABLE todos (\
id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,\
name TEXT NOT NULL,\
is_done BOOLEAN NOT NULL DEFAULT FALSE,\
deadline DATETIME,\
comment text,\
updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,\
created_at TIMESTAMP NOT NULL\
);\
"

prefix="INSERT INTO todos(name, comment)"
prefix_full="INSERT INTO todos(name, comment, deadline)"

#Test data for demo
insert="INSERT INTO todos(name, comment, deadline) \
VALUES ('あしたっていつのあしたよ？', 'あしたって今さッ！', ADDDATE(NOW(), 1));\
INSERT INTO todos(name, comment) \
VALUES ('無期限タスク', 'コメント');

"

#create db
echo $db|mysql --user=$user --password=$password
#create table
echo $create|mysql --user=$kotodo_user --password=$kotodo_pass $dbname
#insert data
echo $insert|mysql --user=$kotodo_user --password=$kotodo_pass $dbname



