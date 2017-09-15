pf = require "pathfinder.movetoapp"

local repel = "Repel"
local dest = "Route 11"
local state = 0

function onStart() return useRepel() end

function onSystemMessage(msg)
    log("onSystemMessage")
    if stringContains(msg, "Repel effect has worn off.") then return useRepel() end
end

function useRepel()
    log("execute repel")
    if hasItem(repel) then return useItem(repel) end

    return false
end

function onPathAction()
    if state == 0 then
        state = 1
        return pf.useNearestPokemart(repel, 2)
    end

    local map = getMapName()
    if map ~= dest then pf.moveTo(dest) end

    return moveToGrass()
end

function onBattleAction()
    return attack() or sendUsablePokemon() or senAnyPokemon()
end