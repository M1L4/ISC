pathfinder = require "libs.routing.proshinepathfinder.pathfinder.movetoapp"
battlemaniac = require "libs.routing.battlemaniac"
Map = require "libs.routing.enum.maps"

goal = Map.FUCHSIA_CITY--"Route 14"

function onPathAction()
  if not battlemaniac.isBattling() then
    pathfinder.moveTo(getMapName(), goal)
  end
end

function onBattleAction()
  if isWildBattle() and (isOpponentShiny() or not isAlreadyCaught()) then
    return useItem("Ultra Ball") or useItem("Great Ball") or useItem("Pokeball")
  else
    return attack() or sendUsablePokemon() or run() or sendAnyPokemon()
  end
end
