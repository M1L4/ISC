
--#################################################--
-------------------CONFIGURATION-------------------
--#################################################--
--
local Map = require "libs.routing.enum.maps"

location = Map.VERMILION_POKECENTER
catchNotCaught =  true           --set true if you want to catch pokemon not listed as caught in your pokedex
fight = true                     --set true if you want to fight wild encounters on the way. false will run.

--#################################################--
----------------END OF CONFIGURATION-----------------
--#################################################--



require "manager.Universal_Travel"