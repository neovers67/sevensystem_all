@echo off
title Mini RPG Batch
setlocal EnableDelayedExpansion

set playerHP=100
set enemyHP=50

:gameLoop
cls
echo === MINI RPG ===
echo Player HP: %playerHP%
echo Enemy HP: %enemyHP%
echo.
echo 1 Attack
echo 2 Heal
echo 3 Quit
echo.

choice /c 123 /n /m "Choose an action: "

REM --- Player actions ---
if errorlevel 3 exit
if errorlevel 2 goto heal
if errorlevel 1 goto attack

:attack
cls
echo You attack the enemy!
set /a enemyHP-=15
timeout /t 1 >nul

echo The enemy takes 15 damage.
timeout /t 1 >nul

echo The enemy strikes back!
set /a playerHP-=10
timeout /t 1 >nul

goto check

:heal
cls
echo You use a healing potion!
set /a playerHP+=10
timeout /t 1 >nul

echo You recover 10 HP.
timeout /t 1 >nul

echo The enemy attacks while you heal!
set /a playerHP-=10
timeout /t 1 >nul

goto check

:check
if %enemyHP% LEQ 0 goto win
if %playerHP% LEQ 0 goto lose
goto gameLoop

:win
cls
echo You defeated the enemy!
pause
exit

:lose
cls
echo You were defeated...
pause
exit
