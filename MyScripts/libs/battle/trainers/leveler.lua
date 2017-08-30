--imports
local pathfinder = require "libs.routing.proshinepathfinder.pathfinder.movetoapp"
local TeamManager = require "libs.team.manager"
local BattleManager = require "libs.battle.manager"

--proShine Description
author = "m1l4"
name = "Leveler"
description = "A basic leveler heading to map \"%s\" leveling until %s."


--class declaration
--- @summary : A basic l
local TrackedZoner = require "libs.battle.trainers.base.tracked_zoner"
local Leveler = TrackedZoner:new()

Leveler._new = Leveler.new
--- @summary : --- usage Lever:new(map = "hallo", target_lvl=6)
--- @param map:
--- @type : string
--- @param lvl_cap:
--- @type : integer | nil
--- @param lvl_team_range:
--- @type : integer
function Leveler:new()
    self:_new()

    --set default values
    self.lvl_cap = 98 --to allow 3 stage evolutions
    self.lvl_team_range = nil

    --the level advantage a pokemon has to held, before soloing opponents
    self.min_level_adv = 8
    self.switch_in = nil

    return self
end


Leveler._onStart = Leveler.onStart
function Leveler:onStart()
    self:_onStart()

    --disable AutoEvolve for reduced exp needed to lvl up
    disableAutoEvolve()

    --can't set in init, since getMapName() needs a running bot
    self.lvl_team_range = self.lvl_team_range or getTeamSize()
end

--added functions
--- @summary : set the range of PKM to level. E.g.: setTeamRange(5), levels the first 5 PKM
function Leveler:setTeamRange(range)
    if range >= 1 and range <= getTeamSize() then
        self.lvl_team_range = range
    end

    self:_updateDescription()
end

function Leveler:setLvlCap(lvl_cap)
    if lvl_cap >= 1 and lvl_cap <= 100 then
        self.lvl_cap = lvl_cap
    end

    self:_updateDescription()
end

function Leveler:setTeamRange(lower, upper)
    fatal("setTeamRange not implemented yet")
end

--overriden functions
Leveler._setMap = Leveler.setMap
function Leveler:setMap(map)
    self:_setMap(map)
    self:_updateDescription()
end


--functions to be implemented
function Leveler:_onPathAction()

    --all leveled up,
    if self.lvl_cap and not TeamManager.getPkmToLvl(self.lvl_cap) then
        return log("INFO | All PKM have reached targeted lv cap.")
    end

    -- check starter
    local starter_id = TeamManager.getStarter()
    log("DEBUG | wild_encounters: "..tostring(self.tracker.wild_encounters > 0))
    log("DEBUG | no switch_in: "..tostring(not self.switch_in).."\t("..tostring(self.switch_in)..")")
    log("DEBUG | unusable: "..tostring(not BattleManager.isUsable(starter_id)))
    log("DEBUG | lvl capped: "..tostring(not TeamManager.isPkmToLvlAlive(starter_id, self.lvl_cap)))



    if self.tracker.wild_encounters > 0                                 -- min 1 wild encounter needed to guess map lvl
        and not self.switch_in                                          -- if pkm stronger than map lvl and fights on its own
        and not BattleManager.isUsable(starter_id)                      -- it needs usable attacks
        or not TeamManager.isPkmToLvlAlive(starter_id, self.lvl_cap)    -- or it is already level capped

    then
        --swarp starter to lowest leveled pkm
        local new_starter_id = TeamManager.getLowestPkmToLvl(self.lvl_cap)
        if new_starter_id and starter_id ~= new_starter_id then
            log("DEBUG | levler swap")
            return swapPokemon(new_starter_id, starter_id)
        end
    end

    --leftovers
    --give leftovers to the pkm being switched in or the first pkm
    --TODO: TeamManager.getFirstUsablePkm() is never reached, when Survivor takes control and attempt running to pkm center
    local leftovers_target = self.switch_in or starter_id or TeamManager.getFirstUsablePkm()
    if TeamManager.giveLeftoversTo(leftovers_target) then return true end

    --all leveling pkm dead, so leftovers given to first usable pkm and moving towards pkm center
    if not TeamManager.getUsablePkmToLvl(self.lvl_cap) then return pathfinder.useNearestPokecenter(getMapName()) end
end

function Leveler:_onBattleAction()
    --replace underleved starter PKM with overleved one
    local id_active = getActivePokemonNumber()
    local lvl_dif = getPokemonLevel(id_active) - getOpponentLevel()
    local switch_in = self:getSwitchIn()

    --if no change_in is available, try use the standard behaviour and atk until dead
    if not switch_in then
        -- no switch_ins available any longer: reset if previously switch_ins were used
        self.switch_in = nil
        return
    end

    -- switch in available
    if lvl_dif < self.min_level_adv or getPokemonHealth(id_active) == 0 then

        --change switch_in only if necessary (dead) > most effect for leftovers
        if not (self.switch_in and BattleManager.isUsable(self.switch_in)) then
            self.switch_in = switch_in
        end

        --exp share
        return sendPokemon(self.switch_in)

    elseif id_active == 1 then
        -- pkm is starter and
        -- lvl higher then opponents by given value
        self.switch_in = nil
    end
end


--additional needed functions
function Leveler:getSwitchIn()
    for _, index in pairs(TeamManager.getUsablePkmToLvl(self.lvl_cap)) do

        --level is higher by at least min_level_adv
        local lvl_dif = getPokemonLevel(index) - getOpponentLevel()
        if lvl_dif >= self.min_level_adv then return index end
    end
end

function Leveler:_updateDescription()
    --inputing script vars to description
    local level = nil
    if self.lvl_cap then level = "lv " .. tostring(self.lvl_cap)
    else level = "∞" --utf8.char(9658)
    end
    description = string.format(description, self.exp_map, level)
end

return Leveler