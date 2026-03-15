@echo off
color 3
title Seven Menu

:menu
cls
echo ==========================
echo        SEVEN SYSTEM
echo ==========================
echo.
echo 1  - Game Menu
echo 2  - Timer
echo 3  - Stopwatch
echo 4  - Click Faster
echo 5  - Data Minecraft
echo 6  - Organisateur
echo 7  - MCreator
echo 8  - Survival Game
echo 9  - Start Mot Passe
echo 10 - Game1
echo 11 - Game2
echo 12 - Game3
echo 13 - Update Seven System
echo.
echo 0  - Quitter
echo.

set /p choice=Choix :

if "%choice%"=="1" start "" "%userprofile%\seven_system\GameMenu.bat"
if "%choice%"=="2" start "" "%userprofile%\seven_system\Timer.bat"
if "%choice%"=="3" start "" "%userprofile%\seven_system\stopwatch.bat"
if "%choice%"=="4" start "" "%userprofile%\seven_system\click faster.bat"
if "%choice%"=="5" start "" "%userprofile%\seven_system\dataminecraft.bat"
if "%choice%"=="6" start "" "%userprofile%\seven_system\organisateur.bat"
if "%choice%"=="7" start "" "%userprofile%\seven_system\mcreator.bat"
if "%choice%"=="8" start "" "%userprofile%\seven_system\survival_game.bat"
if "%choice%"=="9" start "" "%userprofile%\seven_system\startmotpasse.bat"
if "%choice%"=="10" start "" "%userprofile%\seven_system\game1.bat"
if "%choice%"=="11" start "" "%userprofile%\seven_system\game2.bat"
if "%choice%"=="12" start "" "%userprofile%\seven_system\game3.bat"
if "%choice%"=="13" start "" "%userprofile%\seven_system\update.bat"

if "%choice%"=="0" exit

goto menu