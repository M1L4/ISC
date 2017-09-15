--enums
local Item = require "libs.game.enum.items"
local Stat = require "libs.game.enum.stats"
local Ability = require "libs.game.enum.abilities"
--libs
local BattleManager = require "libs.battle.manager"
require "libs.util.collection" --imports Set class, and max() method

--|x, y| x + y is shorthand for function(x,y) return x+y end.


--comparers
local function maxLvl(a, b) return getPokemonLevel(b) >= getPokemonLevel(a) end     --**greater equal** is necesarry to avoid swaping same lvled pkm
local function minLvl(a, b) return getPokemonLevel(b) < getPokemonLevel(a) end      --lesser is necesarry to avoid swaping same lvled pkm
--misc
local function first(t) t = t or {} if #t > 0 then return t[1] end end
local function last(t) t = t or {} if #t > 0 then return t[#t] end end

TeamManager = {}
--pkm conditions
function TeamManager.isPkmAlive(i) return getPokemonHealth(i) > 0 end
function TeamManager.isPkmSync(i, nature) return TeamManager.hasPkmAbility(i, Ability.SYNCHRONIZE) and getPokemonNature(i) == nature end
function TeamManager.isPkmToLvl(i, lvl_cap) return getPokemonLevel(i) < lvl_cap end
function TeamManager.isPkmToLvlAlive(i, lvl_cap) return TeamManager.isPkmAlive(i) and TeamManager.isPkmToLvl(i, lvl_cap) end
function TeamManager.isPkmToLvlUsable(i, lvl_cap) return BattleManager.isUsable(i) and TeamManager.isPkmToLvl(i, lvl_cap) end
--pkm properties
function TeamManager.hasPkmItem(i, item) return getPokemonHeldItem(i) == item end
function TeamManager.hasPkmAbility(i, abilty) return getPokemonAbility(i) == abilty end
function TeamManager.hasPkmNature(i, nature) return getPokemonNature(i) == nature end
function TeamManager.hasPkmMove(i, move) return hasMove(i, move) end

--- @summary : healing conditions:
-- last poke under 50%hp
function TeamManager.isUsable(healthTresholdLast, healthTresholdTeam, ppTreshholdLast)
    --TODO: Bugfix or verify correct behavior
    -- seems to be running healing, when team is under healthTresholdTeam, but Last still full hp/pp

    --TODO: doesn't consider map level:
    -- 1) when underleveled last pkm may be one hitted
    -- 2) when underleveled run()-success rate lower
    -- > results in multiple blackouts until team level high enough again (loosing alot of money when capital is high),
    -- > since you lose 5% on every black out (against trainers only a single time though)

    local healthTresholdLast = healthTresholdLast or 50 --50% health
    local healthTresholdTeam = healthTresholdTeam or 20 --20%
    local ppTreshhold = ppTreshholdLast or 5

--    local aboveHealthTresholdTeam = 0
--
--    for index = 1, getTeamSize() do
--        local health = getPokemonHealthPercent(index)
--        local pp = BattleManager.getPPofUsableAttacks(index)
--
--        --no healing, if one poke has 50% health and at least 5pp (default values)
--        if health > healthTresholdLast and pp > ppTreshhold then
--            return false
--        end
--
--        --no healing, 2 or more have more then 20% health and at least 1pp each
--        if health > healthTresholdTeam and pp > 0 then
--            aboveHealthTresholdTeam = aboveHealthTresholdTeam + 1
--        end
--    end
--
--    --need to account for the last one standing, so at least 2 have to be
--    --above team health tresh hold
--    return aboveHealthTresholdTeam > 1

  --TODO: different healing grades: green - hunt, yellow - move towards pokecenter, red - flee from every battle

    --copied from pathfinder, seemd simple and efficient :D
    if getTeamSize() == 1                       -- a single pokemon has to be over 65 (only true for starters though)
        and getPokemonHealthPercent(1) <= 65

        or getUsablePokemonCount() <= 1         -- or we reached our last pkm
    then return false end

    --some personalizations
    local ppCount = 0
    for _, teamIndex in ipairs(TeamManager.getAlivePkm()) do
        ppCount = ppCount + BattleManager.getPPofAllAttacks(teamIndex)
    end

    return ppCount > 5 --at least 5pp to avoid being trapped

end

--- @summary : fetches all pkm under given level cap
--- @param level_cap: upper level treshold, 100 by default
--- @type level_cap: integer
--- @return : list of team indexes of all pkm that can be leveled up
--- @type : table (list of integers)
function TeamManager.getPkmToLvl(level_cap)
    return filter(TeamManager.getPkm(), TeamManager.isPkmToLvl, level_cap)
end

--- @summary : Searches the lowest leveled pkm under given level_cap
--- @param level_cap: upper level treshold, 100 by default
--- @type level_cap: integer
--- @return : team index, of lowest leveled pkm under level_cap | nil, if none exists
--- @type : integer | nil
function TeamManager.getLowestPkmToLvl(level_cap)
    return compare(TeamManager.getPkmToLvl(level_cap), minLvl)
end

function TeamManager.getAlivePkmToLvl(level_cap)
    return filter(TeamManager.getPkm(), TeamManager.isPkmToLvlAlive, level_cap)
end

