--enums
local Item = require "libs.game.enum.items"
local Stat = require "libs.game.enum.stats"
--libs
local BattleManager = require "libs.battle.manager"
require "libs.util.collection" --imports Set class


TeamManager = {}

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

    local aboveHealthTresholdTeam = 0

    for index = 1, getTeamSize() do
        local health = getPokemonHealthPercent(index)
        local pp = BattleManager.getPPofUsableAttacks(index)

        --no healing, if one poke has 50% health and at least 5pp (default values)
        if health > healthTresholdLast and pp > ppTreshhold then
            return false
        end

        --no healing, 2 or more have more then 20% health and at least 1pp each
        if health > healthTresholdTeam and pp > 0 then
            aboveHealthTresholdTeam = aboveHealthTresholdTeam + 1
        end
    end

    --need to account for the last one standing, so at least 2 have to be
    --above team health tresh hold
    return aboveHealthTresholdTeam > 1
end

--- @summary : fetches all pkm under given level cap
--- @param level_cap: upper level treshold, 100 by default
--- @type level_cap: integer
--- @return : list of team indexes of all pkm that can be leveled up
--- @type : table (list of integers)
function TeamManager.getPkmToLvl(level_cap)
    local pkm = {}

    for index = 1, getTeamSize() do
        if TeamManager.isPkmToLvl(index, level_cap) then table.insert(pkm, index) end
    end

    return pkm
end

--- @summary :
--- @param level_cap:
--- @type level_cap: integer
--- @param index:
--- @type index: integer
--- @return : True, if pkm is levelable | False, if not
--- @type : boolean
function TeamManager.isPkmToLvl(index, level_cap)
    local level_cap = level_cap or 100
    return getPokemonLevel(index) < level_cap
end

--- @summary : Checks if team has pkm to level, given the level_cap set
--- @param level_cap: upper level treshold, 100 by default
--- @type level_cap: integer
--- @return : True, if team has pkm that not have reached level_cap | False, otherwise
--- @type : boolean
function TeamManager.hasPkmToLvl(level_cap)
    return #TeamManager.getPkmToLvl(level_cap) > 0
end

--- @summary : Searches the lowest leveled pkm under given level_cap
--- @param level_cap: upper level treshold, 100 by default
--- @type level_cap: integer
--- @return : team index, of lowest leveled pkm under level_cap | nil, if none exists
--- @type : integer | nil
function TeamManager.getLowestPkmToLvl(level_cap)
    return TeamManager._getLowestPkmToLvl(TeamManager.getPkmToLvl())
end

--- @summary : Searches the lowest leveled pkm under given level_cap
--- @param level_cap: upper level treshold, 100 by default
--- @type level_cap: integer
--- @return : team index, of lowest leveled pkm under level_cap | nil, if none exists
--- @type : integer | nil
function TeamManager.getLowestUsablePkmToLvl(level_cap)
    return TeamManager._getLowestPkmToLvl(TeamManager.getUsablePkmToLvl())
end

function TeamManager._getLowestPkmToLvl(pkms)
    local index_min = nil
    for _, index in pairs(pkms) do
        index_min = index_min or index

        --didn't find a lambda syntax, pretty I saw one though
        --index_min = math.min(index, index_min)

        if getPokemonHealth(index) > 0 then
            local lvl = getPokemonLevel(index)
            local lvl_min = getPokemonLevel(index_min)

            if lvl < lvl_min then index_min = index end
        end
    end

    return index_min
end


--- @summary : Searches the lowest leveled pkm under given level_cap
--- @param level_cap: upper level treshold, 100 by default
--- @type level_cap: integer
--- @return : team index, of lowest leveled pkm under level_cap | nil, if none exists
--- @type : integer | nil
function TeamManager.getRndPkmToLvl(level_cap)
    if not TeamManager.hasPkmToLvl(level_cap) then return end

    local pkm = TeamManager.getPkmToLvl(level_cap)
end


