@echo on
pause
setlocal enabledelayedexpansion	
title Survival game

:: --- INITIALIZATION ---
set "savefile=savegame.dat"
set /a hunger=100, hp=100, exp=0, level=0, progression=0, lvl_gain, wood=0, rock=0, iron_ore=0, iron_ingot=0, diamond=0, platine=0, food=0, days=1, action_count=0, gold_ore=0
set /a hunger_speed=4, has_campfire=0, has_smelter=0, has_forge=0, gold=0
set /a potion_of_heal=0, potion_of_strength=0, potion_of_drop=0
set /a axe_lvl=0, pick_lvl=0, sword_lvl=0
set /a axe_dur=0, pick_dur=0, sword_dur=0
set /a axe_max=110, pick_max=110, sword_max=110
set /a plastron_lvl=0, plastron_dur=110, plastron_max=110
:: Tower Variable
set /a tower_lvl=1, twr_hp=100, twr_enmy_hp=10, twrenmyhp2=10, twr_dmg=3, twr_enmy_dmg=1, twr_finish=0
:: Workers
set /a w_wood=0, w_stone=0, w_iron=0, w_diam=0, w_plat=0
:: Potions
set /a potion_str_active=0, potion_drop_active=0
set /a end_time_str=0, end_time_drop=0
:: Reputation
set /a bob_reputation=5

:: --- TIME TRACKING FIX ---
for /f "tokens=1-3 delims=: " %%a in ("%time%") do (
    set "hour=%%a"
    set "min=%%b"
    set "sec=%%c"
)
:: On retire le 0 initial pour éviter l'erreur octale
if "%hour:~0,1%"==" " set "hour=%hour:~1%"
if "%hour:~0,1%"=="0" set "hour=%hour:~1%"
if "%min:~0,1%"=="0" set "min=%min:~1%"
if "%sec:~0,1%"=="0" set "sec=%sec:~1%"

set /a current_time_sec=hour*3600 + min*60 + sec
set /a last_time_sec=%current_time_sec%
set /a last_save_time=%current_time_sec%

:difficulty_menu
cls
echo ===============================
echo SURVIVAL GAME
echo ===============================
echo 1. Easy Mode
echo 2. Normal Mode
echo 3. Hard Mode
echo 4. LOAD SAVE [L]
echo ===============================
choice /c 123l /n /m "Select your mode: "
if %errorlevel%==4 goto load_game
set /a mode=%errorlevel%
if %mode%==1 set /a hunger_speed=2
if %mode%==2 set /a hunger_speed=4
if %mode%==3 set /a hunger_speed=6

:game_loop
cls
:: Calcul du temps actuel en secondes pour les buffs
for /f "tokens=1-4 delims=:," %%a in ("%time%") do (
    set /a current_sec=%%a*3600 + 1%%b%%100*60 + 1%%c%%100
)

:: Vérification expiration Strength Potion
if !potion_str_active!==1 (
    if !current_sec! gtr !end_time_str! (
        set /a potion_str_active=0
        echo Your Strength Potion has expired!
        timeout /t 2 >nul
    )
)

:: Vérification expiration Drop Potion
if !potion_drop_active!==1 (
    if !current_sec! gtr !end_time_drop! (
        set /a potion_drop_active=0
        echo Your Drop Potion has expired!
        timeout /t 2 >nul
    )
)

:: --- REAL TIME WORKER LOGIC ---
for /f "tokens=1-4 delims=:," %%a in ("%time%") do (
    set /a h=%%a, m=1%%b %% 100, s=1%%c %% 100
    set /a current_time_sec=h*3600 + m*60 + s
)

:: Gestion du passage de minuit
if !current_time_sec! lss !last_time_sec! set /a current_time_sec+=86400
set /a elapsed=!current_time_sec! - !last_time_sec!

if !elapsed! gtr 0 (
    :: Calcul des gains
    if !w_wood! gtr 0 (set /a gain=!elapsed! / 5 * !w_wood!, wood+=gain)
    if !w_stone! gtr 0 (set /a gain=!elapsed! / 10 * !w_stone!, rock+=gain)
    if !w_iron! gtr 0 (set /a gain=!elapsed! / 600 * !w_iron!, iron_ore+=gain)
    if !w_diam! gtr 0 (set /a gain=!elapsed! / 1200 * !w_diam!, diamond+=gain)
    if !w_plat! gtr 0 (set /a gain=!elapsed! / 3600 * !w_plat!, platine+=gain)
    set /a last_time_sec=!current_time_sec!
)

