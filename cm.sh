#!/bin/bash

case "$1" in
  start | reload)
    docker compose -f docker-compose.yml -f mysql.yml up -d
    ;;
  stop)
    docker compose -f docker-compose.yml -f mysql.yml down
    ;;
  reboot | restart)
    docker compose -f docker-compose.yml -f mysql.yml down
    docker compose -f docker-compose.yml -f mysql.yml up -d
    ;;
  rebuild)
    docker compose -f docker-compose.yml -f mysql.yml down
    docker compose -f docker-compose.yml -f mysql.yml build --no-cache
    docker compose -f docker-compose.yml -f mysql.yml up -d --force-recreate
    ;;
  cli)
    docker exec -it Core bash -c "sudo -u devuser /bin/bash"
    ;;
  *)
    docker compose -f docker-compose.yml -f mysql.yml $@
    ;;
esac