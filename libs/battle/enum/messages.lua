--TODO: check messages
--TODO: your fainted or opponents
BattleMessage = {
    --earnings
    EXP = ".* gained (%d*) Exp",
    CAUGHT = "Success! You caught (.*)!",
    FOUND = "You found (%d+) ([^!.]*)",     --only pokedollars
    --TODO: GROWN = "Aron has grown to level 86"  --pkm level

    --losses
    THROW = "You throw a (.*).",
    GIVE = "You give ",

    --neutral
    WILD_ENCOUNTER = "A Wild (.*) Attacks!",
    SHINY_ENCOUNTER = "A Wild SHINY (.*) Attacks!",

    --TODO: test
    --messages with round progression
    --your actions
    PKM_FAINTED = "fainted",
    PKM_ATTACKED = "attacked",
    PKM_SWITCHED = "switched",
    ITEM_USED = "used",

    --opponent's actions
    OPPONENT_FAINTED = "fainted!",
    OPPONENT_ATTACKED = "attacks",
    OPPONENT_SWITCHED = "switches",
    OPPONENT_ITEM_USED = "uses",

    --battle terminating messages
    RUN = "$RunAway",
    WON = "won the battle.",
    LOST = "You black out!",

    --errors
    NO_SWITCH = "$NoSwitch",
    NO_RUN = "$CantRun",

}

return BattleMessage
