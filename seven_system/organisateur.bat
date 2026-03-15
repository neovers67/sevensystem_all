@echo off
title Organisateur Pro v2.6
setlocal enabledelayedexpansion

:MENU
cls
echo ===========================================
echo ORGANISATEUR DE BUREAU PRO
echo ===========================================
echo 1. Trier uniquement les PDF (.pdf)
echo 2. Trier uniquement les Textes (.txt)
echo 3. Trier uniquement les Images (JPG, PNG, etc.)
echo 4. [MODE AUTO] Tout trier par defaut
echo 5. [PERSO] Saisir une extension specifique
echo 6. Quitter
echo ===========================================
set "choix="
set /p choix="Votre choix (1-6) : "

if "%choix%"=="1" set "ext=.pdf" & set "dest=Documents_PDF" & goto PROCESS
if "%choix%"=="2" set "ext=.txt" & set "dest=Notes_Texte" & goto PROCESS
if "%choix%"=="3" goto TRI_IMAGES
if "%choix%"=="4" goto TOUT_TRIER
if "%choix%"=="5" goto PERSO
if "%choix%"=="6" exit
goto MENU

:PROCESS
cls
echo === TRAITEMENT EN COURS ===
if not exist "%dest%" md "%dest%"
set "count=0"
for %%f in (*%ext%) do (
    if /i not "%%f"=="%~nx0" (
        move /y "%%f" "%dest%\" >nul 2>&1
        set /a count+=1
    )
)
echo [OK] !count! fichier(s) %ext% deplace(s) vers %dest%.
pause
goto MENU

:TRI_IMAGES
set "dest=Images"
if not exist "%dest%" md "%dest%"
set "count=0"
for %%e in (.jpg .jpeg .png .gif .bmp) do (
    for %%f in (*%%e) do (
        move /y "%%f" "%dest%\" >nul 2>&1
        set /a count+=1
    )
)
echo [OK] !count! images rangees dans %dest%.
pause
goto MENU

:TOUT_TRIER
echo Tri automatique des formats standards...
:: Utilisation d'une boucle pour simplifier l'appel
for %%a in (".pdf:Documents" ".txt:Documents" ".jpg:Images" ".png:Images" ".exe:Programmes" ".zip:Archives") do (
    for /f "tokens=1,2 delims=:" %%i in (%%a) do (
        if not exist "%%j" md "%%j"
        move /y "*%%i" "%%j\" >nul 2>&1
    )
)
echo [OK] Le grand ménage est terminé !
pause
goto MENU

:PERSO
cls
echo === CONFIGURATION PERSONNALISEE ===
set "userExt="
set "userDest="
set /p "userExt=Extension (ex: .mp3) : "
set /p "userDest=Dossier de destination : "
if "%userExt%"=="" goto MENU
if not "!userExt:~0,1!"=="." set "userExt=.!userExt!"
set "ext=!userExt!"
set "dest=!userDest!"
goto PROCESS

