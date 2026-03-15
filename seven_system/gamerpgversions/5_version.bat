@echo off
title BATCH QUEST - FINAL
mode con: cols=90 lines=35
setlocal EnableDelayedExpansion

REM ===== ANSI COLORS =====
set R=[31m
set G=[32m
set Y=[33m
set B=[34m
set C=[36m
set W=[0m

REM ===== PLAYER =====
set level=1
set xp=0
set nextXP=50
set maxHP=100
set hp=100
set atk=8
set gold=30
set potions=2
set weapon=Fists
set quest=0

REM ===== INVENTORY =====
set invSword=0
set invAxe=0

REM ===== LOAD SAVE =====
if exist save.dat (
 cls
 echo Save found.
 choice /c YN /m "Load save?"
 if errorlevel 1 call save.dat
)

:menu
cls
echo %C%=== BATCH QUEST ===%W%
echo 1 Continue
echo 2 Save Game
echo 3 Quit
choice /c 123 /n
if errorlevel 3 exit
if errorlevel 2 goto save
if errorlevel 1 goto map

:save
(
echo set level=%level%
echo set xp=%xp%
echo set nextXP=%nextXP%
echo set maxHP=%maxHP%
echo set hp=%hp%
echo set atk=%atk%
echo set gold=%gold%
echo set potions=%potions%
echo set weapon=%weapon%
echo set quest=%quest%
echo set invSword=%invSword%
echo set invAxe=%invAxe%
)>save.dat
echo Game saved!
timeout /t 2 >nul
goto menu

:map
cls
echo %Y%MAP%W%
echo [V] Village
echo [F] Forest
echo [D] Dungeon
choice /c VFD /n
if errorlevel 3 goto dungeon
if errorlevel 2 goto forest
if errorlevel 1 goto village

:village
cls
echo %G%=== VILLAGE ===%W%
echo HP %hp%/%maxHP%  Gold %gold%  Weapon %weapon%
echo.
echo 1 Rest
echo 2 Shop
echo 3 NPC
echo 4 Inventory
echo 5 Back
choice /c 12345 /n

if errorlevel 5 goto map
if errorlevel 4 goto inventory
if errorlevel 3 goto npc
if errorlevel 2 goto shop
if errorlevel 1 (
 set hp=%maxHP%
 echo You feel rested.
 timeout /t 2 >nul
 goto village
)

:npc
cls
if %quest%==0 (
 echo Old Man: "A dragon lives in the dungeon..."
 echo Quest started: Defeat the Dragon!
 set quest=1
) else if %quest%==2 (
 echo Old Man: "You saved us all! Thank you!"
) else (
 echo Old Man: "The dragon still lives..."
)
pause
goto village

:shop
cls
echo %Y%=== SHOP ===%W%
echo Gold: %gold%
echo.
echo 1 Potion (10g)
echo 2 Sword (+5 ATK) (30g)
echo 3 Axe (+8 ATK) (50g)
echo 4 Back
choice /c 1234 /n

if errorlevel 4 goto village
if errorlevel 3 (
 if %gold% GEQ 50 (
  set /a gold-=50
  set invAxe=1
  echo Axe bought!
 ) else echo Not enough gold!
 timeout /t 2 >nul
 goto shop
)
if errorlevel 2 (
 if %gold% GEQ 30 (
  set /a gold-=30
  set invSword=1
  echo Sword bought!
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

:inventory
cls
echo %C%=== INVENTORY ===%W%
echo 1 Equip Fists
if %invSword%==1 echo 2 Equip Sword
if %invAxe%==1 echo 3 Equip Axe
echo 4 Back
choice /c 1234 /n

if errorlevel 4 goto village
if errorlevel 3 if %invAxe%==1 (set weapon=Axe&set atk=16)
if errorlevel 2 if %invSword%==1 (set weapon=Sword&set atk=13)
if errorlevel 1 (set weapon=Fists&set atk=8)
goto village

:forest
call :enemy Goblin 40 6 20
goto combat

:dungeon
set floor=1
:dungeonLoop
cls
echo %R%DUNGEON - FLOOR %floor%%W%
if %floor% LSS 3 (
 call :enemy Skeleton 60 10 40
 goto combat
)
call :enemy Dragon 150 18 120
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
echo.
echo HP %hp%/%maxHP%  Potions %potions%
echo.
echo 1 Attack
echo 2 Potion
echo 3 Run
choice /c 123 /n

if errorlevel 3 if "%enemyName%"=="Dragon" goto combatLoop else goto map
if errorlevel 2 goto usePotion
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
if %hp% LEQ 0 goto gameOver
goto combatLoop

:usePotion
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

:win
cls
echo %G%Enemy defeated!%W%
set /a gold+=reward
set /a xp+=reward
echo +%reward% Gold / XP
timeout /t 2 >nul

if %xp% GEQ %nextXP% (
 set /a level+=1
 set /a xp=0
 set /a nextXP+=50
 set /a maxHP+=20
 set /a atk+=2
 set hp=%maxHP%
 echo %Y%LEVEL UP!%W%
 timeout /t 2 >nul
)

if "%enemyName%"=="Dragon" (
 set quest=2
 goto ending
)

if "%enemyName%"=="Skeleton" (
 set /a floor+=1
 goto dungeonLoop
)

goto map

:ending
cls
echo %C%=== YOU WIN ===%W%
echo The Dragon is dead.
echo Peace returns to the land.
pause
exit

:gameOver
cls
echo %R%GAME OVER%W%
pause
exit
