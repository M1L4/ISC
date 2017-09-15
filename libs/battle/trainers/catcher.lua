--local Attack = require "libs.battle.enum.attacks"
local Nature = require "libs.game.enum.natures"
local Ability = require "libs.game.enum.ability"
local Stat = require "libs.game.enum.stats"



--imports
require "libs.util.collection" --Set import
--local pathfinder = require "externas.proshinepathfinder.pathfinder.movetoapp"
--local TeamManager = require "libs.team.manager"


--class declaration
local TrackedZoner = require "libs.battle.trainers.base.tracked_zoner"
local Catcher = TrackedZoner:new()
function Catcher:init()
    --set default values
    self.target_pkms = {}
    self.target_nature = nil
    self.target_ability = nil
    self.target_iv = 0

    --user vars
    self.continue_hunting = false
end


--added functions
--- @summary :
function Catcher:setNature(nature)          self.nature = nature    end
function Catcher:setAbility(ability)        self.ability = ability  end
function Catcher:setRepelTrick(repelTrick)  self.repelTrick = repelTrick  end

--    nature checks:
--    local nature_exists = Set(Nature)
--    if not nature_exists[nature] then fatal("Nature "..tostring(nature).."is unknown.") end
--    self.nature = nature

--    ability checks:
--    local ability_exists = Set(Ability)
--    if not ability_exists[ability] then fatal("Ability "..tostring(ability).."is unknown.") end
--    self.ability = ability


--- @summary :
--- @param iv:  - specific IV value | 143
---             - minimum IV value overall | IV.EPIC
---             - minimum specific IV value overall | {hp, atk, c,d,e,f}
--- @type : integer | string | table
function Catcher:setiv(iv)
    local function sum(a, b) return a + b end
     table.sort(people, nameComparator)

    --input testing
    if type(iv) ~= integer                  -- specific sum
        or type(iv) ~= string               -- EPIC, GOOD, Normal
        or type(iv) ~= table                --
        or #iv ~= 6                         --TODO: probably #iv wont work, maybe try using a set()?
        or table.reduce(iv, sum) <= 186     --sum ivs max 6*31 = 186
    then
        fatal("IV Format "..tostring(iv).."is unknown.")
    end

    --setting ivs for none table values
    if type(iv) ~= table  then self.target_iv = target_iv return end

    --setting ivs for table values
    --if its a table, input testing made sure it has 6 entries
    self.target_iv = {}
    for index, stat in pairs(Stat) do self.target_iv[stat] = iv[index] end
end


Catcher._onStart = Catcher.onStart
function Catcher:onStart()
    self:_onStart()

    --disable AutoEvolve for reduced exp needed to lvl up
    disableAutoEvolve()

    --can't set in init, since getMapName() needs a running bot
    self.lvl_team_range = self.lvl_team_range or getTeamSize()
end




--functions to be implemented
function Catcher:_onPathAction()

    --all leveled up,
    -- TODO: stop or continue hunting?
    if not TeamManager.getPkmToLvl(self.lvl_cap) then return log("INFO | All PKM have reached targeted lv cap.") end

    --put leveling PKM in front
    local starter_id = TeamManager.getLowestAlivePkmToLvl(self.lvl_cap)
    if starter_id and starter_id ~= 1 then
        return swapPokemon(1, starter_id)
    end

    --leftovers
    --give leftovers to the pkm being switched in or the first pkm
    --TODO: TeamManager.getFirstUsablePkm() is never reached, when Survivor takes control and attempt running to pkm center
    local leftovers_target = self.switch_in or starter_id or TeamManager.getFirstUsablePkm()
    if TeamManager.giveLeftoversTo(leftovers_target) then return true end

    --all leveling pkm dead, so leftovers given to first usable pkm and moving towards pkm center
    if not TeamManager.getUsablePkmToLvl(self.lvl_cap) then return pathfinder.useNearestPokecenter(getMapName()) end
end

function Catcher:_onBattleAction()
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

    elseif id_active == 1  then
        -- pkm is starter and
        -- lvl higher then opponents by given value
        self.switch_in = nil
    end
end


--additional needed functions
function Catcher:getSwitchIn()
    for _, index in pairs(TeamManager.getUsablePkmToLvl(self.lvl_cap)) do

        --level is higher by at least min_level_adv
        local lvl_dif = getPokemonLevel(index) - getOpponentLevel()
        if lvl_dif >= self.min_level_adv then return index end
    end
end

return Catcher



function catch()
    if isPokemonUsable(getActivePokemonNumber()) then
        if getOpponentHealthPercent() > throwHealth then
            if useSwipe and hasUsablePokemonWithMove("False Swipe") then
                if getActivePokemonNumber() == hasUsablePokemonWithMove("False Swipe") then
                    if useMove("False Swipe") then return end
                else
                    if sendPokemon(hasUsablePokemonWithMove("False Swipe")) then return end
                end
            elseif useStatus and hasUsablePokemonWithMove(statusMove) then
                if getActivePokemonNumber() == hasUsablePokemonWithMove(statusMove)["id"] then
                    if getOpponentStatus() == "None" then
                        if useMove(hasPokemonWithMove(statusMove)["move"]) then return end
                    else
                        if useItem(typeBall) then return end
                    end
                else
                    if sendPokemon(hasUsablePokemonWithMove(statusMove)["id"]) then return end
                end

            else
                if isPokemonUsable(getActivePokemonNumber()) then
                    if weakAttack() then return end
                else
                    if sendUsablePokemon() or sendAnyPokemon() or run() then return end
                end
            end

        else
            if useStatus and hasUsablePokemonWithMove(statusMove) then
                if getActivePokemonNumber() == hasUsablePokemonWithMove(statusMove)["id"] then
                    if getOpponentStatus() == "None" then
                        if useMove(hasPokemonWithMove(statusMove)["move"]) then return end
                    else
                        if useItem(typeBall) then return end
                    end
                else
                    if sendPokemon(hasUsablePokemonWithMove(statusMove)["id"]) then return end
                end
            else
                if isPokemonUsable(getActivePokemonNumber()) then
                    if useItem(typeBall) then return end
                else
                    if sendUsablePokemon() or sendAnyPokemon() or run() then return end
                end
            end
        end
    else
        if sendUsablePokemon() or sendAnyPokemon() or run() then return end
    end
end