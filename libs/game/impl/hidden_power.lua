local Stat = require "libs.game.enum.stats"
local HiddenPower = require "libs.game.data.hidden_power"

--for naming and explanations - see: https://pokemon-revolution-online.net/Forum/viewtopic.php?f=123&t=63825&p=368117&hilit=leveling+guide#p368117

local function getHiddenPowerType(ivs)
    local a = ivs[Stat.HEALTH] % 2
    local b = ivs[Stat.ATTACK] % 2
    local c = ivs[Stat.DEFENCE] % 2
    local d = ivs[Stat.SPATTACK] % 2
    local e = ivs[Stat.SPDEFENCE] % 2
    local f = ivs[Stat.SPEED] % 2

    local bin = a..b..c..d..e..f
    local type_id = math.floor(tonumber(bin, 2)*15/63)
    return HiddenPower[type_id]
end


return {
    getHiddenPowerType = getHiddenPowerType
}