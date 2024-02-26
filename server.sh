#!/bin/bash

case "$1" in
  start | reload)
    docker compose up -d app mysql phpmyadmin
    ;;
  stop)
    docker compose down
    ;;
  reboot | restart)
    docker compose down
    docker compose up -d app mysql phpmyadmin
    ;;
  rebuild)
    docker compose down
    docker compose build app mysql phpmyadmin --no-cache
    docker compose up -d app mysql phpmyadmin --force-recreate
    ;;
  cli)
    docker exec -it Core bash -c "sudo -u devuser /bin/bash"
    ;;
  *)
    docker compose $@
    ;;
esac
