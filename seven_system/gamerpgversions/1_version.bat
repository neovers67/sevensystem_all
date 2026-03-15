@echo off
title Mini RPG Batch
set vie=100
set ennemi=50

:loop
cls
echo === MINI RPG ===
echo Votre vie: %vie%
echo Vie ennemi: %ennemi%
echo.
echo 1 Attaquer
echo 2 Se soigner
echo 3 Quitter

choice /c 123 /n
if errorlevel 3 exit
if errorlevel 2 set /a vie+=10
if errorlevel 1 (
    set /a ennemi-=15
    set /a vie-=10
)

if %ennemi% LEQ 0 goto win
if %vie% LEQ 0 goto lose
goto loop

:win
cls
echo Victoire !
pause
exit

:lose
cls
echo Defaite...
pause
exit
