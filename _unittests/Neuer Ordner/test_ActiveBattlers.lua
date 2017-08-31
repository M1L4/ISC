pathfinder = require"libsExternal.routing.ProShinePathfinder.Pathfinder.MoveToApp"
actions = require "libs.actions"()
require "libs.routing.enum.maps"

local destination = MAP_VIRIDIAN_CITY

function onPathAction()

  local map = getMapName()

  if actions.onPathAction()  then 
  elseif map == MAP_OAKS_LAB then moveToMap("Link")
  elseif map==MAP_PEWTER_CITY then destination = MAP_VIRIDIAN_CITY
  elseif map==MAP_VIRIDIAN_CITY then destination = MAP_PEWTER_CITY
  else pathfinder.moveTo(map, destination)
  end
end

function onBattleAction()
  actions.onBattleAction()
end