:: --- AUTO-SAVE SYSTEM (Every 10 seconds) ---
set /a time_since_save=%current_time_sec% - %last_save_time%
if !time_since_save! lss 0 set /a time_since_save+=86400

if !time_since_save! geq 10 (
    set /a last_save_time=%current_time_sec%
    :: On appelle le label de sauvegarde sans le "pause"
    goto silent_save
)
:after_silent_save

:: --- ACTION COUNT & DAY SYSTEM ---
if !action_count! geq 3 (
    set /a days+=1, action_count=0
    echo Un nouveau jour se leve...
    timeout /t 2 >nul
)

:: --- DAY AND HUNGER LOGIC ---
set /a current_hunger_drain=!hunger_speed!
if !has_campfire!==1 (
    set /a current_hunger_drain-=1
    if !hp! lss 100 set /a hp+=2
    if !hp! gtr 100 set /a hp=100
)

if !hunger! gtr 0 (
    set /a hunger-=current_hunger_drain
) else (
    set /a hp-=10
    echo WARNING: You are starving! (-10 HP)
    timeout /t 2 >nul
)

:: --- DEATH CONDITION ---
if !hp! leq 0 (
    echo.
    echo GAME OVER... You died on Day !days!.
    pause
    goto difficulty_menu
)

:: --- LEVEL AND PROGRESSION LOGIC ---
if !exp! geq 100 (set /a exp-=100, level+=1, lvl_gain+=1)
if !exp! geq 20 set /a progression=#~~~~
if !exp! geq 40 set /a progression=##~~~
if !exp! geq 60 set /a progression=###~~
if !exp! geq 80 set /a progression=####~
if !exp! geq 100 set /a progression=~~~~~
if !level! geq 100 (set /a level=100, progression=LEVEL MAX)
if !lvl_gain!==10 (set /a gold+=100, lvl_gain=0)

:: --- INTERFACE ---
set "axe_name=None" & if !axe_lvl!==1 set "axe_name=Wood" & if !axe_lvl!==2 set "axe_name=Stone" & if !axe_lvl!==3 set "axe_name=Iron" & if !axe_lvl!==4 set "axe_name=Diamond" & if !axe_lvl!==5 set "axe_name=Platine"
set "pick_name=None" & if !pick_lvl!==1 set "pick_name=Wood" & if !pick_lvl!==2 set "pick_name=Stone" & if !pick_lvl!==3 set "pick_name=Iron" & if !pick_lvl!==4 set "pick_name=Diamond" & if !pick_lvl!==5 set "pick_name=Platine"
set "sword_name=None" & if !sword_lvl!==1 set "sword_name=Wood" & if !sword_lvl!==2 set "sword_name=Stone" & if !sword_lvl!==3 set "sword_name=Iron" & if !sword_lvl!==4 set "sword_name=Diamond" & if !sword_lvl!==5 set "sword_name=Platine"
set "plastron_name=None" & if !plastron_lvl!==1 set "plastron_name=Wood" & if !plastron_lvl!==2 set "plastron_name=Iron" & if !plastron_lvl!==3 set "plastron_name=Diamond" & if !plastron_lvl!==4 set "plastron_name=Platine"

echo ========================================================
echo SURVIVAL - DAY !days! [Actions: !action_count!/3]
echo ========================================================
LEVEL : !level! Progression : !progression!
echo --------------------------------------------------------
echo HEALTH : !hp!%% | HUNGER : !hunger!%% | CAMPFIRE: !has_campfire!
echo WOOD : !wood! | STONE : !rock! | PLATINE : !platine! | DIAMOND: !diamond!
echo IRON ORE : !iron_ore! | IRON INGOT : !iron_ingot! | GOLD : !gold!
echo FOOD : !food! | SMELTER : !has_smelter!/1 |
echo --------------------------------------------------------
echo WORKERS: W:!w_wood! S:!w_stone! I:!w_iron! D:!w_diam! P:!w_plat!
echo ----------------------------------------------
echo AXE : !axe_name! (!axe_dur!/!axe_max!)
echo PICK : !pick_name! (!pick_dur!/!pick_max!)
echo SWORD: !sword_name! (!sword_dur!/!sword_max!)
echo --------------------------------------------------------
echo [M] Eat (-3 Food) [C] Chop Wood  
echo [D] Mine Stone/Ore [F] Hunt/Forage  
echo [P] Drink Potion [S] Village (Shop)
echo [V] SAVE GAME [Q] Quit
echo========================================================

