@echo off
title Acces Menu
color 0A

:login
cls
echo ============================
echo        ACCES MENU
echo ============================
echo.

set /p pass=Entrez le mot de passe : 

if "%pass%"=="1234" goto menu

echo.
echo Mot de passe incorrect !
timeout /t 2 >nul
goto login

:menu
cls
echo Acces autorise !
timeout /t 1 >nul

start /i "" "C:\%userprofile%\desktop\seven_menu.bat"
exit