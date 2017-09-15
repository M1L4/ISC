
--#################################################--
-------------------CONFIGURATION-------------------
--#################################################--
--
local Map = require "libs.routing.enum.maps"
local Item = require "libs.game.enum.items"


catchNotCaught =  true           --set true if you want to catch pokemon not listed as caught in your pokedex
fight = true                     --set true if you want to fight wild encounters on the way. false will run.

item = Item.POKEBALL
amount = 200

--#################################################--
----------------END OF CONFIGURATION-----------------
--#################################################--



require "manager.Universal_Travel"
