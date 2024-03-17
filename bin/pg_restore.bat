@echo off

docker exec -it POSTGRESQL pg_restore %*
