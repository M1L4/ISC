-- ------------added------------
-- ----config start----
local minutesToMove = 5
-- input list in pairs of two: {30,27, 30,28, 20,25}
local fishingSpots = { 30, 27, 36, 28, 34, 27 }
local rod = "Old Rod"
-- ----config end----

function onStart()
    --init some calc globals
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

    --starter unusable, use pokecenter
    if not isPokemonUsable(1) then
        --in city
        if map == "Vermilion City" then
            return moveToMap("Pokecenter Vermilion")
            --in pokecenter
        elseif map == "Pokecenter Vermilion" then
            return usePokecenter()
        end

        --starter usable, move to fishing spot
    else
        --in pokecenter
        if map == "Pokecenter Vermilion" then
            return moveToMap("Vermilion City")
            --in city
        elseif map == "Vermilion City" then
            --modified
            return randomSpotFishing(fishingSpots)
        end
    end
end

function onBattleAction()
    log("Opponent Name: " .. getOpponentName() .. "(lv " .. getOpponentLevel() .. ") Health: " .. getOpponentHealth() .. "(" .. getOpponentHealthPercent() .. "%)")
    if isWildBattle() and (not isAlreadyCaught() or isOpponentShiny() or getOpponentName() == "Magikarp") then
        return useItem("Pokeball") or useItem("Great Ball") or useItem("Ultra Ball")

    elseif getActivePokemonNumber() == 1 then
        return attack() or sendUsablePokemon() or run() or sendAnyPokemon()
    end

    return run() or attack() or sendUsablePokemon() or sendAnyPokemon()
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
    return moveToCell(newX, newY)
end

