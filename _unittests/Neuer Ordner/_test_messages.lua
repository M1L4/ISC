---@summary: Some meta information, which are shown on script start.

author = "m1l4"
name = "Test Messages"
description = ""

---@summary: Following are all the functions being called by proShine.

pathfinder = require "libs.routing.proShinePathfinder.pathfinder.moveToApp"

--bot controls
--actions
function onPathAction()
    pathfinder.useNearestPokemart(getMapName(),"Pokeball", 5)
end


function onBattleAction()
    return attack() or sendUsablePokemon() or run()
end

--messages
function onDialogMessage(msg) log("Info | dialog: "..msg)   end
function onBattleMessage(msg) log("Info | battle: "..msg)   end
function onSystemMessage(msg) log("Info | system: "..msg)   end
