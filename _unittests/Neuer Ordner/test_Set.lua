require "libs.routing.enum.maps"

function Set (list) local set = {}
  for _, l in ipairs(list) do set[l] = true end
  return set
end

local questRegion = Set{
  MAP_PLAYER_BEDROOM_PALLET,
  MAP_PLAYER_HOUSE_PALLET,
  MAP_PALLET_TOWN,
  MAP_OAKS_LAB,
  MAP_RIVALS_HOUSE
}

print(#questRegion)
print(questRegion[MAP_PLAYER_BEDROOM_PALLET])
print(questRegion[MAP_VIRIDIAN_CITY])
print(nil==false)