@echo off 
color 7
title Hello
set /a player1=0
set /a player2=0

:main_loop 
cls
echo Hello! Are you with a friend because you need one!
echo Ok! Rules are simple. The first to reach 50 click have won!
echo.
echo 1. Go To Keybind
echo 2. Start

choice /c 12 /n
if %errorlevel%==1 goto keybind
if %errorlevel%==2 goto game

:keybind
cls
echo Player 1 need to click Q
echo Player 2 need to clcik M
echo 1. Quit  
choice /c 1 /n
if %errorlevel%==1 goto main_loop

:game
set /a player1=0, player2=0
echo Ok. Ready!
timeout/t 2 > nul
cls
echo 3
timeout /t 1 > nul
cls
echo 2
timeout /t 1 > nul
cls
echo 1
timeout /t 1 > nul
echo GO!
cls
:loop
cls
if %player1% geq 100 goto 1win
if %player2% geq 100 goto 2win
echo ======================================================
echo PLAYER 1 : %player1%      PLAYER 2 : %player2%
echo ======================================================
choice /c qm /n
if %errorlevel%==1 set /a player1+=1 & goto loop
if %errorlevel%==2 set /a player2+=1 & goto loop 

:1win
echo GG! Player 1 Win!
timeout /t 10 > nul
goto main_loop

:2win
echo GG! Player 2 Win!
timeout /t 10 > nul
goto main_loop