function TeamManager.getLowestAlivePkmToLvl(level_cap)
--    log("DEBUG | nil: "..tostring(nil))
--    log("DEBUG | alivePkm: "..tostring(TeamManager.getAlivePkmToLvl(level_cap)))
    return compare(TeamManager.getAlivePkmToLvl(level_cap), minLvl)
end

--- @summary : Searches the lowest leveled pkm under given level_cap
--- @param level_cap: upper level treshold, 100 by default
--- @type level_cap: integer
--- @return : team index, of lowest leveled pkm under level_cap | nil, if none exists
--- @type : integer | nil
function TeamManager.getLowestUsablePkmToLvl(level_cap)
    return compare(TeamManager.getUsablePkmToLvl(), minLvl)
end

--- @summary : fetches all pkm under given level cap, that are able to battle
--- @param level_cap: upper level treshold, 100 by default
--- @type level_cap: integer
--- @return : list of team indexes of all battle-ready pkm that can be leveled up
--- @type : table (list of integers)
function TeamManager.getUsablePkmToLvl(level_cap)
    return filter(TeamManager.getUsablePkm(), TeamManager.isPkmToLvl, level_cap)
end

--- @summary : Searches the lowest leveled pkm under given level_cap
--- @param level_cap: upper level treshold, 100 by default
--- @type level_cap: integer
--- @return : team index, of lowest leveled pkm under level_cap | nil, if none exists
--- @type : integer | nil
function TeamManager.getRndPkmToLvl(level_cap)
    local pkmToLvl = TeamManager.getPkmToLvl(level_cap)
    if not pkmToLvl then return end

    return pkmToLvl[math.random(#pkmToLvl)]
end





function TeamManager.getAlivePkm()
    return filter(TeamManager.getPkm(), TeamManager.isPkmAlive)
end

function TeamManager.getFirstPkmAlive()
    return first(TeamManager.getAlivePkm())
end

---duplicate, but easy to understand
function TeamManager.getStarter()
    return TeamManager.getFirstPkmAlive()
end

function TeamManager.getLastPkmAlive()
    return last(TeamManager.getAlivePkm())
end

function TeamManager.getHighestPkmAlive()
    return compare(TeamManager.getAlivePkm(), maxLvl)
end

function TeamManager.getLowestPkmAlive()
    return compare(TeamManager.getAlivePkm(), minLvl)
end

function TeamManager.getPkm()
    local pkm = {}
    for index = 1, getTeamSize() do
        table.insert(pkm, index)
    end
    return pkm
end

--- @summary :
--- @return : 1-6, index of first sync pkm with matching nature | nil, if no team member matches
--- @type : integer | nil
function TeamManager.getSyncPkm(nature)
    return filter(TeamManager.getPkm(), TeamManager.isSyncPkm, nature)
end

function TeamManager.getFirstSyncPkm(nature)
    return first(TeamManager.getSyncPkm(nature))
end

--- @summary :
--- @return : 1-6, index of first pkm with matching ability | nil, if no team member matches
--- @type : integer | nil
function TeamManager.getPkmWithAbility(abilityName)
    return filter(TeamManager.getPkm(), TeamManager.hasPkmAbility, abilityName)
end

--- @summary :
--- @return : 1-6, index of first pkm with matching move | nil, if no team member matches
--- @type : integer | nil
function TeamManager.getPkmWithMove(moveName)
    return filter(TeamManager.getPkm(), TeamManager.hasPkmMove, moveName)
end

function TeamManager.getUsablePkmWithMove(moveName)
    return filter(TeamManager.getUsablePkm(), TeamManager.hasPkmMove, moveName)
end

function TeamManager.getFirstUsablePkmWithMove(moveName)
    return first(TeamManager.getUsablePkmWithMove(moveName))
end

--- @summary :
--- @return : 1-6, index of first pkm holding matching item | nil, if no team member matches
--- @type : integer | nil
function TeamManager.getPkmWithItem(itemName)
    return filter(TeamManager.getPkm(), TeamManager.hasPkmItem, itemName)
end


function TeamManager.getFirstPkmWithItem(itemName)
    return first(TeamManager.getPkmWithItem(itemName))
end

function TeamManager.getLastPkmWithItem(itemName)
    return last(TeamManager.getPkmWithItem(itemName))
end

--- @summary : provides couverage for proShine's unused attacks
function TeamManager.getUsablePkm()
    return filter(TeamManager.getPkm(), BattleManager.isUsable)
end

function TeamManager.getFirstUsablePkm()
    return first(TeamManager.getUsablePkm())
end


function TeamManager.giveLeftoversTo(leftoversTarget)
    --correct pkm already has leftovers
    if TeamManager.hasPkmItem(leftoversTarget, Item.LEFTOVERS) then return end

    --leftoversTarget not in team range
    if leftoversTarget < 1 or leftoversTarget > getTeamSize() then return end

    --remove item, if pkm is already holding one
    if getPokemonHeldItem(leftoversTarget) then takeItemFromPokemon(leftoversTarget) end

    --give leftovers if available
    if hasItem(Item.LEFTOVERS) then return  giveItemToPokemon(Item.LEFTOVERS, leftoversTarget) end

    --take leftovers if necessary | last because it allows starter to hold leftovers as well
    local pkmWithLeftovers = TeamManager.getLastPkmWithItem(Item.LEFTOVERS)
    if pkmWithLeftovers then return takeItemFromPokemon(pkmWithLeftovers) end
end


--TODO: getLowestLvlPkm
--add levelels, health, pp...

return TeamManager