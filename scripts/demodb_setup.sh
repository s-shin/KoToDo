#!/bin/bash

#kossyデータベースがないと動かない

user="root"
password="root"

dbname="kotodo"


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

#Test data for demo
insert="INSERT INTO todos(name, comment, deadline) \
VALUES ('あしたっていつのあしたよ？', 'あしたって今さッ！', ADDDATE(NOW(), 1));\
INSERT INTO todos(name, comment) \
VALUES ('無期限タスク', 'コメント');

"

#create table
echo $create|mysql --user=$user --password=$password $dbname
#insert data
echo $insert|mysql --user=$user --password=$password $dbname



