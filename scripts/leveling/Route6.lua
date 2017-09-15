--imports
local Leveler = require "libs.battle.trainers.leveler"
--enums
local Map = require "libs.routing.enum.maps"
local Terrain = require "libs.routing.enum.terrains"
--

--####mandatory####
script = Leveler:new()
script:setMap(Map.ROUTE_6)


--####optional####
-- ------------Level Cap------------
-- set to which level pkm shall be leveled - typical values:
-- 98   --default: to allow double evolutions
-- 100
-- nil  --no upper limit, endless leveling

--script:setLvlCap(nil)


-- ------------Area------------
-- set to level using certain areas - typical values:
-- Terrain.GRASS
-- Terrain.NORMAL_GROUND
-- Terrain.WATER
-- {12,35,65,12,  15,12,19,17}  --certain rectangles
-- {37,27}      --fishing spot

--script:setExpZone(Terrain.NORMAL_GROUND)


-- ------------Team Range------------
-- e.g. Pos1 - sync, Pos6 - arena trapper:
-- setting lower = 2, upper = 5
-- will only level pkm from the ranks of 2-5

--script:setTeamRange(lower, upper)

require "libs.util.api_executioner"