#/bin/sh

# WARN
# args配列はユーザ名とパスワードを書いてね！！！！
args=(user passwd)

init: 
	MYSQL_USER=${args[0]} MYSQL_PASSWORD=${args[1]} perl scripts/setup_mysql.pl 1

run:
	MYSQL_USER=${args[0]} MYSQL_PASSWORD=${args[1]} plackup -l 192.168.56.101:45688 -r
