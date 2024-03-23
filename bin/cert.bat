@echo off

set sites=%*
docker exec -it SERVER_TOOLS bash -c "cd /etc/ssl/custom && mkcert %sites%"