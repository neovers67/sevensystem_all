@echo off
color 0a
title SevenSystem Updater

echo ================================
echo        SevenSystem Update
echo ================================
echo.

set ZIP_FILE=%TEMP%\seven_update.zip
set INSTALL_DIR=%CD%
set DOWNLOAD_URL=https://github.com/neovers67/sevensystem_all/archive/refs/heads/main.zip

echo Checking for updates...

curl -L "%DOWNLOAD_URL%" -o "%ZIP_FILE%"

echo.
echo Updating files...

powershell -command "Expand-Archive -Path '%ZIP_FILE%' -DestinationPath '%INSTALL_DIR%' -Force"

echo.
echo Update complete!
pause
