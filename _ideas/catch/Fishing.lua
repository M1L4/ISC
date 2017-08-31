
-- Copyright © 2016 Silv3r <silv3r@openmailbox.org>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the LICENSE file for more details.

name = "Fishing: Pallet"
author = "mpScript"
description = [[This script can fish in Pallet Town to catch Magikarp, level up the first pokemon as well.]]

--dofile("..\Routing\ProShinePathfinder\Pathfinder\MoveToApp.lua")


function onPathAction()
    if isPokemonUsable(1) then
        log("usable")
        if getMapName() == "Pokecenter Pallet" then
            log("at pokecenter")
            moveToMap("Pallet Town")
        elseif getMapName() == "Pallet Town" then
            
            if getPlayerX() == 13 and getPlayerY() == 25 and hasItem('Old Rod') then
                log("using old Rod")
                useItem('Old Rod')
            else
                moveToCell(13, 25)
            end
        end
    else
        if getMapName() == "Pallet Town" then
            moveToMap("Pokecenter Pallet")
        elseif getMapName() == "Pokecenter Pallet" then
            usePokecenter()
        end
    end
end

function onBattleAction()
    log("Opponent Name: "..getOpponentName().."(lv "..getOpponentLevel()..") Health: "..getOpponentHealth().."("..getOpponentHealthPercent().."%)")
    
    if isWildBattle() and (not isAlreadyCaught() or isOpponentShiny() or getOpponentName() == "Staryu") then
        if isWildBattle() then
            if useItem("Pokeball") or useItem("Great Ball") or useItem("Ultra Ball") then
                return
            end
        end
    end
    
    if getActivePokemonNumber() == 1 then
        return attack() or sendUsablePokemon() or run() or sendAnyPokemon()
    else
        return run() or attack() or sendUsablePokemon() or sendAnyPokemon()
    end
    
end