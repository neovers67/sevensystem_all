@echo off
title Snake en Batch - Version simple
setlocal enabledelayedexpansion

:: Paramètres initiaux
set "x=10"
set "y=5"
set "dir=RIGHT"
set "fruitX=15"
set "fruitY=8"
set "score=0"

:gameLoop
cls
echo Score: %score%
for /l %%i in (1,1,20) do (
    for /l %%j in (1,1,40) do (
        if %%i==%y% if %%j==%x% (
            set /p="O"<nul
        ) else if %%i==%fruitY% if %%j==%fruitX% (
            set /p="*"<nul
        ) else (
            set /p=" "<nul
        )
    )
    echo.
)

:: Déplacement
choice /c WASD /n /t 1 /d %dir:~0,1% >nul
if errorlevel 4 set dir=RIGHT
if errorlevel 3 set dir=LEFT
if errorlevel 2 set dir=DOWN
if errorlevel 1 set dir=UP

if "%dir%"=="UP" set /a y-=1
if "%dir%"=="DOWN" set /a y+=1
if "%dir%"=="LEFT" set /a x-=1
if "%dir%"=="RIGHT" set /a x+=1

:: Collision avec fruit
if %x%==%fruitX% if %y%==%fruitY% (
    set /a score+=1
    set /a fruitX=(%random% %% 38)+2
    set /a fruitY=(%random% %% 18)+2
)

:: Collision avec murs
if %x% lss 1 goto gameOver
if %x% gtr 40 goto gameOver
if %y% lss 1 goto gameOver
if %y% gtr 20 goto gameOver

goto gameLoop

:gameOver
cls
echo Game Over!
echo Score final: %score%
pause
exit
@echo off
title Snake en Batch - Version simple
setlocal enabledelayedexpansion

:: Paramètres initiaux
set "x=10"
set "y=5"
set "dir=RIGHT"
set "fruitX=15"
set "fruitY=8"
set "score=0"

:gameLoop
cls
echo Score: %score%
for /l %%i in (1,1,20) do (
    for /l %%j in (1,1,40) do (
        if %%i==%y% if %%j==%x% (
            set /p="O"<nul
        ) else if %%i==%fruitY% if %%j==%fruitX% (
            set /p="*"<nul
        ) else (
            set /p=" "<nul
        )
    )
    echo.
)

:: Déplacement
choice /c WASD /n /t 1 /d %dir:~0,1% >nul
if errorlevel 4 set dir=RIGHT
if errorlevel 3 set dir=LEFT
if errorlevel 2 set dir=DOWN
if errorlevel 1 set dir=UP

if "%dir%"=="UP" set /a y-=1
if "%dir%"=="DOWN" set /a y+=1
if "%dir%"=="LEFT" set /a x-=1
if "%dir%"=="RIGHT" set /a x+=1

:: Collision avec fruit
if %x%==%fruitX% if %y%==%fruitY% (
    set /a score+=1
    set /a fruitX=(%random% %% 38)+2
    set /a fruitY=(%random% %% 18)+2
)

:: Collision avec murs
if %x% lss 1 goto gameOver
if %x% gtr 40 goto gameOver
if %y% lss 1 goto gameOver
if %y% gtr 20 goto gameOver

goto gameLoop

:gameOver
cls
echo Game Over!
echo Score final: %score%
pause
exit

