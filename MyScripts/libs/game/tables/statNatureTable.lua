local Stat = require "libs.game.enum.stats"
local Nature = require "libs.game.enum.natures"

--Stat-focused Table
--Access table[statToIncrease][statToDecrease]
local StatNatureTable = {
  [Stat.ATTACK] = {[Stat.ATTACK] = Nature.HARDY, [Stat.DEFENCE] = Nature.LONELY, [Stat.SPATTACK] = Nature.ADAMANT, [Stat.SPDEFENCE] = Nature.NAUGHTY, [Stat.SPEED] = Nature.BRAVE},
  [Stat.DEFENCE] = {[Stat.ATTACK] = Nature.BOLD, [Stat.DEFENCE] = Nature.DOCILE, [Stat.SPATTACK] = Nature.IMPISH, [Stat.SPDEFENCE] = Nature.LAX, [Stat.SPEED] = Nature.RELAXED},
  [Stat.SPATTACK] = {[Stat.ATTACK] = Nature.MODEST, [Stat.DEFENCE] = Nature.MILD, [Stat.SPATTACK] = Nature.BASHFUL, [Stat.SPDEFENCE] = Nature.RASH, [Stat.SPEED] = Nature.QUIET},
  [Stat.SPDEFENCE] = {[Stat.ATTACK] = Nature.CALM, [Stat.DEFENCE] = Nature.GENTLE, [Stat.SPATTACK] = Nature.CAREFUL, [Stat.SPDEFENCE] = Nature.QUIRKY, [Stat.SPEED] = Nature.SASSY},
  [Stat.SPEED] = {[Stat.ATTACK] = Nature.TIMID, [Stat.DEFENCE] = Nature.HASTY, [Stat.SPATTACK] = Nature.JOLLY, [Stat.SPDEFENCE] = Nature.NAIVE, [Stat.SPEED] = Nature.SERIOUSs},
}

return StatNatureTable