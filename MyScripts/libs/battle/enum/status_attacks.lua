local Attack = require "libs.battle.enum.attacks"


--catch rate: https://bulbapedia.bulbagarden.net/wiki/Catch_rate
-- sort status attack by preference
StatusAttack = {
    -- generall atk/move selection
    -- 1) no atk power
    -- 2) (no constraints)
    -- 3) accuracy decreasing


    --######sleep, freeze######
    -- catch treshhold 25

    -- sleep: https://bulbapedia.bulbagarden.net/wiki/Sleep_(status_condition):
    Attack.SPORE,           --100%  | immunities - type: grass | ability: overcoat | item: safety googles
    Attack.LOVELY_KISS,     --75%
    Attack.SLEEP_POWDER,    --75%   | immunities - type: grass | ability: overcoat | item: safety googles
    Attack.HYPNOSIS,        --60%
    Attack.DARK_VOID,       --50%
    Attack.GRASS_WHISTLE,   --55%   | immunities - ability: soundproof
    Attack.SING,            --55%   | immunities - ability: soundproof

    -- freeze: https://bulbapedia.bulbagarden.net/wiki/Freeze_(status_condition)
    -- all freeze moves have power, so none considered



    --######paralyze, burn, poison######
    -- catch treshhold 12

    -- paralysis: https://bulbapedia.bulbagarden.net/wiki/Paralysis_(status_condition)
    Attack.GLARE,       --100%
}

StatusAttacksWithCounters = {
    --sleep


    -- paralysis:
    Attack.STUN_SPORE,      --75% | immunities - type: grass | ability: overcoat | item: safety googles
    Attack.THUNDER_WAVE,    --90% | immunities - type: ground
}

return StatusAttack