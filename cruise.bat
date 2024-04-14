@echo off

IF NOT EXIST ".env" (
    echo .env file is missing!
    goto incomplete
)

set "directory=%~dp0"
set "directory=%directory:~0,-1%"
setlocal enabledelayedexpansion
findstr /C:"WORKING_DIR=" "%directory%\.env" > nul
if %errorlevel% equ 0 (
    for /f "tokens=2 delims==" %%a in ('findstr /C:"WORKING_DIR=" "%directory%\.env"') do (
        set "existing_working_dir=%%a"
    )
    if "!existing_working_dir!"=="" (
        echo WORKING_DIR is set in .env file with empty value, remove it for automatic path setting.
        goto incomplete
    )
) else (
    echo.>> "%directory%\.env"
    echo WORKING_DIR=!directory!>> "%directory%\.env"
)
endlocal

for /r "%directory%\configuration\apache\" %%f in (*.conf) do (
    for %%g in ("%directory%\docker\conf\docker-files\apache\%%~nxf") do (
        if "%%~tf" gtr "%%~tg" (
            copy "%%f" "%directory%\docker\conf\docker-files\apache\" /Y > nul
        )
    )
)

if not exist "%directory%\configuration\php\php.ini" (
    type nul > "%directory%\configuration\php\php.ini"
)

if "%1" == "start" (
    docker compose --project-directory "%directory%" -f docker/compose/docker-compose.yml up -d
) else if %1 == reload (
    docker compose --project-directory "%directory%" -f docker/compose/docker-compose.yml up -d
) else if %1 == up (
    docker compose --project-directory "%directory%" -f docker/compose/docker-compose.yml up
) else if %1 == stop (
    docker compose --project-directory "%directory%" -f docker/compose/docker-compose.yml down
) else if %1 == down (
    docker compose --project-directory "%directory%" -f docker/compose/docker-compose.yml down
) else if %1 == reboot (
    docker compose --project-directory "%directory%" -f docker/compose/docker-compose.yml down
    docker compose --project-directory "%directory%" -f docker/compose/docker-compose.yml up -d
) else if %1 == restart (
    docker compose --project-directory "%directory%" -f docker/compose/docker-compose.yml down
    docker compose --project-directory "%directory%" -f docker/compose/docker-compose.yml up -d
) else if %1 == rebuild (
    docker compose --project-directory "%directory%" -f docker/compose/docker-compose.yml down
    docker compose --project-directory "%directory%" -f docker/compose/docker-compose.yml build --no-cache --pull %2 %3 %4 %5 %6 %7 %8 %9
) else if %1 == core (
    docker exec -it Core bash -c "sudo -u devuser /bin/bash"
) else if %1 == lzd (
    docker exec -it SERVER_TOOLS lazydocker
) else (
    docker compose --project-directory "%directory%" -f docker/compose/docker-compose.yml %*
)

:incomplete
