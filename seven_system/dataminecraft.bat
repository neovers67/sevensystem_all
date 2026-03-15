@echo off
title MC World Backup & Zip v2.0
mode con: cols=75 lines=25
setlocal enabledelayedexpansion

:: Configuration des chemins
set "mc_saves=%appdata%\.minecraft\saves"
set "backup_root=%userprofile%\Desktop\Sauvegardes_Minecraft"

:MENU
cls
echo ============================================================
echo MINECRAFT WORLD MANAGER (VERSION ZIP)
echo ============================================================
echo Source : %mc_saves%
echo.
echo 1. Lister mes mondes Minecraft
echo 2. SAUVEGARDER EN .ZIP (Recommande)
echo 3. SAUVEGARDER EN DOSSIER SIMPLE
echo 4. Ouvrir le dossier des sauvegardes
echo 5. Quitter
echo ============================================================
set /p choix="Votre choix : "

if "%choix%"=="1" goto LIST_WORLDS
if "%choix%"=="2" goto BACKUP_ZIP
if "%choix%"=="3" goto BACKUP_FOLDER
if "%choix%"=="4" start "" "%backup_root%" & goto MENU
if "%choix%"=="5" exit
goto MENU

:LIST_WORLDS
cls
echo === LISTE DES MONDES DETECTES ===
echo.
if not exist "%mc_saves%" echo [!] Dossier saves introuvable. & pause & goto MENU
set "count=0"
for /d %%d in ("%mc_saves%\*") do (
    echo [MONDE] %%~nxd
    set /a count+=1
)
echo.
echo Total : %count% mondes trouves.
pause
goto MENU

:BACKUP_ZIP
cls
if not exist "%backup_root%" md "%backup_root%"
:: Formatage de la date et heure pour le nom du fichier
set "timestamp=%date:~6,4%-%date:~3,2%-%date:~0,2%_%time:~0,2%h%time:~3,2%"
set "timestamp=%timestamp: =0%"
set "zip_file=%backup_root%\MC_Backup_%timestamp%.zip"

echo === COMPRESSION DES MONDES EN COURS ===
echo Creation de : %zip_file%
echo.
echo Cela peut prendre quelques minutes selon la taille...
echo.

:: Commande PowerShell pour compresser tout le dossier saves
powershell -command "Compress-Archive -Path '%mc_saves%\*' -DestinationPath '%zip_file%'"

if %errorlevel% equ 0 (
    echo.
    echo [SUCCES] Sauvegarde ZIP creee sur le Bureau.
) else (
    echo.
    echo [ERREUR] Un probleme est survenu durant la compression.
)
pause
goto MENU

:BACKUP_FOLDER
cls
set "datestamp=%date:~6,4%-%date:~3,2%-%date:~0,2%"
set "current_backup=%backup_root%\Backup_%datestamp%"
echo === COPIE SIMPLE EN COURS ===
if not exist "%current_backup%" md "%current_backup%"
xcopy "%mc_saves%\*" "%current_backup%\" /E /I /Y
echo.
echo [OK] Copie terminee.
pause
goto MENU

