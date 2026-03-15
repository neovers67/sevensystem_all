@echo off
color 3

title Game_Menu

:cycle
cls
echo =====================
echo      VERSION MENU
echo =====================
echo.
echo                      1=first                      2=second                      3=third
echo                      4=fourth                      5=fifth                      6=sixth
echo                      7=seventh                                    
)

set /p choice="choice:"

if /i "%choice%"=="1" start %userprofile%\seven_system\gamerpgversions\premiere_version.bat & exit

if /i "%choice%"=="2" start %userprofile%\seven_system\gamerpgversions\deuxieme_version.bat & exit

if /i "%choice%"=="3" start %userprofile%\seven_system\gamerpgversions\troisieme_version.bat & exit

if /i "%choice%"=="4" start %userprofile%\seven_system\gamerpgversions\quatrieme_version.bat & exit

if /i "%choice%"=="5" start %userprofile%\seven_system\gamerpgversions\cinquieme_version.bat & exit

if /i "%choice%"=="6" start %userprofile%\seven_system\gamerpgversions\siexieme_version.bat & exit

if /i "%choice%"=="7" start %userprofile%\seven_system\gamerpgversions\septieme_version.bat & exit