choice /c mcdfsvqp /n /m "Action: "
set "action=%errorlevel%"

:: [M] EAT
if "!action!"=="1" (
    if !food! geq 3 (
        set /a food-=3, hunger+=25, hp+=5, action_count+=1
        if !hunger! gtr 100 set /a hunger=100
        if !hp! gtr 100 set /a hp=100
    ) else (echo Not enough food! & timeout /t 1 >nul)
    goto game_loop
)

:: [C] CHOP WOOD
if "!action!"=="2" (
    echo Chopping...
    timeout /t 1 >nul
    set /a gain=1
    if !axe_lvl!==1 set /a gain=2
    if !axe_lvl!==2 set /a gain=4
    if !axe_lvl!==3 set /a gain=8
    if !axe_lvl!==4 set /a gain=15
    if !axe_lvl!==5 set /a gain=30
    
    set /a final_gain=!gain!
    if !potion_drop_active! equ 1 set /a final_gain=!gain! + (!gain! / 2)
    set /a wood+=!final_gain!, exp+=4, action_count+=1
    
    if !axe_lvl! gtr 0 (
        set /a axe_dur-=10
        if !axe_dur! leq 0 (set /a axe_lvl=0, axe_dur=0 & echo Your axe broke!)
    )
    goto game_loop
)

:: [D] MINE
if "!action!"=="3" (
    echo Mining...
    timeout /t 1 >nul
    set /a gain=1
    set /a exp+=5
    if !pick_lvl!==1 set /a gain=2
    if !pick_lvl!==2 set /a gain=4
    if !pick_lvl!==3 set /a gain=8
    if !pick_lvl!==4 set /a gain=15
    if !pick_lvl!==5 set /a gain=30
    
    action_count+=1
    
    set /a final_gain=!gain!
    if !potion_drop_active!==1 set /a final_gain=!gain! + (!gain! / 2)
    set /a rock+=!final_gain!

    set /a iron_roll=!random! %% 10
    if !iron_roll! == 0 (set /a iron_ore+=1 & set /a exp+=25 & echo Found 1 Iron Ore!)
    
    set /a diamond_roll=!random! %% 100
    if !diamond_roll! == 0 (set /a diamond+=1 & set /a exp+=150 & echo Found 1 Diamond!)

    set /a platine_roll=!random! %% 1000
    if !platine_roll! == 0 (set /a platine+=1 & set /a exp+=800 & echo Found 1 Platine!)

    if !pick_lvl! gtr 0 (
        set /a pick_dur-=5
        if !pick_dur! leq 0 (set /a pick_lvl=0, pick_dur=0 & echo Your pickaxe broke!)
    )
    goto game_loop
)

:: [F] HUNT / FORAGE
if "!action!"=="4" (
    echo Hunting/Searching...
    timeout /t 1 >nul
    set /a food_gain=2
    if !sword_lvl!==1 set /a food_gain=4
    if !sword_lvl!==2 set /a food_gain=8
    if !sword_lvl!==3 set /a food_gain=15
    if !sword_lvl!==4 set /a food_gain=25
    if !sword_lvl!==5 set /a food_gain=50
    
    set /a chance=!random! %% 100
    if !chance! lss 70 (
        set /a food+=!food_gain!, action_count+=1, gold+=10, exp+=4
        echo Success! You found !food_gain! food and !gold! gold.
        if !sword_lvl! gtr 0 (
            set /a sword_dur-=10
            if !sword_dur! leq 0 (set /a sword_lvl=0, sword_dur=0 & echo Your sword broke!)
        )
    ) else (
        echo You found nothing... & set /a action_count+=1
    )
    timeout /t 1 >nul
    goto game_loop
)

:: [S] VILLAGE / [V] SAVE / [Q] QUIT
if "!action!"=="5" goto village
if "!action!"=="6" goto save_game
if "!action!"=="8  exit
goto game_loop

:: [D] DRINK POTION
if %action%==8 goto potion

