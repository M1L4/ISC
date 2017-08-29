BattleMessage = require "libs.battle.enum.messages"
DialogManager = {}

local berry_tree = nil
function DialogManager:getEarnings(msg)
    --retrieve vars from regex expression
    local item, amount = nil, nil
    if string.match(msg, BattleMessage.EXP) then
        item = "EXP"
        amount = string.match(msg, BattleMessage.EXP)

    elseif string.match(msg, BattleMessage.FOUND) then
        amount, item = string.match(msg, BattleMessage.FOUND)

    elseif string.match(msg, BattleMessage.CAUGHT) then
        --e.g.: [FF9900]Magmar[-]
        --TODO: integrate this part in BattleMessage.CAUGHT regex
        item = string.match(msg, "%b]["):sub(2, -2) --pokemon
        amount = 1
    end

    --return found items
    return item, tonumber(amount)
end

function DialogManager:getLosses(msg)

    --retrieve vars from regex expression

    --Pokeballs
    local item, amount = nil, nil
    if string.match(msg, BattleMessage.THROW) then
        --e.g.: 14 [40FF00]Pokeball[-] lost
        --TODO: integrate this part in BattleMessage.THROW regex
        item = string.match(msg, "%b]["):sub(2, -2) --ball
        amount = 1


    --Escape ropes
    --Berries

    --not implemented yet
--    elseif string.match(msg, BattleMessage.USED) then
--        item = string.match(msg, BattleMessage.USED)
--        amount = 1
--
--        return
    end

    --return found items
    return item, tonumber(amount)
end

return DialogManager