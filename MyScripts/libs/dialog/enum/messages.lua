DialogMessage = {
    --regex expressions:
    --  ".-"        | any character, zero or more times, as few times as possible
    --  "[thea ]*"  | zero or more times, as many times as possible of those characters
    -- (.*)         | return any character at this position
    RECEIVED = "You .-received [thea ]*(.*)!",
    
    --regex expressions:
    --  (%d+)       | return any number here
    --  ([^!.]*)    | return any character except "!"
    FOUND = "You found (%d+) ([^!.]*)",


    BERRY_TREE = "Oh look, a (.*) tree.",
    HARVESTED = "You harvested (%d*) of them.",
    --    Info | dialog:

    --TODO: no buyed is being printed, probably expected to be known, since issued from script
    --    --buying
    --    Info | dialog: What would you like to buy today?
    --    What would you like to buy today?
    --    Shop opened:
    --    Pokeball ($200)
    --    Potion ($300)
    --    Repel ($350)
    --    Antidote ($100)
    --    Burn Heal ($250)
    --    Awakening ($200)
    --    Paralyze Heal ($200)
    --    Revive ($1500)
    --    Elixir ($1500)
    BUYED = "buyed",

    SHOP_OPENED = "What would you like to buy today?",

    PKM_CENTER_VISITED = "There you go, take care of them!",  --fits Seafoam B4F Nurse

    ON_ROAD_NURSE_VISITED = "Because I am having to transport healing items here, for use. I will have to ask for a small charge"
}

return DialogMessage