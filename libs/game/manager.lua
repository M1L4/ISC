local ItemValue = require("libs.game.data.item_values")
local statNatureTable = require "libs.game.data.statNatureTable"
local pathfinder = require("externas.proshinepathfinder.pathfinder.movetoapp")
local HiddenPowerMgr = require "libs.game.impl.hidden_power"

GameManager = {}
function GameManager.restockItems(item, target_amount, buy_at)
    --go shopping when either less items than buy_at_trashold or less than 20% target_amount
    local buy_treshold = buy_at or target_amount/20
    if getItemQuantity(item) > buy_treshold then return end


    local maxBalls = math.floor(getMoney() / ItemValue[item])
    local ballAmount = target_amount - getItemQuantity(item)
    local min = math.min(maxBalls, ballAmount)

    log("INFO | Buying " .. min .. " " .. item .. "s.")
    return pathfinder.useNearestPokemart(getMapName(), item, min)
end

--calculates the most suitable nature, disregarding speed
function GameManager.getMostSuitableNature(poke)

    --dict key=StatValue, value=Stat
    local pokeStats = {}
    --list of all stat values
    local values = {}


    --nature no influence on helth
    --ignore speed - https://pokemondb.net/pokebase/24402/which-is-more-valuable-sweeper-speed-special-attack-attack
    for _, stat in { Stat.ATTACK, Stat.DEFENCE, Stat.SPATTACK, Stat.SPDEFENCE } do
        local value = getPokemonStat(pokeIndex, stat)

        if not pokeStats[value] then
            pokeStats[value] = {}
        end

        table.insert(pokeStats[value], stat)
        table.insert(values, value)
    end

    local maxStats = pokeStats[math.max(values)]
    local minStats = pokeStats[math.min(values)]

    if #minStats ~= 1
        or #maxStats ~= 1 then
        fatal("Pokemon has multiple suitable natures..., pls decide...")
    end

    return statNatureTable[maxStats[1]][minStats[1]]
end

function GameManager.getHiddenPowerType(ivs)
    return HiddenPowerMgr.getHiddenPowerType(ivs)
end

return GameManager