:village
cls
echo ===== VILLAGE =====
echo 1. Crafting
echo 2. Smelter
echo 3. Potions Shop
echo 4. Jobs
echo 5. Trading Place
echo 6. Tower
echo 7. Forge
echo 8. Hotel
echo 9. Back
echo ===================
choice /c 123456789 /n
if %errorlevel%==1 goto shop
if %errorlevel%==2 goto smelter
if %errorlevel%==3 goto potions_shop
if %errorlevel%==4 goto jobs
if %errorlevel%==5 goto Trading_place
if %errorlevel%==6 goto tower
if %errorlevel%==7 goto forge
if %errorlevel%==8 goto hotel
if %errorlevel%==9 goto game_loop

:shop
cls
echo ===== CRAFTING =====
echo Wood:!wood! | Stone:!rock! | Iron:!iron_ingot! | Diamond:!diamond! | Platine:!platine!
echo --------------------------------------------------------
echo [1] Wood Axe (10 Wood) [4] Stone Axe (20 Stone) [7] Iron Axe (15 Iron)
echo [2] Wood Pick (10 Wood) [5] Stone Pick (20 Stone) [8] Iron Pick (15 Iron)
echo [3] Wood Sword (10 Wood) [6] Stone Sword (20 Stone) [9] Iron Sword (15 Iron)
echo [A] Diam Axe (10 Diams) [B] Diam Pick (10 Diams) [C] Diam Sword (10 Diams)
echo [F] Plat Axe (5 Plat) [G] Plat Pick (5 Plat) [H] Plat Sword (5 Plat) echo [J] Wood Plastron (10 Wood) [K] Iron Plastron (10 Iron)
echo [L] Diam Plastron (8 Diams) [M] Platine Plastron (5 Plat)
echo -------------------------------
[J] Wood Plastron (10 Wood) [K] Iron Plastron (10 Iron) [L] Diamond Plastron (8 Diams) [M] Platine Plastron (5 Plat)
-------------------------------
echo [D] Smelter (150 Stone, 100 Wood) [I] Campfire (20 Wood, 10 Stone) [N] Forge (30 Iron Ingot)
echo [E] Back
echo --------------------------------------------------------
choice /c 123456789abcdefghijklmn /n
set shop_choice=%errorlevel%

if %shop_choice%==14 goto village

:: Logic for Crafting 
if %shop_choice%==1 if !wood! geq 10 (set /a wood-=10, axe_lvl=1, axe_dur=110, axe_max=110 & echo Done!)
if %shop_choice%==2 if !wood! geq 10 (set /a wood-=10, pick_lvl=1, pick_dur=110, pick_max=110 & echo Done!)
if %shop_choice%==3 if !wood! geq 10 (set /a wood-=10, sword_lvl=1, sword_dur=110, sword_max=110 & echo Done!)
if %shop_choice%==4 if !rock! geq 20 (set /a rock-=20, axe_lvl=2, axe_dur=160, axe_max=160 & echo Done!)
if %shop_choice%==5 if !rock! geq 20 (set /a rock-=20, pick_lvl=2, pick_dur=160, pick_max=160 & echo Done!)
if %shop_choice%==6 if !rock! geq 20 (set /a rock-=20, sword_lvl=2, sword_dur=160, sword_max=160 & echo Done!)
if %shop_choice%==7 if !iron_ingot! geq 15 (set /a iron_ingot-=15, axe_lvl=3, axe_dur=250, axe_max=250 & echo Done!)
if %shop_choice%==8 if !iron_ingot! geq 15 (set /a iron_ingot-=15, pick_lvl=3, pick_dur=250, pick_max=250 & echo Done!)
if %shop_choice%==9 if !iron_ingot! geq 15 (set /a iron_ingot-=15, sword_lvl=3, sword_dur=250, sword_max=250 & echo Done!)
if %shop_choice%==10 if !diamond! geq 10 (set /a diamond-=10, axe_lvl=4, axe_dur=500, axe_max=500 & echo Done!)
if %shop_choice%==11 if !diamond! geq 10 (set /a diamond-=10, pick_lvl=4, pick_dur=500, pick_max=500 & echo Done!)
if %shop_choice%==12 if !diamond! geq 10 (set /a diamond-=10, sword_lvl=4, sword_dur=500, sword_max=500 & echo Done!)
if %shop_choice%==13 if !rock! geq 150 if !wood! geq 100 (set /a rock-=150, wood-=100, has_smelter=1 & echo Smelter build!)
if %shop_choice%==15 if !platine! geq 5 (set /a platine-=5, axe_lvl=5, axe_dur=2000, axe_max=2000 & echo Done!)
if %shop_choice%==16 if !platine! geq 5 (set /a platine-=5, pick_lvl=5, pick_dur=2000, pick_max=2000 & echo Done!)
if %shop_choice%==17 if !platine! geq 5 (set /a platine-=5, sword_lvl=5, sword_dur=2000, sword_max=2000 & echo Done!)
if %shop_choice%==18 if !wood! geq 20 if !rock! geq 10 (set /a wood-=20, rock-=10, has_campfire=1 & echo Campfire built!)
if %shop_choice%==19 if !wood! geq 10 (set /a wood-=10, plastron_lvl=1, plastron_dur=110 & echo Done!)
if %shop_choice%==20 if !iron_ingot! geq 10 (set /a iron_ingot-=10, plastron_lvl=2, plastron_dur=250 & echo Done!)
if %shop_choice%==21 if !diamond! geq 8 (set /a diamond-=8, plastron_lvl=3, plastron_dur=500 & echo Done!)
if %shop_choice%==22 if !platine! geq 5 (set /a platine-=5, plastron_lvl=4, plastron_dur=2000 & echo Done!)
if %shop_choice%==23 if !iron_ingot! geq 30 (set /a iron_ingot-=30, has_forge=1 & echo Forge built!)

