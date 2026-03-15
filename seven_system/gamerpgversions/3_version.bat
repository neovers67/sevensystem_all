@echo off
title BATCH QUEST
setlocal EnableDelayedExpansion

REM === PLAYER STATS ===
set playerMaxHP=100
set playerHP=100
set playerATK=15
set potions=3
set gold=0

:menu
cls
echo === BATCH QUEST ===
echo 1 Start Game
echo 2 Help
echo 3 Quit
choice /c 123 /n

if errorlevel 3 exit
if errorlevel 2 goto help
if errorlevel 1 goto village

:help
cls
echo Welcome to BATCH QUEST!
echo Defeat enemies, earn gold, and survive.
echo.
pause
goto menu

:village
cls
echo === VILLAGE ===
echo HP: %playerHP%/%playerMaxHP%   Gold: %gold%   Potions: %potions%
echo.
echo 1 Rest (restore HP)
echo 2 Go to Forest
echo 3 Quit Game
choice /c 123 /n

if errorlevel 3 exit
if errorlevel 2 goto forest
if errorlevel 1 (
    cls
    echo You rest at the inn...
    set playerHP=%playerMaxHP%
    timeout /t 2 >nul
    goto village
)

:forest
cls
echo You enter the forest...
timeout /t 2 >nul

REM === ENEMY GENERATION ===
set enemyName=Goblin
set enemyHP=40
set enemyATK=10
set reward=10

goto combat

:combat
cls
echo === COMBAT ===
echo Enemy: %enemyName%
echo Enemy HP: %enemyHP%
echo.
echo Your HP: %playerHP%
echo Potions: %potions%
echo.
echo 1 Attack
echo 2 Use Potion
echo 3 Run
choice /c 123 /n

if errorlevel 3 goto village
if errorlevel 2 goto usePotion
if errorlevel 1 goto attack

:attack
cls
echo You attack the %enemyName%!
set /a enemyHP-=playerATK
timeout /t 1 >nul

if %enemyHP% LEQ 0 goto winCombat

echo The %enemyName% attacks back!
set /a playerHP-=enemyATK
timeout /t 1 >nul

goto checkCombat

:usePotion
cls
if %potions% LEQ 0 (
    echo No potions left!
    timeout /t 2 >nul
    goto combat
)

echo You use a potion!
set /a potions-=1
set /a playerHP+=30
if %playerHP% GTR %playerMaxHP% set playerHP=%playerMaxHP%
timeout /t 1 >nul

echo The enemy attacks!
set /a playerHP-=enemyATK
timeout /t 1 >nul

goto checkCombat

:checkCombat
if %playerHP% LEQ 0 goto gameOver
goto combat

:winCombat
cls
echo You defeated the %enemyName%!
echo You gained %reward% gold.
set /a gold+=reward
timeout /t 2 >nul
goto village

:gameOver
cls
echo === GAME OVER ===
echo You have been defeated...
pause
exit
