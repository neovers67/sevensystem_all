@echo off
title Focus Timer Pro v3.0
mode con: cols=65 lines=22
setlocal enabledelayedexpansion

set "logfile=focus_history.txt"

:START_MENU
color 0B
cls
echo ============================================================
echo POMODORO TIMER METHOD
echo ============================================================
echo 1. Standard Session (25 min)
echo 2. Long Session (1 hour)
echo 3. Custom Time (H:M)
echo 4. VIEW MY STATISTICS AND TOTAL
echo 5. RESET HISTORY
echo 6. Exit
echo ============================================================
set /p choice="Your choice: "

if "%choice%"=="1" set "h=0" & set "m=25" & goto PRE_TIMER
if "%choice%"=="2" set "h=1" & set "m=0" & goto PRE_TIMER
if "%choice%"=="3" goto CUSTOM
if "%choice%"=="4" goto SHOW_STATS
if "%choice%"=="5" goto RESET_LOG
if "%choice%"=="6" exit
goto START_MENU

:CUSTOM
cls
echo === CUSTOM TIME CONFIGURATION ===
set /p "h=Number of hours: "
set /p "m=Number of minutes: "
goto PRE_TIMER

:PRE_TIMER
set /a "total_sec=(h * 3600) + (m * 60)"
set /a "original_total_min=(h * 60) + m"

:TIMER_LOOP
if %total_sec% LSS 0 goto ALERT
set /a "hh=total_sec / 3600"
set /a "remaining=total_sec %% 3600"
set /a "mm=remaining / 60"
set /a "ss=remaining %% 60"

if %hh% LSS 10 set "hh=0%hh%"
if %mm% LSS 10 set "mm=0%mm%"
if %ss% LSS 10 set "ss=0%ss%"

cls
echo ============================================================
echo SESSION IN PROGRESS: %h%h %m%min
echo ============================================================
echo.
echo TIME LEFT: %hh%:%mm%:%ss%
echo.
echo ============================================================
timeout /t 1 /nobreak >nul
set /a total_sec-=1
goto TIMER_LOOP

:ALERT
echo %date% %time:~0,5% : %original_total_min%>> "%logfile%"
cls
color 0C
echo ============================================================
echo DONE! SESSION RECORDED
echo ============================================================
powershell -c "[console]::beep(1000,500)"
echo Congratulations! Session of %original_total_min% minutes recorded.
echo.
pause
goto START_MENU

:SHOW_STATS
cls
echo ============================================================
echo HISTORY AND TOTAL TIME
echo ============================================================
if not exist "%logfile%" (
    echo No sessions recorded.
    pause
    goto START_MENU
)
set "grand_total_min=0"
for /f "usebackq tokens=1,2,3,* delims=: " %%a in ("%logfile%") do (
    echo On %%a at %%b:%%c - Session of %%d min
    set /a grand_total_min+=%%d
)
set /a "th=grand_total_min / 60"
set /a "tm=grand_total_min %% 60"
echo ============================================================
echo TOTAL TIME: !th! hour(s) and !tm! minute(s)
echo ============================================================
pause
goto START_MENU

:RESET_LOG
cls
echo ============================================================
echo RESET HISTORY
echo ============================================================
echo.
echo WARNING: This will delete all your statistics.
set /p "confirm=Are you sure? (Y/N): "
if /i "%confirm%"=="Y" (
    del "%logfile%" >nul 2>&1
    echo.
    echo [OK] History deleted.
) else (
    echo.
    echo Operation canceled.
)
timeout /t 2 >nul
goto START_MENU