@echo off 
setlocal enbledalyexansion
Color 3
Title Chronomètre

Set /a %seconde% =0
Set /a %minute% =0
Set /a %heure% =0
Set /a %dochrono% =0
Echo "!heure!":"!minute!":"!seconde!"

Echo 1.start
Echo 2.stop
Echo 3.reset
Echo 4.exit
::if 60sec do 1m
If %seconde% =60
  Set /a %seconde% -=60
  Set /a %minute% +=1

::if 60min do 1h
If %minute% =60 (
  Set /a %minute% -=60
  Set /a %heure% +=1

Set /p "choice"==""

If "choice"=="1" (
  Set /p %dochrono% =1
  :cycle
  Timeout /t 1>nul
  Set /a %seconde% +=1
  If %dochrono% =1 goto cycle
)

If "choice"=="2" set /a %dochrono% =0

If "choice"=="3" (
  Set /a %seconde% =0
  Set /a %minute% =0
  Set /a %heure% =0
)

If "choice"=="4" (
  Start %userprofile%   seven_system/seven_menu.bat
Exit
)