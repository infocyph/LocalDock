@echo off

docker exec -it MYSQL mysqldump %*
