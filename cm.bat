@echo off

if "%1" == "start" (
    docker compose -f docker-compose.yml -f mysql.yml up -d
) else if "%1" == reload (
    docker compose -f docker-compose.yml -f mysql.yml up -d
) else if %1 == stop (
    docker compose -f docker-compose.yml -f mysql.yml down
) else if %1 == reboot (
    docker compose -f docker-compose.yml -f mysql.yml down
    docker compose -f docker-compose.yml -f mysql.yml up -d
) else if %1 == restart (
    docker compose -f docker-compose.yml -f mysql.yml down
    docker compose -f docker-compose.yml -f mysql.yml up -d
) else if %1 == rebuild (
    docker compose -f docker-compose.yml -f mysql.yml down
    docker compose -f docker-compose.yml -f mysql.yml build --no-cache
    docker compose -f docker-compose.yml -f mysql.yml up -d --force-recreate
) else if %1 == cli (
    docker exec -it Core bash -c "sudo -u devuser /bin/bash"
) else (
    docker compose -f docker-compose.yml -f mysql.yml %*
)
