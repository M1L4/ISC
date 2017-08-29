require "libs.util.math"
require "libs.util.collection"
Terrain = require "libs.routing.enum.terrains"

-- battle maniac functions - obsolete in future updates

--VIEW_RANGE = 15
--local ALIGNMENT = {X="x", Y="y"}
--local SWITCH = {[ALIGNMENT.X]=ALIGNMENT.Y, [ALIGNMENT.Y]=ALIGNMENT.X}
--
-- --checks if path is blocked from on cell to the next
-- local function isStepPossible(posA, posB)
-- if getSimpleDistance(posA, posB)>1 then
-- fatal("\"isStepPossible()\" was intended for single cell distance comparison")
-- end
--
--
-- local cellTypeA = getCellType(posA.x, posA.y)
-- local cellTypeB = getCellType(posB.x, posB.y)
--
-- local pathBlocked = Set{Terrain.COLLIDER, Terrain.PC, Terrain.LINK}
--
-- -- no sight, if view is blocked
-- if pathBlocked[cellTypeA] or pathBlocked[cellTypeB] then
-- return false
--
-- -- no sight if separated by water
-- elseif cellTypeA ~= cellTypeB
-- and cellTypeA == Terrain.WATER
-- or cellTypeB == Terrain.WATER
-- then
-- return false
-- end
--
-- return true
-- end
--
-- -- iterates through either x or y and checks if any obstacles occur
-- local function isLineBlocked(posA, posB, alignment)
-- log("debug | isLineBlocked entered")
--
-- -- for basic loop call can only count up
-- -- >switch positions if loop wouln't iterate
-- if posA[alignment] > posB[alignment] then
-- return isLineBlocked(posB, posA, alignment)
-- end
--
--
-- -- actual method
-- local iterPos = copy(posA)
--
-- for i = iterPos[alignment], posB[alignment] do
--
-- local iterPos2 = iterPos
-- iterPos2[alignment] = i
--
-- if not isStepPossible(iterPos, iterPos2) then return true end
--
-- iterPos[alignment] = i
-- end
--
-- -- no interception, so view is possible
-- return false
-- end
--
-- -- this function checks if terrain on line between player and
-- -- battler is not iterrupted from obj or water
-- function isInSight(posA, posB)
-- log("debug | isInSight entered")
-- log("debug | alignments: "..#ALIGNMENT)
-- for _, alignment in pairs(ALIGNMENT) do
-- log("debug | alignment: "..alignment)
-- log("debug | is in sightline: "..tostring(posA[alignment] == posB[alignment]))
-- log("debug | is in view: "..tostring(math.abs(posA[SWITCH[alignment]] - posB[SWITCH[alignment]]) <= VIEW_RANGE))
--
-- -- check if posA is on same height (x or y-wise)
-- if posA[alignment] == posB[alignment]
--
-- -- check if other graph value (x or y) is in view range
-- and math.abs(posA[SWITCH[alignment]] - posB[SWITCH[alignment]]) <= VIEW_RANGE
-- then
-- return not isLineBlocked(posA, posB, SWITCH[alignment])
-- end
-- end
--
-- return false
-- end
--
-- function getAnticipatedOnPathActionPositions(player)
--
-- local functions = {
-- function(p) p.x=p.x+1; return p end,  --move east
-- function(p) p.x=p.x-1; return p end,  --move west
-- function(p) p.y=p.y+1; return p end,  --move north
-- function(p) p.y=p.y-1; return p end   --move south
-- }
--
-- local anticipatedPositions = {}
-- for _, f in ipairs(functions) do
-- local posA = copy(player)
-- local posB = copy(player)
--
-- while(isStepPossible(posA,posB))
-- do
-- table.insert(anticipatedPositions, copy(posB))
-- posA = posB
-- posB = f(posB)
-- end
-- end
--
-- return anticipatedPositions
-- end



-- Every minutesToMove minutes, picks a random integer between 1 and #list / 4 to get a number corresponding to each rectangle in list
function moveToRandRect(list, minutesToMove)

    if not rectTimer
        or not rand
        or not tmpRand then
        rectTimer = os.time()
        rand = 0 -- Used to represent each rectangle in area
        tmpRand = 0 -- Used to make sure rand is different every time we call math.random
    end


    if os.difftime(os.time(), rectTimer) > minutesToMove * 60 or rand == 0 or rand > #list / 4 or rand == tmpRand then
        rectTimer = os.time()
        tmpRand = rand
        rand = math.random(#list / 4)
    end

    local n = (rand - 1) * 4
    local x = 0; y = 0; dx = 0; dy = 0

    x = math.min(list[n + 1], list[n + 3])
    y = math.min(list[n + 2], list[n + 4])

    dx = math.abs(list[n + 1] - list[n + 3])
    dy = math.abs(list[n + 2] - list[n + 4])

    return moveToRectangle(x, y, x + dx, y + dy)
end
