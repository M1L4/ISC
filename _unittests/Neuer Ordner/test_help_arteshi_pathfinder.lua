-- ------------added------------
-- ----config start----
local minutesToMove = 5
-- input list in pairs of two: {30,27, 30,28, 20,25}
local fishingMap = "Vermilion City"
local fishingSpots = { 30,27, 36,28, 34,27 }
local rod = "Old Rod"
-- ----config end----

--adding pathfinder reference | file needs to be in the same dir as pathfinder folder
local pathfinder = require "pathfinder.movetoapp"

function onStart()
    --init some calc functions
    timer = os.time()
    rand = 1

    --check if rod is available
    if not hasItem(rod) then
        fatal("Can't fish without " .. rod)
    end
end


-- ------------old script------------
function onPathAction()
    local map = getMapName()
    --checking only the first pokemon
    --improvements: sort team, to have a usable poke as starter

    if not isPokemonUsable(1) then
        --starter unusable, use pokecenter
        pathfinder.useNearestPokecenter(map)

    else
        --starter usable, move to fishing spot
        return randomSpotFishing(fishingSpots)
    end
end

-- ------------added------------
function randomSpotFishing(list)
    -- if time difference between current time and timer exceeds "minutesToMove" switch fishing spot
    if os.difftime(os.time(), timer) > minutesToMove * 60 then
        --reset timer
        timer = os.time()

        --assign random fishing spot
        rand = math.random(#list / 2)
    end

    --some calculation to get new coordinates
    local index = (rand - 1) * 2

    local newX = list[index + 1]
    local newY = list[index + 2]

    --fish, if in position
    if getPlayerX() == newX and getPlayerY() == newY then
        return useItem(rod)
    end

    --move to position otherwise
    return pathfinder.moveToMapCell(map, fishingMap, newX, newY)
end
