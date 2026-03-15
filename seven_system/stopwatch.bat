@echo off
setlocal enabledelayedexpansion
color 3
title Stopwatch

set /a seconde=0
set /a minute=0
set /a heure=0
set running=0

:menu
cls
echo =========================
echo        STOPWATCH
echo =========================
echo.
echo Time: !heure!:!minute!:!seconde!
echo.
echo 1 - Start
echo 2 - Stop
echo 3 - Reset
echo 4 - Exit
echo.

choice /c 1234 /n /m "Select option: "

if errorlevel 4 exit
if errorlevel 3 goto reset
if errorlevel 2 goto stop
if errorlevel 1 goto start

goto menu

:start
set running=1
:chronoloop
cls
echo =========================
echo        STOPWATCH
echo =========================
echo.
echo Time: !heure!:!minute!:!seconde!
echo.
echo Press 2 to Stop, 3 to Reset, 4 to Exit
echo.

rem --- Incrément du temps ---
set /a seconde+=1
if !seconde! GEQ 60 (
    set /a seconde-=60
    set /a minute+=1
)
if !minute! GEQ 60 (
    set /a minute-=60
    set /a heure+=1
)

rem --- Pause 1 seconde ---
timeout /t 1 >nul

rem --- Vérifie si l'utilisateur veut arrêter ou reset ---
choice /c 234 /n /t 0 /d 0 >nul
if errorlevel 4 exit
if errorlevel 3 goto reset
if errorlevel 2 goto stop

if !running! equ 1 goto chronoloop
goto menu

:stop
set running=0
goto menu

:reset
set /a seconde=0
set /a minute=0
set /a heure=0
goto menu