timeout /t 1 >nul
goto shop

:smelter
cls
echo ===== SMELTER =====
if !has_smelter!==0 (echo Build a Smelter first! & pause & goto village)
echo Ore: !iron_ore! | Ingots: !iron_ingot! | Wood: !wood!
echo [1] Smelt Iron (1 Ore + 5 Wood)
echo [2] Smelt Gold (1 Ore + 5 Wood)
echo [3] Back
choice /c 123 /n
if %errorlevel%==3 goto village
if %errorlevel%==1 (
    if !iron_ore! geq 1 if !wood! geq 5 (
        set /a iron_ore-=1, wood-=5, iron_ingot+=1
    echo Smelting... & timeout /t 1 >nul
) else (echo Missing resources!)
goto smelter
)
if %errorlevel%==2 (
    if !gold_ore! geq 1 if !wood! geq 5 (
        set /a gold_ore-=1, wood-=5, gold+=1
    echo Smelting... & timeout /t 1 >nul
) else (echo Missing resources!)
goto smelter
)

:potions_shop
cls
echo ===== Potions Shop =====
echo Gold: !gold!
echo 1. Healing Potion (20 gold) (Only for Tower)
echo 2. Strength Potion (20 gold) (Only for Tower)
echo 3. Drop Potion (50 gold)
echo 4. Back
choice /c 1234 /n 
if %errorlevel%==4 goto village
if %errorlevel%==1 if !gold! geq 20 (set /a gold-=20, potion_of_heal+=1 & echo Bought!)
if %errorlevel%==2 if !gold! geq 20 (set /a gold-=20, potion_of_strength+=1 & echo Bought!)
if %errorlevel%==3 if !gold! geq 50 (set /a gold-=50, potion_of_drop+=1 & echo Bought!)
timeout /t 1 >nul
goto potions_shop

:jobs
cls
echo ===== RECRUITMENT =====
echo 1. Woodcutter (50 Gold) [+1 Wood/5s] : !w_wood!
echo 2. Miner (100 Gold) [+1 Stone/10s] : !w_stone!
echo 3. Iron Miner (500 Gold) [+1 Iron/10m] : !w_iron!
echo 4. Diam Miner (2000 Gold)[+1 Diam/20m] : !w_diam!
echo 5. Plat Miner (5000 Gold)[+1 Plat/1h] : !w_plat!
echo 6. Back
choice /c 123456 /n
if %errorlevel%==1 if !gold! geq 50 (set /a gold-=50, w_wood+=1)
if %errorlevel%==2 if !gold! geq 100 (set /a gold-=100, w_stone+=1)
if %errorlevel%==3 if !gold! geq 500 (set /a gold-=500, w_iron+=1)
if %errorlevel%==4 if !gold! geq 2000 (set /a gold-=2000, w_diam+=1)
if %errorlevel%==5 if !gold! geq 5000 (set /a gold-=5000, w_plat+=1)
if %errorlevel%==6 goto village
goto jobs

