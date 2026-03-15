@echo off
title BATCH QUEST - LEGENDARY EDITION
mode con: cols=100 lines=40
setlocal EnableDelayedExpansion

REM ================= COLORS =================
set R=[31m
set G=[32m
set Y=[33m
set B=[34m
set C=[36m
set W=[0m

REM ================= GAME SETTINGS =================
set speed=1
set hardcore=0
set deaths=0

REM ================= PLAYER =================
set level=1
set xp=0
set nextXP=50
set maxHP=120
set hp=120
set atk=10
set def=2
set gold=50
set potions=3
set weapon=Fists
set quest=0

REM ================= INVENTORY =================
set invSword=0
set invAxe=0
set invShield=0
set invRing=0

REM ================= MINI-GAMES =================
REM 1=luck, 2=trap, etc.

REM ================= LOAD SAVE =================
if exist save.dat (
 cls
 echo Save found.
 choice /c YN /m "Load save?"
 if errorlevel 1 call save.dat
)

:menu
cls
echo %C%=== BATCH QUEST : LEGENDARY ===%W%
echo 1 Continue / Start
echo 2 Save Game
echo 3 Stats
echo 4 Inventory
echo 5 Quit
choice /c 12345 /n

if errorlevel 5 exit
if errorlevel 4 goto inventory
if errorlevel 3 goto stats
if errorlevel 2 goto save
if errorlevel 1 goto world

:save
(
echo set level=%level%
echo set xp=%xp%
echo set nextXP=%nextXP%
echo set maxHP=%maxHP%
echo set hp=%hp%
echo set atk=%atk%
echo set def=%def%
echo set gold=%gold%
echo set potions=%potions%
echo set weapon=%weapon%
echo set quest=%quest%
echo set invSword=%invSword%
echo set invAxe=%invAxe%
echo set invShield=%invShield%
echo set invRing=%invRing%
echo set deaths=%deaths%
)>save.dat
echo Game saved!
timeout /t 2 >nul
goto menu

:stats
cls
echo %Y%=== STATS ===%W%
echo Level: %level%
echo XP: %xp% / %nextXP%
echo HP: %hp% / %maxHP%
echo ATK: %atk%
echo DEF: %def%
echo Gold: %gold%
echo Weapon: %weapon%
echo Potions: %potions%
echo Deaths: %deaths%
pause
goto menu

:inventory
cls
echo %C%=== INVENTORY ===%W%
echo 1 Equip Fists
if %invSword%==1 echo 2 Equip Sword
if %invAxe%==1 echo 3 Equip Axe
if %invShield%==1 echo 4 Equip Shield
if %invRing%==1 echo 5 Equip Ring (+2 ATK)
echo 6 Back
choice /c 123456 /n

if errorlevel 6 goto menu
if errorlevel 5 if %invRing%==1 (set weapon=Ring&set /a atk+=2)
if errorlevel 4 if %invShield%==1 (set weapon=Shield&set /a def+=3)
if errorlevel 3 if %invAxe%==1 (set weapon=Axe&set /a atk=16)
if errorlevel 2 if %invSword%==1 (set weapon=Sword&set /a atk=13)
if errorlevel 1 (set weapon=Fists&set /a atk=10)
goto inventory

:world
cls
echo %Y%WORLD MAP%W%
echo [1] Village
echo [2] Forest
echo [3] City
echo [4] Dark Forest
echo [5] Dungeon
choice /c 12345 /n

if errorlevel 5 goto dungeon
if errorlevel 4 goto darkforest
if errorlevel 3 goto city
if errorlevel 2 goto forest
if errorlevel 1 goto village

:village
cls
echo %G%Village%W%
echo 1 Rest
echo 2 NPC
echo 3 Shop
echo 4 Mini-game
echo 5 Back
choice /c 12345 /n

if errorlevel 5 goto world
if errorlevel 4 goto minigame
if errorlevel 3 goto shop
if errorlevel 2 goto npc
if errorlevel 1 set hp=%maxHP%&echo Rested.&timeout /t 1>nul&goto village

:npc
cls
echo Old Man:
if %quest%==0 (
 echo "A dragon terrorizes the dungeon..."
 set quest=1
) else if %quest%==2 (
 echo "You are our hero!"
) else (
 echo "The dragon still lurks..."
)
pause
goto village

:shop
cls
echo %Y%SHOP%W%
echo Gold: %gold%
echo 1 Potion (10g)
echo 2 Sword (+5 ATK) (30g)
echo 3 Axe (+8 ATK) (50g)
echo 4 Shield (+3 DEF) (40g)
echo 5 Ring (+2 ATK) (60g)
echo 6 Back
choice /c 123456 /n

if errorlevel 6 goto village
if errorlevel 5 if %gold% GEQ 60 set /a gold-=60&set invRing=1&echo Ring bought!&timeout /t 1>nul&goto shop
if errorlevel 4 if %gold% GEQ 40 set /a gold-=40&set invShield=1&set /a def+=3&echo Shield bought!&timeout /t 1>nul&goto shop
if errorlevel 3 if %gold% GEQ 50 set /a gold-=50&set invAxe=1&echo Axe bought!&timeout /t 1>nul&goto shop
if errorlevel 2 if %gold% GEQ 30 set /a gold-=30&set invSword=1&echo Sword bought!&timeout /t 1>nul&goto shop
if errorlevel 1 if %gold% GEQ 10 set /a gold-=10&set /a potions+=1&echo Potion bought!&timeout /t 1>nul&goto shop

:forest
call :enemy Goblin 50 6 25
goto combat

:darkforest
call :enemy Shadow 80 10 50
goto combat

:city
cls
echo %B%City%W%
echo Merchants, NPCs, and shops abound
pause
goto world

:dungeon
set floor=1
:dungeonLoop
cls
echo %R%DUNGEON - FLOOR %floor%%W%
if %floor% LSS 3 (
 call :enemy Skeleton 70 10 40
 goto combat
)
call :enemy Dragon 200 20 200
goto combat

:enemy
set enemyName=%1
set enemyHP=%2
set enemyATK=%3
set reward=%4
exit /b

:combat
:combatLoop
cls
echo %R%=== COMBAT ===%W%
echo Enemy: %enemyName% (%enemyHP% HP)
echo HP %hp%/%maxHP%  Potions %potions%
echo.
echo 1 Attack
echo 2 Potion
echo 3 Run
echo P Pause
choice /c 123P /n

if errorlevel 4 pause&goto combatLoop
if errorlevel 3 if "%enemyName%"=="Dragon" goto combatLoop else goto world
if errorlevel 2 goto heal
if errorlevel 1 goto attack

:attack
set /a crit=%random% %% 10
set /a dmg=(%random% %% atk)+5
if %crit% GEQ 8 set /a dmg*=2&echo CRITICAL HIT!
set /a enemyHP-=dmg
echo You deal %dmg% damage!
timeout /t %speed% >nul
if %enemyHP% LEQ 0 goto win

REM === ENEMY AI ===
set /a ai=%random% %% 10
if %ai% GEQ 8 (
 set /a edmg=(%random% %% enemyATK)+3-def
 echo Enemy blocks part of your attack!
) else (
 set /a edmg=(%random% %% enemyATK)+3-def
)
if %edmg% LSS 0 set edmg=0
set /a hp-=edmg
echo Enemy hits you for %edmg%!
timeout /t %speed% >nul
if %hp% LEQ 0 goto gameOver
goto combatLoop

:heal
if %potions% LEQ 0 echo No potions!&timeout /t 1>nul&goto combatLoop
set /a potions-=1
set /a hp+=30
if %hp% GTR %maxHP% set hp=%maxHP%
echo Healed!
timeout /t 1>nul
goto combatLoop

:win
cls
echo %G%Enemy defeated!%W%
set /a xp+=reward
set /a gold+=reward
echo +%reward% XP / Gold
timeout /t 2>nul

if %xp% GEQ %nextXP% (
 set /a level+=1
 set /a xp=0
 set /a nextXP+=50
 set /a maxHP+=20
 set /a atk+=2
 set /a def+=1
 set hp=%maxHP%
 echo %Y%LEVEL UP!%W%
 timeout /t 2>nul
)

if "%enemyName%"=="Dragon" goto ending
if "%enemyName%"=="Skeleton" set /a floor+=1&goto dungeonLoop
goto world

:ending
cls
echo %C%=== YOU SAVED THE WORLD ===%W%
echo Congratulations, hero!
echo.
echo Credits:
echo Game Design: You
echo Programming: Batch
echo Thanks for playing!
pause
exit

:gameOver
set /a deaths+=1
cls
echo %R%=== GAME OVER ===%W%
if %hardcore%==1 exit
pause
goto menu
