@echo off
title BATCH QUEST - ULTIMATE
mode con: cols=100 lines=40
setlocal EnableDelayedExpansion

REM ================= COLORS =================
set R=[31m
set G=[32m
set Y=[33m
set B=[34m
set C=[36m
set W=[0m

REM ================= SETTINGS =================
set speed=1
set hardcore=0

REM ================= PLAYER =================
set level=1
set xp=0
set nextXP=50
set maxHP=100
set hp=100
set atk=8
set def=2
set gold=30
set potions=2
set weapon=Fists
set quest=0
set deaths=0

REM ================= INVENTORY =================
set invSword=0
set invAxe=0
set invShield=0

REM ================= LOAD =================
if exist save.dat (
 cls
 echo Save found.
 choice /c YN /m "Load save?"
 if errorlevel 1 call save.dat
)

:menu
cls
echo %C%=== BATCH QUEST : ULTIMATE ===%W%
echo 1 Continue
echo 2 Save Game
echo 3 Stats
echo 4 Quit
choice /c 1234 /n
if errorlevel 4 exit
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
echo Deaths: %deaths%
pause
goto menu

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
echo 4 Back
choice /c 1234 /n

if errorlevel 4 goto world
if errorlevel 3 goto shop
if errorlevel 2 goto npc
if errorlevel 1 set hp=%maxHP%&echo Rested.&timeout /t 1>nul&goto village

:npc
cls
echo Old Man:
echo 1 "Tell me about the dragon"
echo 2 "Any advice?"
echo 3 Leave
choice /c 123 /n
if errorlevel 3 goto village
if errorlevel 2 echo "Train and buy equipment."&pause&goto npc
if errorlevel 1 echo "The dragon is immortal unless weakened."&pause&goto npc

:shop
cls
echo %Y%SHOP%W%
echo Gold: %gold%
echo 1 Potion (10g)
echo 2 Sword (+5 ATK) (30g)
echo 3 Axe (+8 ATK) (50g)
echo 4 Shield (+3 DEF) (40g)
echo 5 Back
choice /c 12345 /n

if errorlevel 5 goto village
if errorlevel 4 (
 if %gold% GEQ 40 set /a gold-=40&set invShield=1&set /a def+=3&echo Shield bought!
 timeout /t 1>nul&goto shop
)
if errorlevel 3 (
 if %gold% GEQ 50 set /a gold-=50&set invAxe=1&echo Axe bought!
 timeout /t 1>nul&goto shop
)
if errorlevel 2 (
 if %gold% GEQ 30 set /a gold-=30&set invSword=1&echo Sword bought!
 timeout /t 1>nul&goto shop
)
if errorlevel 1 (
 if %gold% GEQ 10 set /a gold-=10&set /a potions+=1&echo Potion bought!
 timeout /t 1>nul&goto shop
)

:forest
call :enemy Goblin 40 6 20
goto combat

:darkforest
call :enemy Shadow 70 12 40
goto combat

:city
cls
echo %B%City%W%
echo Merchants and guards everywhere.
pause
goto world

:dungeon
call :enemy Dragon 200 20 150
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
echo %R%COMBAT%W%
echo Enemy: %enemyName% (%enemyHP% HP)
echo HP %hp%/%maxHP%  Potions %potions%
echo.
echo 1 Attack
echo 2 Potion
echo 3 Run
echo P Pause
choice /c 123P /n

if errorlevel 4 pause
if errorlevel 3 goto world
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

set /a edmg=(%random% %% enemyATK)+3-def
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
echo +%reward% XP / Gold
set /a xp+=reward
set /a gold+=reward
timeout /t 2>nul

if %xp% GEQ %nextXP% (
 set /a level+=1
 set /a xp=0
 set /a nextXP+=50
 set /a maxHP+=20
 set /a atk+=2
 set /a def+=1
 set hp=%maxHP%
 echo LEVEL UP!
 timeout /t 2>nul
)

if "%enemyName%"=="Dragon" goto ending
goto world

:ending
cls
echo %C%YOU SAVED THE WORLD%W%
echo The dragon is dead.
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
echo %R%GAME OVER%W%
if %hardcore%==1 exit
pause
goto menu