:Trading_place
cls
echo ===== Trading Place =====
echo ----- MATERIALS -----
echo 1. 10 Wood -> 5 Rock
echo 2. 10 Rock -> 1 Iron Ore
echo 3. 20 Iron Ingot -> 1 Diamond
echo 4. 10 Diamond -> 1 Platine
echo ----- GOLD -----
echo 5. 10 Wood -> 5 Gold
echo 6. 10 Rock -> 10 Gold
echo 7. 5 Iron Ingot -> 30 Gold
echo 8. 1 Diamond -> 100 Gold
echo 9. 1 Platine -> 1000 Gold
echo a. Back
choice /c 123456789a /n
if %errorlevel%==10 goto village
if %errorlevel%==1 if !wood! geq 10 (set /a wood-=10, rock+=5 & echo Done!)
if %errorlevel%==2 if !rock! geq 10 (set /a rock-=10, iron_ore+=1 & echo Done!)
if %errorlevel%==3 if !iron_ingot! geq 20 (set /a iron_ingot-=20, diamond+=1 & echo Done!)
if %errorlevel%==4 if !diamond! geq 10 (set /a diamond-=10, platine+=1 & echo Done!)
if %errorlevel%==5 if !wood! geq 10 (set /a wood-=10, gold+=5 & echo Done!)
if %errorlevel%==6 if !rock! geq 10 (set /a rock-=10, gold+=10 & echo Done!)
if %errorlevel%==7 if !iron_ingot! geq 5 (set /a iron_ingot-=5, gold+=30 & echo Done!)
if %errorlevel%==8 if !diamond! geq 1 (set /a diamond-=1, gold+=100 & echo Done!)
if %errorlevel%==9 if !platine! geq 1 (set /a platine-=1, gold+=1000 & echo Done!)
timeout /t 1 >nul
goto Trading_place

:tower
if !twr_finish!==0 (
    echo You already finished the tower!
    pause
    goto village
)

if !twr_enmy_hp! leq 0 (
    echo.
    echo Victoire ! Niveau !tower_lvl! termine.
    set /a tower_lvl+=1, gold+=10, twr_enmy_dmg+=2
    set /a twr_enmy_hp=10 + (!tower_lvl! * 5)
    if !twr_hp! gtr 100 set /a twr_hp=100
)

:: Calcul des dégâts de base selon l'épée
set /a base_dmg=3
if !sword_lvl!==1 set /a base_dmg=7
if !sword_lvl!==2 set /a base_dmg=10
if !sword_lvl!==3 set /a base_dmg=15
if !sword_lvl!==4 set /a base_dmg=25
if !sword_lvl!==5 set /a base_dmg=40

:: Calcul de la défense de base selon l’armure
set /a base_defense=0
if !plastron_lvl!==1 set /a base_defense=4
if !plastron_lvl!==2 set /a base_defense=10
if !plastron_lvl!==3 set /a base_defense=16
if !plastron_lvl!==4 set /a base_defense=25
set /a enemy_hit=!twr_enmy_dmg! - !base_defense!
if !enemy_hit! lss 0 set /a enemy_hit=0
if !twr_enmy_dmg! lss 0 set /a twr_enmy_dmg=0

:: Bonus Potion de Force (+50%)
set /a twr_dmg=!base_dmg!
if !potion_str_active!==1 set /a twr_dmg=!base_dmg! + (!base_dmg! / 2)

:: Deppassement de la limite de vie
if !twr_hp! gtr 100 set /a twr_hp=100

echo ========== TOWER ==========
echo Tower Level : !tower_lvl!
echo ===========================
if !tower_lvl!==100 echo BOSS 
if !tower_lvl!==100 echo ===========================
echo.
echo Your Life : !twr_hp!
echo Enemy Life : !twr_enmy_hp!
echo.
echo 1.Attack
echo 2.Strength Potion (!potion_of_strength!)
echo 3.Heal (Heal Potion: !potion_of_heal!)
echo 4.Exit

choice /c 1234 /n

if %errorlevel%==1 (
    if !twr_enmy_hp! gtr 0 (
      set /a twr_enmy_hp-=!twr_dmg!
      echo You attack!
      set /a twr_hp-=!enemy_hit!
      echo Enemy strike back!
      timeout /t 2 
      goto tower 
    )
)

