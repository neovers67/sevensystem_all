@echo off
setlocal enabledelayedexpansion
title Survival Mini - English Version

:difficulty_menu
cls
echo ===============================
echo      CHOOSE YOUR DIFFICULTY
echo ===============================
echo  1. Easy Mode   (Slow Hunger)
echo  2. Normal Mode (Standard)
echo  3. Hard Mode   (Fast Hunger)
echo ===============================
choice /c 123 /n /m "Select your mode (1, 2, or 3): "
set mode=%errorlevel%

:: Set hunger speed based on difficulty
if %mode%==1 set /a hunger_speed=1
if %mode%==2 set /a hunger_speed=3
if %mode%==3 set /a hunger_speed=6

:: --- INITIAL STATE ---
set /a hunger=100
set /a wood=0
set /a days=1

:game_loop
cls
:: 1. TIME PASSING
set /a hunger-=hunger_speed

:: 2. DEATH CONDITION
if !hunger! leq 0 (
    echo.
    echo GAME OVER... You starved to death on Day !days!.
    pause
    goto difficulty_menu
)

:: 3. INTERFACE
echo ===============================
echo   SURVIVAL - DAY !days!
echo ===============================
echo   HUNGER : !hunger!%%  (Speed: -!hunger_speed!)
echo   WOOD   : !wood!
echo -------------------------------
echo  [M] Eat (Costs 5 wood)
echo  [C] Chop Wood
echo  [Q] Quit
echo ===============================

:: 4. WAIT AND ACTION
choice /c mcq /n /t 1 /d c >nul
set action=%errorlevel%

if %action%==1 (
    if !wood! geq 5 (
        set /a wood-=5
        set /a hunger+=30
        if !hunger! gtr 100 set /a hunger=100
    )
)
if %action%==2 set /a wood+=1
if %action%==3 exit

set /a days+=1
goto game_loop