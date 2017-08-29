--behaviour
local Survivor = require "libs.battle.trainers.base.survivor"
--libs/manager
local BattleManager = require "libs.battle.manager"
local GameManager = require "libs.game.manager"
local pathfinder = require "libs.routing.proshinepathfinder.pathfinder.movetoapp"
local Tracker = require "libs.game.tracker"
local Item = require "libs.game.enum.items"
local DialogMessageManager = require "libs.dialog.message_manager"
require "libs.routing.pathing"
--enums
local Terrain = require "libs.routing.enum.terrains"
local MAP_REACHED = "target_map_reached"

--mart states
local MART_VISITABLE = "mart_visitable"
local MART_VISITING = "mart_visiting"
local MART_OPEN = "shop_open"

--class declaration
TrackedZoner = Survivor:new()
TrackedZoner._init = TrackedZoner.init
function TrackedZoner:init()
    self:_init()

    self.tracker = Tracker:new()

    --orientation
    self.exp_map = nil
    self.exp_zone = nil
    self.exp_zones = {
        [Terrain.GRASS] = moveToGrass,
        [Terrain.NORMAL_GROUND] = moveToNormalGround,
        [Terrain.WATER] = moveToWater,
    }
    --Pokemon center nearest to the exp zone
    self.registered_pkm_center = nil
    --only go to marts, when doing a checkup in poke center
    self.mart_state = nil
end

function TrackedZoner:onStart()
    self.tracker:onStart()

    --TODO: enable auto-reconnect, when available via proshine?

    --can't set in init, since getMapName() needs a running bot
    self.exp_map = self.exp_map or getMapName()
end


--functions to be implemented
function TrackedZoner:_onPathAction() log("_onPathAction not implemented yet.") end
function TrackedZoner:_onBattleAction() log("_onBattleAction not implemented yet.") end

--added functions
function TrackedZoner:setExpZone(area)
    self.exp_zone = area
end

function TrackedZoner:setMap(map)
    self.exp_map = map
end


--api functions
TrackedZoner.__onPathAction = TrackedZoner.onPathAction
function TrackedZoner:onPathAction()

    self.tracker:onPathAction()

    --execute superclass functionality
    if self:__onPathAction() then return end

    --execute subclass dependend actions
    if self:_onPathAction() then return end

    local map = getMapName()
    -- register pokecenter nearest to target map
    if not self.registered_pkm_center and map == self.exp_map then
        -- prevent long journeys when blacking out, by making sure a near poke_center was used before hunting
        self.registered_pkm_center = MAP_REACHED
    end

    --movement
    if self.registered_pkm_center == MAP_REACHED then
        -- prevent long journeys when blacking out, by making sure a near poke_center was used before hunting
        return pathfinder.useNearestPokecenter(map)

    elseif self.mart_state
        and ( self.mart_state == MART_VISITABLE or self.mart_state == MART_VISITING )
        and GameManager.restockItems(Item.POKEBALL, 75, 25)
    then
        -- moving to mart | frame full = return
        self.mart_state = MART_VISITING
        return true

    elseif self.mart_state == MART_VISITING then
        -- TODO: remove when pathfinder bugfixed this issue
        -- this is needed due a unclean implementation in pathfinder:
        -- 1) from pathfinder api: useNearestPokemart() - Return true if moving, false on performing a buy,
        --    or if the buy can't be performed.
        -- 2) the first frame where pf.useNearestPokemart() returns false, is actually still being used by it.
        -- 3) we have to block that frame, to avoid multiple actions being called, throwing an exception
        -- 4) block it only for one frame, to avoid "no action performed"-exception, terminating bot
        return true

    elseif self.mart_state == MART_OPEN then
        --dialog open | without state transition bot would turn around at shop desk (no balls buyed)
        self.mart_state = nil
        return GameManager.restockItems(Item.POKEBALL, 75, 25)

    elseif map ~= self.exp_map then
        return pathfinder.moveTo(map, self.exp_map)

    elseif not self.exp_zone then
        --standard exp zone behaviour
        return moveToGrass() or moveToNormalGround() or moveToWater()

    elseif self.exp_zones[self.exp_zone] then
        --specific exp zone behaviour
        return self.exp_zones[self.exp_zone]()

    elseif #self.exp_zone % 4 == 0 then
        --switching rectangles
        return moveToRandRect(self.exp_zone, minutesToMove)

    elseif #self.exp_zone == 2 then
        --TODO: implement fishing at some point - is it possible to autodetect shore?
        --fishing
        return updateFishing(self.exp_zone)
    end
end

TrackedZoner.__onBattleAction = TrackedZoner.onBattleAction
function TrackedZoner:onBattleAction()

    -- catch | shiny or event pkm - regardless of team status
    local isEventPokemon = getOpponentForm() ~= 0
    if isWildBattle() and
        (isOpponentShiny() or isEventPokemon)
    then
        if self:catch() then return true end
    end

    --execute superclass functionality | running to pokecenter if team is unusable
    if self:__onBattleAction() then return end

    --execute subclass dependend actions
    if self:_onBattleAction() then return end

    -- catch | uncaught - if team is usable
    if isWildBattle() and not isAlreadyCaught() then
        if self:catch() then return true end
    end

    --@summary: Simple attacking bot implementation
    --fighting till unusable team
    return attack() --1. we try to attack
        or self.is_switch_possible and sendUsablePokemon() --2. we try to switch pokemon with pp
        or self.is_running_possible and run() --3. we try to run
        or self.is_switch_possible and sendAnyPokemon() --4. we try to switch to any pokemon alive
        or BattleManager.useAnyAttack() --5. we try to use non-damaging attack
        or BattleManager.useAnyMove() --6. we try to use garbage items
end


--System: You used Full Restore on your Pokemon
function TrackedZoner:onStop() self.tracker:onStop() end
function TrackedZoner:onPause() self.tracker:onPause() end
function TrackedZoner:onResume() self.tracker:onResume() end

-- messages - tracker included
TrackedZoner._onBattleMessage = TrackedZoner.onBattleMessage
function TrackedZoner:onBattleMessage(msg)
    self:_onBattleMessage(msg)
    self.tracker:onBattleMessage(msg)
end
function TrackedZoner:onDialogMessage(msg)
    self.tracker:onDialogMessage(msg)
    if DialogMessageManager:isPkmCenterVisited(msg) then
        self.registered_pkm_center = getMapName()
        self.mart_state = MART_VISITABLE

    elseif DialogMessageManager:isShopOpen(msg) then
        self.mart_state = MART_OPEN
    end
end
function TrackedZoner:onSystemMessage(msg) self.tracker:onSystemMessage(msg) end

--added functions
function TrackedZoner:catch()
    return useItem(Item.POKEBALL)                           -- 1. try catching with pokeball
        or useItem(Item.GREAT_BALL)                         -- 2. try catching with great ball
        or useItem(Item.ULTRA_BALL)                         -- 3. try catching with ultra ball

        or (hasItem(Item.POKEBALL)
        or hasItem(Item.GREAT_BALL)
        or hasItem(Item.ULTRA_BALL))
        and self.is_switch_possible and sendAnyPokemon()    -- 4. switch pkm if active feints and any ball is available
end


return TrackedZoner