if %errorlevel%==2 (
    if !potion_of_strength! gtr 0 (
        set /a potion_of_strength-=1, potion_str_active=1
        set /a end_time_str=!current_sec! + 60
        echo Strength Potion activated for 60s!
    ) else (echo No potions!)
    timeout /t 1 >nul & goto tower
)

if %errorlevel%==3 (
    if !potion_of_heal! gtr 0 (
      set /a potion_of_heal-=1, twr_hp+=30
    )else (
       echo You don’t have a heal potion
       goto tower
    )
)

if %errorlevel%==4 goto Village

:: TOWER END
if !tower_lvl!=100 goto final_boss

:final_boss
echo No final boss for the moment!
timeout /t 2>nul
goto twr_end

:twr_end
cls
echo You Kill the last enemy
timeout /t 1>nul
cls 
echo You Kill the last enemy.
timeout /t 1>nul
cls 
echo You Kill the last enemy..
timeout /t 1>nul
cls 
echo You Kill the last enemy...
timeout /t 2>nul
cls
echo You won! GG
echo You received 10 diamond, 5 platine and a lot more.
set /a diamond+=10, platine+=5, wood+=100, rock+=100, twr_finish=1
pause
goto village

:potion
cls
echo ===== POTIONS =====
echo 1.Drop Potion (!potion_of_drop!)

choice /c 1 /n
if %errorlevel%==1 (
    if !potion_of_drop! gtr 0 (
        set /a potion_of_drop-=1
        set /a potion_drop_active=1
        set /a end_time_drop=!current_sec! + 60
        echo Drop Potion activated for 60s!
        timeout /t 2 >nul
    ) else (
        echo No Drop Potion!
        timeout /t 2 >nul
    )
)
goto game_loop

:forge
cls
echo ===== FORGE =====
if !has_forge!==0 (echo Build a Forge first! & pause & goto village)
echo Wood: !wood! | Rock: !rock! | Iron Ingots: !iron_ingot! | Diamond: !diamond! | Platine: !platine!
echo [1] Repare Axe (1 Meterials + 1 Axe)
echo [2] Repare Pick (1 Materials + 1 Pick)
echo [3] Repare Sword (1 Materials + 1 Sword)
echo [4] Repare Plastron ( 1 Materials + 1 Plastron)
echo [5] Back
choice /c 12345 /n
if %errorlevel%==5 goto village

if !axe_lvl! equ 1 if !wood! geq 1 (
    set /a wood-=1, axe_dur+=25
)
    if !axe_lvl!==2 (
      set /a rock-=1, axe_dur+=35 & echo Done!)
    if !axe_lvl!==3 (
      set /a iron_ingot-=1, axe_dur+=100 & echo Done!)
    if !axe_lvl!==4 (
      set /a diamond-=1, axe_dur+=250 & echo Done!)
    if !axe_lvl!==5 (
      set /a platine-=1, axe_dur+=750 & echo Repared!)
)

if %errorlevel%==2 (
    if !pick_lvl!==1 (
      set /a wood-=1, pick_dur+=25 & echo Repared!)
    if !pick_lvl!==2 (
      set /a rock-=1, pick_dur+=35 & echo Repared!)
    if !pick_lvl!==3 (
      set /a iron_ingot-=1, pick_dur+=100 & echo Repared!)
    if !pick_lvl!==4 (
      set /a diamond-=1, pick_dur+=250 & echo Repared!)
    if !pick_lvl!==5 (
      set /a platine-=1, pick_dur+=750 & echo Repared!)
)

if %errorlevel%==3 (
    if !sword_lvl!==1 (
      set /a wood-=1, sword_dur+=25 & echo Repared!)
    if !sword_lvl!==2 (
      set /a rock-=1, sword_dur+=35 & echo Repared!)
    if !sword_lvl!==3 (
      set /a iron_ingot-=1, sword_dur+=100 & echo Repared!)
    if !sword_lvl!==4 (
      set /a diamond-=1, sword_dur+=250 & echo Repared!)
    if !sword_lvl!==5 (
      set /a platine-=1, sword_dur+=750 & echo Repared!)
)
if %errorlevel%==4 (
    if !plastron_lvl!==1 if !wood! geq 1 (set /a wood-=1, plastron_dur+=25 & echo Repaired!)
    if !plastron_lvl!==2 if !iron_ingot! geq 1 (set /a iron_ingot-=1, plastron_dur+=100 & echo Repaired!)
    if !plastron_lvl!==3 if !diamond! geq 1 (set /a diamond-=1, plastron_dur+=250 & echo Repaired!)
    if !plastron_lvl!==4 if !platine! geq 1 (set /a platine-=1, plastron_dur+=750 & echo Repaired!)
)

