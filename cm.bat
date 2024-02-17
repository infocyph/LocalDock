@echo off

if "%1" == "start" (
    docker compose up -d app mysql phpmyadmin
) else if "%1" == reload (
    docker compose up -d app mysql phpmyadmin
) else if %1 == stop (
    docker compose down
) else if %1 == reboot (
    docker compose down
    docker compose up -d app mysql phpmyadmin
) else if %1 == restart (
    docker compose down
    docker compose up -d app mysql phpmyadmin
) else if %1 == rebuild (
    docker compose down
    docker compose build app mysql phpmyadmin --no-cache
    docker compose up -d app mysql phpmyadmin --force-recreate
) else if %1 == cli (
    docker exec -it Core bash -c "sudo -u devuser /bin/bash"
) else (
    docker compose %*
)