--- @summary : fetches all pkm under given level cap, that are able to battle
--- @param level_cap: upper level treshold, 100 by default
--- @type level_cap: integer
--- @return : list of team indexes of all battle-ready pkm that can be leveled up
--- @type : table (list of integers)
function TeamManager.getUsablePkmToLvl(level_cap)
    local pkm = {}

    for _, index in pairs(TeamManager.getPkmToLvl(level_cap)) do
        if BattleManager.isUsable(index) then table.insert(pkm, index) end
    end

    return pkm
end

--- @summary : Checks if team has pkm to level, given the level_cap set, that are able to battle
--- @param level_cap: upper level treshold, 100 by default
--- @type level_cap: integer
--- @return : True, if team has battle-ready pkm that not have reached level_cap | False, otherwise
--- @type : boolean
function TeamManager.hasUsablePkmToLvl(level_cap)
    for _, _ in pairs(TeamManager.getUsablePkmToLvl(level_cap)) do return true end
end


--- @summary :
--- @return : 1-6, index of first sync pkm with matching nature | nil, if no team member matches
--- @type : integer | nil
function TeamManager.getSyncPkm(Nature)
    for i = 1, getTeamSize() do
        if getPokemonAbility(i) == Ability.SYNCHRONIZE
            and getPokemonNature(i) == Nature then return i
        end
    end
end

--- @summary :
--- @return : 1-6, index of first pkm with matching ability | nil, if no team member matches
--- @type : integer | nil
function TeamManager.getAbilityPkm(abilityName)
    for i = 1, getTeamSize() do
        if getPokemonAbility(i) == abilityName then return i end
    end
end

--- @summary :
--- @return : 1-6, index of first pkm with matching move | nil, if no team member matches
--- @type : integer | nil
function TeamManager.getMovePkm(moveName)
    for i = 1, getTeamSize() do
        if hasMove(i, moveName) then return i end
    end
end

function TeamManager.getUsableMovePkm(moveName)
    local usablePkm = Set(TeamManager.getUsablePkm())
    --pokemon with specific move are probaly lesser
    for _, move_id in pairs(TeamManager.getMovePkm()) do
        if usablePkm[move_id] then return move_id end
    end
end

--- @summary :
--- @return : 1-6, index of first pkm holding matching item | nil, if no team member matches
--- @type : integer | nil
function TeamManager.getItemPkm(ItemName)
    for i = 1, getTeamSize() do
        if getPokemonHeldItem(i) == ItemName then return i end
    end
end


--- @summary : provides couverage for proShine's unused attacks
function TeamManager.getUsablePkm()
    local pkm = {}
    for index = 1, getTeamSize() do
        if isPokemonUsable(index)
            and BattleManager.hasUsableAttack(index) then
            table.insert(pkm, index)
        end
    end
    return pkm
end

function TeamManager.getUsablePkmCount()
    return #TeamManager.getUsablePkm()
end

function TeamManager.getFirstUsablePkm()
    if TeamManager.getUsablePkmCount() > 0 then
        return TeamManager.getUsablePkm()[1]
    end
end

function TeamManager.getStarterPkm()
    for index = 1, getTeamSize() do
        if getPokemonHealth(index) > 0 then return index end
    end
end

--assuming only one leftovers
--TODO: multiple leftovers
function TeamManager.giveLeftoversTo(PokemonNeedLeftovers)
    local PokemonWithLeftovers = TeamManager.getItemPkm(Item.LEFTOVERS)

    --hasItem(leftovers) |test if further leftovers are available


    if PokemonWithLeftovers then
        -- now leftovers is on rightpokemon
        if PokemonNeedLeftovers == PokemonWithLeftovers then return

            -- otherwise take leftover
        else return takeItemFromPokemon(PokemonWithLeftovers)
        end


    elseif hasItem(Item.LEFTOVERS) and getTeamSize() > 0 then
        --has leftovers and a team

        if PokemonNeedLeftovers >= 1 and PokemonNeedLeftovers <= getTeamSize() then
            return giveItemToPokemon(Item.LEFTOVERS, PokemonNeedLeftovers)
        end
    end
end

return TeamManager