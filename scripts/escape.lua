local Item = require "libs.game.enum.items"

function onPathAction()
    if not string.match(getMapName(), "Pokecenter") then return useItem(Item.ESCAPE_ROPE) end
end

