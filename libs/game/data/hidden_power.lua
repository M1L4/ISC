local Type = require "libs.game.enum.types"

--https://pokemon-revolution-online.net/Forum/viewtopic.php?f=123&t=63825&p=368117&hilit=leveling+guide#p368117
local HiddenPower = {
    --attention: this order has to be maintained
    [0] = Type.FIGHTING, --starting the table at 0, instead of 1
    Type.FLYING,
    Type.POISON,
    Type.GROUND,
    Type.ROCK,
    Type.BUG,
    Type.GHOST,
    Type.STEEL,
    Type.FIRE,
    Type.WATER,
    Type.GRASS,
    Type.ELECTRIC,
    Type.PSYCHIC,
    Type.ICE,
    Type.DRAGON,
    Type.DARK,
}

return {}