Attack = require "libs.battle.enum.attacks"

BattleManager = {}

--- failsafe function battlemanager.for battle, in the event where the last Pokemon is the active but API call attack() does not work.
-- This is due to his only move(s) with PP being not damaging type move(s).
function BattleManager.useAnyAttack()
    local pokemonId = getActivePokemonNumber()
    for i = 1, 4 do
        local moveName = getPokemonMoveName(pokemonId, i)
        if moveName and getRemainingPowerPoints(pokemonId, moveName) > 0 then
            log("Use any move")
            return useMove(moveName)
        elseif not moveName then
            log("useAnyAttack : moveName nil")
        end
    end
    return false
end

--- failsafe function even harsher
function BattleManager.useAnyMove()
    --TODO: implement ussage of items
    fatal("useAnyMove() not implemented yet...")
end


--- @summary : Checks if pokemon still has pp on a move, that does dmg.
--- @param teamIndex: accepted values: 1-6 | the pokemon position in team
--- @type teamIndex: integer
--- @return : true, if pokemon has usable dmg move | false, if not
--- @type : boolean
function BattleManager.hasUsableAttack(teamIndex)
    return BattleManager.getPPofUsableAttacks(teamIndex) > 0
end

--- @summary : Checks the pp count on all moves of a poke that do dmg.
--- @param teamIndex: accepted values: 1-6 | the pokemon position in team
--- @type teamIndex: integer
--- @return : the number of pp of all moves that do dmg of a poke
--- @type : integer
function BattleManager.getPPofUsableAttacks(teamIndex)
    local count = 0
    for i = 1, 4 do
        local moveName = getPokemonMoveName(teamIndex, i)
        --restrictions due to proshine's attack() implementation
        if moveName --if pkm has less than 4 moves
            and moveName ~= Attack.EXPLOSION --not used in proshine
            and moveName ~= Attack.SELF_DESTRUCT --not used in proshine
            and moveName ~= Attack.DOUBLE_EDGE --used with constraint, calculatable only during battle therefore left out
            -- constraint: Attack.DOUBLE_EDGE and getPokemonHealth(teamIndex) < getOpponentHealth() / 3

            --personal restriction
            and moveName ~= Attack.FALSE_SWIPE
            and moveName ~= Attack.DREAM_EATER  --needs a sleeping target to deal dmg
            and moveName ~= Attack.NIGHTMARE    --same

            --move restriction
            and getPokemonMovePower(teamIndex, i) > 0 then
                count = count + getRemainingPowerPoints(teamIndex, moveName)
        end
    end
    return count
end

function BattleManager.getPPofAllAttacks(teamIndex)
    local count = 0
    for i = 1, 4 do
        --if pkm has less than 4 moves
        local moveName = getPokemonMoveName(teamIndex, i)
        if moveName then count = count + getRemainingPowerPoints(teamIndex, moveName) end
    end
    return count
end



function BattleManager.isUsable(teamIndex)
    return isPokemonUsable(teamIndex)
        and BattleManager.hasUsableAttack(teamIndex)
end


--TODO: rework
--function BattleManager.hasUsablePokemonWithMove(Move)
--    hasUsablePokemonWithMove = {}
--    hasUsablePokemonWithMove["id"] = 0
--    hasUsablePokemonWithMove["move"] = nil
--    statusMoveList = { "glare", "stun spore", "thunder wave", "hypnosis", "lovely kiss", "sing", "sleep spore", "spore" }
--    if Move == statusMove then
--        for _, Move in pairs(statusMoveList) do
--            for i = 1, getTeamSize(), 1 do
--                if hasMove(i, Move) and getRemainingPowerPoints(i, Move) >= 1 and isPokemonUsable(i) then
--                    hasUsablePokemonWithMove["id"] = i
--                    hasUsablePokemonWithMove["move"] = Move
--                    return hasUsablePokemonWithMove, true
--                end
--            end
--        end
--    else
--        for i = 1, getTeamSize(), 1 do
--            if hasMove(i, Move) and getRemainingPowerPoints(i, Move) >= 1 and isPokemonUsable(i) then
--                return i, true
--            end
--        end
--    end
--    return false
--end

--function BattleManager.hasUsablePokemonWithMove(move)
--    for i = 1, BattleManager. do
--        if hasMove(i, move) and getRemainingPowerPoints(i, move) >= 1 and isPokemonUsable(i) then
--            return i, true
--        end
--    end
--end


return BattleManager