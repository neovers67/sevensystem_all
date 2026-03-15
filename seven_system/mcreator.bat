@echo off
title MC Mod Explorer v1.0
mode con: cols=80 lines=25
setlocal enabledelayedexpansion

:: Default Minecraft mods folder
set "mc_folder=%appdata%\.minecraft\mods"

:MENU
cls
echo ============================================================
echo MINECRAFT MOD EXPLORER (BATCH)
echo ============================================================
echo Current folder: %mc_folder%
echo.
echo 1. List all mods (.jar)
echo 2. Search for items inside a mod (requires 7-Zip)
echo 3. Change mods folder
echo 4. Exit
echo ============================================================
set /p "choice=Enter your choice: "

if "%choice%"=="1" goto LIST_MODS
if "%choice%"=="2" goto EXPLORE_MOD
if "%choice%"=="3" goto CHANGE_DIR
if "%choice%"=="4" exit
goto MENU

:LIST_MODS
cls
echo === DETECTED MODS ===
echo.
if not exist "%mc_folder%" echo [!] Folder not found. & pause & goto MENU
set "count=0"
for %%f in ("%mc_folder%\*.jar") do (
    echo [MOD] %%~nxf
    set /a count+=1
)
echo.
echo Total: !count! mods found.
pause
goto MENU

:EXPLORE_MOD
cls
echo === ITEM EXPLORER (via 7-Zip) ===
echo.
set /p "mod_name=Enter partial mod name (e.g., IronChest): "

:: Find the full mod file
set "target="
for %%f in ("%mc_folder%\*%mod_name%*.jar") do set "target=%%f"

if not defined target echo [!] Mod not found. & pause & goto MENU

echo Exploring: !target!
echo.
:: List JSON item models inside assets/*/models/item/
:: Make sure 7z.exe is in PATH or replace with full path
7z l "!target!" "assets/*/models/item/*" | findstr ".json"

if %errorlevel% NEQ 0 echo [!] No items found or 7-Zip missing.
set "target="
pause
goto MENU

:CHANGE_DIR
cls
echo === CONFIGURE MODS FOLDER ===
set /p "mc_folder=Enter full path to your mods folder: "
if not exist "!mc_folder!" (
    echo [!] Folder not found!
    timeout /t 2 >nul
    goto MENU
)
goto MENU