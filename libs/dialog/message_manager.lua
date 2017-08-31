local Item = require "libs.game.enum.items"
local DialogMessage = require "libs.dialog.enum.messages"
DialogManager = {}

local berry_tree = nil
function DialogManager:getEarnings(msg)
    --find correct pattern
    local pattern = nil
    if string.match(msg, DialogMessage.FOUND) then
        pattern = DialogMessage.FOUND

    elseif string.match(msg, DialogMessage.RECEIVED) then
        pattern = DialogMessage.RECEIVED
    end

    --if it's the berry_tree/harvesting pattern: harvesting has to be called directly after berry tree,
    --reset otherwise
    if string.match(msg, DialogMessage.BERRY_TREE) then
        berry_tree = string.match(msg, DialogMessage.BERRY_TREE)
        return

    elseif not string.match(msg, DialogMessage.HARVESTED) then

        berry_tree = nil
    end


    --return when no pattern was found
    if not pattern then return end

    --retrieve vars from regex expression
    local amount, item = string.match(msg, pattern)
    if string.match(msg, DialogMessage.HARVESTED) and berry_tree then
        amount = string.match(msg, DialogMessage.HARVESTED)
        item = berry_tree
    end

    --return found items
    return item, tonumber(amount)
end

function DialogManager:getLosses(msg)
    local item, amount = nil, nil
    if string.match(msg, DialogMessage.ON_ROAD_NURSE_VISITED) then
        item = Item.MONEY
        amount = 2500
    end

    --Escape
    --Berries
    --Pokeballs
    return item, amount
end

function DialogManager:isPkmCenterVisited(msg)
    --TODO: exceptions nurses in Lavender tower, Indigo Platea Center, ...
    --or aunts, free lancer nurses...

    --Seafoam working!
    return string.match(msg, DialogMessage.PKM_CENTER_VISITED)
end

function  DialogManager:isShopOpen(msg)
    --TODO: exceptions nurses in Lavender tower, Indigo Platea Center, ...
    --or aunts, free lancer nurses...
    return string.match(msg, DialogMessage.SHOP_OPENED)
end

return DialogManager