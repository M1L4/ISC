local API = require "libs.util.api"
local TeamManager = require "libs.team.manager"
local BattleManager = require "libs.battle.manager"
local BattleMessage = require "libs.battle.enum.messages"
local pathfinder = require "externas.proshinepathfinder.pathfinder.movetoapp"

Survivor = API:new()
function Survivor:init()
    self.is_running_possible = true
    self.is_switch_possible = true
end

function Survivor:onPathAction()
    --TODO: add Smoke Ball (Held Item)

    --TODO: first alive pkm has to have pps if possible

    --TODO: add some sort of underleveled prevention (move highest leveld pkm to last position,
    --change TeamManager.isUsable() according to avg map lvl
    --calculate map lvl (1. count pkm 2. count lvl 3. lvls/pkms)
    --if underleveled and next pokecenter requires multiple maps to be passed, use escape rope

    if not TeamManager.isUsable() then
        --TODO: with the integration of trainer battles, this should be updated to last visited
        return pathfinder.useNearestPokecenter(getMapName())
    end

    --increase survivability by setting bulk as last pokemon
    local highestLvlPkm = TeamManager.getHighestPkmAlive()
    local lastPkm = TeamManager.getLastPkmAlive()
    if highestLvlPkm ~= lastPkm then
        log("DEBUG | survivor swap")
        return swapPokemon(highestLvlPkm, lastPkm) end

end

function Survivor:onBattleAction()
    --running
    if not TeamManager.isUsable() then
        return self.is_running_possible and run()           --1. we try to run
        or attack()                                         --2. we try to attack
        or self.is_switch_possible and sendUsablePokemon()  --3. we try to switch pokemon that has pp
        or self.is_switch_possible and sendAnyPokemon()     --4. we try to switch to any pokemon alive
        or BattleManager.useAnyAttack()                     --5. we try to use non-damaging attack
        or BattleManager.useAnyMove()                       --6. we try to use garbage items
    end


    --TODO: status checks - e.g.:
    -- if  active pkm sleeping
    -- and not has moves like (sleep talking, snore, ...)
    -- and player hasitem pokeflute
    -- use pokeflote

    -- use berries
end

function Survivor:onBattleMessage(message)
    --reset safty checks, when we successfully progress a round
    if string.match(message, BattleMessage.RUN)
        or string.match(message, BattleMessage.WON)
        or string.match(message, BattleMessage.LOST)
        --either use your or your opponents moves. we decided to monitor ours
        or string.match(message, BattleMessage.PKM_FAINTED)
        or string.match(message, BattleMessage.PKM_ATTACKED)
        or string.match(message, BattleMessage.PKM_SWITCHED)
        or string.match(message, BattleMessage.ITEM_USED)
    then
        self.is_running_possible = true
        self.is_switch_possible = true

    --set safty checks to avoid $NO_RUN loops
    elseif string.match(message, BattleMessage.NO_RUN) then
        self.is_running_possible = false

    --set safty checks to avoid $NO_SWITCH loops
    elseif string.match(message, BattleMessage.NO_SWITCH) then
        self.is_switch_possible = false
    end
end

function Survivor:onStart()
    if isPrivateMessageEnabled() then
        log("Private messages disabled.")
        return disablePrivateMessage()
    end
end

return Survivor