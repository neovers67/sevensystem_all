@echo off
title Focus Timer Pro v3.0
mode con: cols=65 lines=22
setlocal enabledelayedexpansion

set "logfile=focus_history.txt"

:START_MENU
color 0B
cls
echo ============================================================
echo METHODE POMODORO (HEURES)
echo ============================================================
echo 1. Session Standard (25 min)
echo 2. Session Longue (1 heure)
echo 3. Temps Personnalise (H:M)
echo 4. VOIR MES STATISTIQUES ET TOTAL
echo 5. REINITIALISER L'HISTORIQUE
echo 6. Quitter
echo ============================================================
set "choix="
set /p choix="Votre choix : "

if "%choix%"=="1" set "h=0" & set "m=25" & goto PRE_TIMER
if "%choix%"=="2" set "h=1" & set "m=0" & goto PRE_TIMER
if "%choix%"=="3" goto CUSTOM
if "%choix%"=="4" goto SHOW_STATS
if "%choix%"=="5" goto RESET_LOG
if "%choix%"=="6" exit
goto START_MENU

:CUSTOM
cls
echo === CONFIGURATION DU TEMPS ===
set /p "h=Nombre d'heures : "
set /p "m=Nombre de minutes : "
goto PRE_TIMER

:PRE_TIMER
set /a "total_sec=(%h% * 3600) + (%m% * 60)"
set /a "original_total_min=(%h% * 60) + %m%"
cls

:TIMER_LOOP
if %total_sec% LSS 0 goto ALERTE
set /a "hh=%total_sec% / 3600", "reste=%total_sec% %% 3600", "mm=%reste% / 60", "ss=%reste% %% 60"
if %hh% LSS 10 set "hh=0%hh%"
if %mm% LSS 10 set "mm=0%mm%"
if %ss% LSS 10 set "ss=0%ss%"

cls
echo ============================================================
echo SESSION EN COURS : %h%h %m%min
echo ============================================================
echo.
echo TEMPS RESTANT : %hh%:%mm%:%ss%
echo.
echo ============================================================
timeout /t 1 /nobreak >nul
set /a "total_sec-=1"
goto TIMER_LOOP

:ALERTE
echo %date% %time:~0,5% : %original_total_min%>> "%logfile%"
cls
color 0C
echo ============================================================
echo TERMINE ! SESSION ENREGISTREE
echo ============================================================
echo.
powershell -c "[console]::beep(1000,500)"
echo Bravo ! Session de %original_total_min% min enregistree.
echo.
pause
goto START_MENU

:SHOW_STATS
cls
echo ============================================================
echo HISTORIQUE ET TEMPS TOTAL
echo ============================================================
if not exist "%logfile%" (
    echo Aucune session enregistree.
    pause & goto START_MENU
)
set "grand_total_min=0"
for /f "tokens=1,2,3,4 delims=: " %%a in (%logfile%) do (
    echo Le %%a a %%b:%%c - Session de %%d min
    set /a "grand_total_min+=%%d"
)
set /a "th=%grand_total_min% / 60", "tm=%grand_total_min% %% 60"
echo ============================================================
echo TOTAL CUMULE : !th! heure(s) et !tm! minute(s)
echo ============================================================
echo.
pause
goto START_MENU

:RESET_LOG
cls
echo ============================================================
echo REINITIALISATION DE L'HISTORIQUE
echo ============================================================
echo.
echo ATTENTION : Cela va supprimer toutes vos statistiques.
set /p "confirm=Etes-vous sur ? (O/N) : "
if /i "%confirm%"=="O" (
    del "%logfile%" >nul 2>&1
    echo.
    echo [OK] Historique supprime.
) else (
    echo.
    echo Operation annulee.
)
timeout /t 2 >nul
goto START_MENU

