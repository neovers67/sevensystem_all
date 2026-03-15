@echo off
color 3

title Game_Menu

:cycle
cls
echo =====================
echo      GAME MENU
echo =====================
echo.
echo                                        1=rpg game                      2=Snake                3=survival game
)

set /p choice="choice:"

if /i "%choice%"=="1" start %userprofile%\seven_system\gamerpgversions\MenuOfVersions.bat & exit

if /i "%choice%"=="2" start %userprofile%\seven_system\game2.bat & exit

if /i "%choice%"=="3" start %userprofile%\seven_system\game3.bat & exit