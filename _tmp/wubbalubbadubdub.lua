name = "Level Up our team where you want using PathFinder"
author = "Gladys"
description = [[ Leveling your pokemon where you want with this script, please modify the option before starting the script.
If you want to change the default selection, go to the config section on the script.
Thanks to Silv3r for Proshine, Zonz for the option and Blissey for the PathFinder !]]


---------------------- #### CONFIG #### ----------------------
tab = { "Auto-buy", "Stop exp", "Catch Uncaught", "PathFinder", "Pokemon Catch" }
local PathFinder = require "Pathfinder/MoveToApp"
local map = nil


for i = 1, 5 do
    setOptionName(i, tab[i] .. " is ")
    setTextOptionName(1, "Type of Pokeball to buy")
    setOption(1, true) -------- Set button to On by default, replace true by false to set default button to Off
    setTextOption(1, "Pokeball") -------- Set the name of th ball to buy by default
    setTextOptionName(2, "Stop exp when all team reach the lvl ")
    setOption(2, true) -------- Set button to On by default, replace true by false to set default button to Off
    setTextOption(2, "") -------- Set the default level to exp
    setOption(3, true) -------- Set button to On by default, replace true by false to set default button to Off
    setTextOptionName(4, "Type the exact name where you want to farm ")
    setOption(4, true) -------- Set button to On by default, replace true by false to set default button to Off
    setTextOption(4, "Victory Road Kanto 2F_A") -------- Set the default map to farm
    setOption(5, true) -------- Set button to On by default, replace true by false to set default button to Off
    setTextOptionName(5, "Type the name of the pokemon you want to catch")
    setTextOption(5, "") -------- Set the default pokemon to catch

    setTextOptionDescription(1, "Type the exact name of pokeball you want to auto-buy ")
    setTextOptionDescription(2, "Type the lvl to reach for all pokemon in team")
    setTextOptionDescription(4, "Refer to PathFinder, use the exact name of the map")
end

log("Make sure you have fill up the option with the good term before start !")

---------------------- #### END OF CONFIG #### ----------------------
function onStart()

    if getOption(1) then
        log("Auto-buy is activated ! The bot will buy : " .. getTextOption(1))
        buy = 1
    else
        log("Auto-buy is disable")
        buy = 0
    end
    if getOption(2) then
        log("The bot will exp our pokemon until they reach the level : " .. getTextOption(2))
        lvl = 1
    else
        log("The bot will not stop exp")
        lvl = 0
    end
    if getOption(3) then
        log("The bot will try to catch every pokemon that's not already caught.")
        uncaught = 1
    else
        log("The bot only try to catch shinys wild pokemon")
        uncaught = 0
    end
    if getOption(5) then
        log("The bot try to catch " .. getTextOption(5))
        catch = 1
    end
end

function onPathAction()
    map = getMapName()
    if not isTeamSortedByLevelAscending() then
        sortTeamByLevelAscending()
    else
        if buy == 1 and getItemQuantity(getTextOption(1)) < 50 then
            PathFinder.useNearestPokemart(map, getTextOption(1), 50)
        else
            if getPokemonHealthPercent(1) < 20 or not isPokemonUsable(1) then
                heal = 1
                PathFinder.useNearestPokecenter(map)
            else
                if heal == 1 or lvl == 1 then
                    if string.format(getPokemonLevel(1)) < getTextOption(2) then
                        map = getMapName()
                        if getMapName() == getTextOption(4) then
                            return moveToGrass() or moveToNormalGround() or moveToWater()
                        else
                            PathFinder.moveTo(map, getTextOption(4))
                        end
                    else
                        fatal("The job is done, all of our pokemon reach the level : " .. getTextOption(2))
                    end
                else
                    local map = getMapName()
                    log("DEBUG | map: "..map)
                    log("DEBUG | getTextOption(4): "..getTextOption(4))
                    if map == getTextOption(4) then
                        return moveToGrass() or moveToNormalGround() or moveToWater()
                    else
                        PathFinder.moveTo(map, getTextOption(4))
                    end
                end
            end
        end
    end
end

function onBattleAction()
    if isWildBattle() then
        if (uncaught == 1 and not isAlreadyCaught()) or (catch == 1 and getOpponentName() == getTextOption(5)) or isOpponentShiny() then
            return useItem(getTextOption(1)) or useItem("Greatball") or useItem("Ultraball") or useItem("Pokeball")
        else
            if isPokemonUsable(1) or getPokemonStatus(1) == "KO" then
                return attack() or sendUsablePokemon() or sendAnyPokemon()
            else
                return run() or sendUsablePokemon()
            end
        end
    end
end