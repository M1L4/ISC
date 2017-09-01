local BattleMessage = require "libs.battle.enum.messages"
local Item = require "libs.game.enum.items"
DialogManager = {}

local berry_tree = nil
function DialogManager:getGains(msg)
    --retrieve vars from regex expression
    local item, amount = nil, nil
    if string.match(msg, BattleMessage.EXP) then
        item = Item.EXP
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

    elseif string.match(msg, BattleMessage.LOST) then
        --TODO: repeated gym losses don't cost money
        item = BattleMessage.LOST
        amount = (getMoney()/0.95) * 0.05   -- money/0,95 = original amount | 5% is the known faktor when feinting



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