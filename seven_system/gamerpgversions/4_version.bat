@echo off
title BATCH QUEST - Advanced RPG
mode con: cols=80 lines=30
setlocal EnableDelayedExpansion

REM === ANSI COLORS ===
set R=[31m
set G=[32m
set Y=[33m
set B=[34m
set C=[36m
set W=[0m

REM === PLAYER ===
set level=1
set xp=0
set nextXP=50
set maxHP=100
set hp=100
set atk=10
set potions=3
set gold=20
set weapon=Fists

REM === LOAD SAVE ===
if exist save.dat (
    cls
    echo Save found.
    choice /c YN /m "Load save?"
    if errorlevel 1 call save.dat
)

:menu
cls
echo %C%=== BATCH QUEST ===%W%
echo 1 Start / Continue
echo 2 Save Game
echo 3 Quit
choice /c 123 /n

if errorlevel 3 exit
if errorlevel 2 goto save
if errorlevel 1 goto map

:save
cls
(
echo set level=%level%
echo set xp=%xp%
echo set nextXP=%nextXP%
echo set maxHP=%maxHP%
echo set hp=%hp%
echo set atk=%atk%
echo set potions=%potions%
echo set gold=%gold%
echo set weapon=%weapon%
)>save.dat
echo Game saved!
timeout /t 2 >nul
goto menu

:map
cls
echo %Y%MAP%W%
echo [V] Village
echo [F] Forest
echo [D] Dungeon (Boss)
choice /c VFD /n /m "Where do you go?"

if errorlevel 3 goto dungeon
if errorlevel 2 goto forest
if errorlevel 1 goto village

:village
cls
echo %G%=== VILLAGE ===%W%
echo HP: %hp%/%maxHP%  Gold: %gold%  Weapon: %weapon%
echo.
echo 1 Rest
echo 2 Shop
echo 3 Back
choice /c 123 /n

if errorlevel 3 goto map
if errorlevel 2 goto shop
if errorlevel 1 (
    set hp=%maxHP%
    echo You feel rested.
    timeout /t 2 >nul
    goto village
)

:shop
cls
echo %Y%=== SHOP ===%W%
echo Gold: %gold%
echo.
echo 1 Potion (10g)
echo 2 Sword (+5 ATK) (30g)
echo 3 Back
choice /c 123 /n

if errorlevel 3 goto village
if errorlevel 2 (
    if %gold% GEQ 30 (
        set /a gold-=30
        set /a atk+=5
        set weapon=Sword
        echo You bought a Sword!
    ) else echo Not enough gold!
    timeout /t 2 >nul
    goto shop
)
if errorlevel 1 (
    if %gold% GEQ 10 (
        set /a gold-=10
        set /a potions+=1
        echo Potion bought!
    ) else echo Not enough gold!
    timeout /t 2 >nul
    goto shop
)

:forest
call :enemy Goblin 40 8 20
goto combat

:dungeon
call :enemy Dragon 120 15 100
set boss=1
goto combat

:enemy
set enemyName=%1
set enemyHP=%2
set enemyATK=%3
set rewardXP=%4
exit /b

:combat
set boss=0
:combatLoop
cls
echo %R%=== COMBAT ===%W%
echo Enemy: %enemyName%
echo Enemy HP: %enemyHP%
echo.
echo HP: %hp%/%maxHP%  Potions: %potions%
echo.
echo 1 Attack
echo 2 Potion
echo 3 Run
choice /c 123 /n

if errorlevel 3 if "%enemyName%"=="Dragon" goto combatLoop else goto map
if errorlevel 2 goto potion
if errorlevel 1 goto attack

:attack
set /a dmg=(%random% %% atk)+5
set /a enemyHP-=dmg
echo You deal %dmg% damage!
timeout /t 1 >nul

if %enemyHP% LEQ 0 goto win

set /a edmg=(%random% %% enemyATK)+3
set /a hp-=edmg
echo Enemy hits you for %edmg%!
timeout /t 1 >nul
goto check

:potion
if %potions% LEQ 0 (
    echo No potions!
    timeout /t 1 >nul
    goto combatLoop
)
set /a potions-=1
set /a hp+=30
if %hp% GTR %maxHP% set hp=%maxHP%
echo You healed!
timeout /t 1 >nul
goto combatLoop

:check
if %hp% LEQ 0 goto gameOver
goto combatLoop

:win
cls
echo %G%Enemy defeated!%W%
set /a gold+=rewardXP
set /a xp+=rewardXP
echo Gained %rewardXP% XP & Gold
timeout /t 2 >nul

if %xp% GEQ %nextXP% (
    set /a level+=1
    set /a xp=0
    set /a nextXP+=50
    set /a maxHP+=20
    set /a atk+=5
    set hp=%maxHP%
    echo %Y%LEVEL UP!%W%
    timeout /t 2 >nul
)

goto map

:gameOver
cls
echo %R%GAME OVER%W%
pause
exit
