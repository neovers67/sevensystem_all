@echo off
title MC Mod Explorer v1.0
mode con: cols=80 lines=25
setlocal enabledelayedexpansion

:: Chemin par defaut de Minecraft
set "mc_folder=%appdata%\.minecraft\mods"

:MENU
cls
echo ============================================================
echo MINECRAFT MOD EXPLORER (BATCH)
echo ============================================================
echo Dossier actuel : %mc_folder%
echo.
echo 1. Lister tous les mods (.jar)
echo 2. Chercher les objets dans un mod (Necessite 7-Zip)
echo 3. Changer le dossier des mods
echo 4. Quitter
echo ============================================================
set /p choix="Choix : "

if "%choix%"=="1" goto LIST_MODS
if "%choix%"=="2" goto EXPLORE_MOD
if "%choix%"=="3" goto CHANGE_DIR
if "%choix%"=="4" exit
goto MENU

:LIST_MODS
cls
echo === LISTE DES MODS DETECTES ===
echo.
if not exist "%mc_folder%" echo [!] Dossier introuvable. & pause & goto MENU
set "count=0"
for %%f in ("%mc_folder%\*.jar") do (
    echo [MOD] %%~nxf
    set /a count+=1
)
echo.
echo Total : %count% mods trouves.
pause
goto MENU

:EXPLORE_MOD
cls
echo === EXPLORATEUR D'OBJETS (Via 7-Zip) ===
echo.
set /p "mod_name=Entrez le nom partiel du mod (ex: IronChest) : "

:: On cherche le fichier complet
for %%f in ("%mc_folder%\*%mod_name%*.jar") do set "target=%%f"

if not defined target echo [!] Mod non trouve. & pause & goto MENU

echo Exploration de : %target%
echo.
:: Commande 7-Zip pour lister les fichiers dans assets/*/models/item
:: Si tu n'as pas 7-Zip dans ton PATH, remplace "7z" par le chemin complet
7z l "%target%" "assets/*/models/item/*" | findstr ".json"

if %errorlevel% NEQ 0 echo [!] Aucun objet trouve ou 7-Zip absent.
set "target="
pause
goto MENU

:CHANGE_DIR
cls
echo === CONFIGURATION DU DOSSIER ===
set /p "mc_folder=Collez le chemin complet de votre dossier mods : "
goto MENU