@echo off

docker exec -it MYSQL mariadb-dump %*