:hotel

set /a someone=!random! %% 2

echo ===== HOTEL =====
echo.
echo [1] Book a room (Spend 3 night, 10 gold)
echo [2] Go to the living room
echo [3] Exit hotel
choice /c 123 /n
if %errorlevel%==1 (
    echo You sleep...
    timeout /t 1>nul
    set /a days+=3 & goto hotel
)
if %errorlevel%==2 (
    if !someone! gtr 0 (
        echo Il y a Bob ici. Voulez-vous lui parler ?
        echo [1] Yes [2] No
        choice /c 12 /n
        if !errorlevel!==1 (
            echo Bob : "Aide les citoyens pour des recompense."
            pause
        )
    ) else (
        echo Le salon est vide...
        pause
    )
    goto hotel
)

:living_room
if !someone! gtr 0 (
      echo Il y a Bob ici. Voulez-vous lui parler ?
      echo [1] Yes [2] No
      choice /c 12 /n
      if %errorlevel%==1 (
          echo Bob : "Aide les citoyens pour des recompense."
          pause
      )
  ) else (
      echo Le salon est vide...
      pause
  )
    goto hotel
)

:silent_save
(
echo SET hunger=!hunger!
echo SET wood=!wood!
echo SET rock=!rock!
echo SET iron_ore=!iron_ore!
echo SET iron_ingot=!iron_ingot!
echo SET diamond=!diamond!
echo SET platine=!platine!
echo SET food=!food!
echo SET days=!days!
echo SET hunger_speed=!hunger_speed!
echo SET has_campfire=!has_campfire!
echo SET has_smelter=!has_smelter!
echo SET hp=!hp!
echo SET axe_lvl=!axe_lvl!
echo SET axe_dur=!axe_dur!
echo SET pick_lvl=!pick_lvl!
echo SET pick_dur=!pick_dur!
echo SET sword_lvl=!sword_lvl!
echo SET sword_dur=!sword_dur!
echo SET gold=!gold!
echo SET tower_lvl=!tower_lvl!
echo SET twr_finish=!twr_finish!
echo SET plastron_lvl=!plastron_lvl!
echo SET plastron_dur=!plastron_dur!
echo SET has_forge=!has_forge!
echo SET w_wood=!w_wood!
echo SET w_stone=!w_stone!
echo SET w_iron=!w_iron!
echo SET w_diam=!w_diam!
echo SET w_plat=!w_plat!
) > %savefile%
goto after_silent_save

        
:save_game
(
echo SET hunger=!hunger!
echo SET wood=!wood!
echo SET rock=!rock!
echo SET iron_ore=!iron_ore!
echo SET iron_ingot=!iron_ingot!
echo SET diamond=!diamond!
echo SET platine=!platine!
echo SET food=!food!
echo SET days=!days!
echo SET hunger_speed=!hunger_speed!
echo SET has_campfire=!has_campfire!
echo SET has_smelter=!has_smelter!
echo SET hp=!hp!
echo SET axe_lvl=!axe_lvl!
echo SET axe_dur=!axe_dur!
echo SET pick_lvl=!pick_lvl!
echo SET pick_dur=!pick_dur!
echo SET sword_lvl=!sword_lvl!
echo SET sword_dur=!sword_dur!
echo SET gold=!gold!
echo SET tower_lvl=!tower_lvl!
echo SET twr_finish=!twr_finish!
echo SET plastron_lvl=!plastron_lvl!
echo SET plastron_dur=!plastron_dur!
echo SET has_forge=!has_forge!
echo SET w_wood=!w_wood!
echo SET w_stone=!w_stone!
echo SET w_iron=!w_iron!
echo SET w_diam=!w_diam!
echo SET w_plat=!w_plat!
) > "%savefile%"
echo.
echo [Save Load!]
timeout /t 2 >nul
goto game_loop


:load_game
if not exist "%savefile%" (
    echo No Save Found !
    pause
    goto difficulty_menu
)

for /f "delims=" %%a in (%savefile%) do %%a

echo.
echo [Load Save!]
timeout /t 2 >nul
goto game_loop
pause