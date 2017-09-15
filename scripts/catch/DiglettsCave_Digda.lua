name = "Basic Catcher"
author = "Crazy3001"
description = "Make sure your configuration is done properly. Press Start."


--#################################################--
-------------------GLOBAL SETTINGS-------------------
--#################################################--

Pokemon = require"libs.game.enum.pokemons"
Map = require"libs.routing.enum.maps"

--Put in the pokemon you want to catch. Leave "" if none. Example: pokemonToCatch = {"Pokemon 1", "Pokemon 2", "Pokemon 3"}
pokemonToCatch = {Pokemon.DIGLETT, Pokemon.DUGTRIO} --If you have a pokemonToRole, don't put them here too, unless you want to catch that pokemon with any ability.
--##########################################################################################
--If you want to catch Pokemon that are not registered as caught in your Pokedex, set true.
catchNotCaught = false
--##########################################################################################
--Determines the percentage that the opponents health has to be to start throwing pokeballs. If using False Swipe, leave at 1.
throwHealth = 100
--##########################################################################################
--If fishing, what type of rod to use. (Old Rod, Good Rod, Super Rod)
typeRod = "Super Rod"
--##########################################################################################
--If set true, if you have Leftovers, it will give it to your lead Pokemon.--
useLeftovers = false
--##########################################################################################


--#################################################--
-------------------BALL SETTINGS-------------------
--#################################################--


--Must be filled in. Determines what type of ball to use when catching, and what type to buy. Example: typeBall = "Pokeball"
typeBall = "Pokeball"
--Set true if you want to buy your type of ball when you get low.
buyBalls = true
--If buying balls, put in the amount of balls you want to have in your inventory.
buyBallAmount = 50
--Will buy more balls when your type of ball reaches X.
buyBallsAt = 15


--#################################################--
-------------------LOCATION SETTINGS-------------------
--#################################################--


--Location you want to hunt. Example: location = "Dragons Den"
location = Map.DIGLETTS_CAVE
--##########################################################################################
-- Put "Grass" for grass, "Water" for water, {x, y} for fishing cell, {x1, y1, x2, y2} for rectangle
-- If you're using a rectangle, you can set more rectangles to hunt in just by adding 4 more parameters. Example: area = {x1, y1, x2, y2, x1, y1, x2, y2}
area = {50,57,53,57, 51,58,53,58, 54,55,54,58, 50,49,51,54, 51,49,54,49, 53,46,54,49, 47,46,50,46} --"Grass"

-- If you're using multiple rectangles, this is the amount of time in minutes that we'll stay in one rectangle before moving to a different one
minutesToMove = 4


--#################################################--
-------------------TEAM SETTINGS-------------------
--#################################################--


--##########################################################################################
--If using a Sync Pokemon, set true.
useSync = false
--Put in the nature of your All Day Sync Pokemon. Example: syncNature = "Adamant"
syncNature = ""
--##########################################################################################
--If using Role Play, set true.
useRole = false
--If using Role Play, put in the abilities you want to catch. If not using, put "". You can have multiple Abilities/multiple Pokemon. Example: roleAbility = {"Ability 1", "Ability 2", "Ability 3"}
roleAbility = {""}
--If using Role Play, put in the pokemon you want to Role. If not using, put "". You can have multiple Pokemon. Example: pokemonToRole = {"Pokemon 1", "Pokemon 2"}
pokemonToRole = {""}
--##########################################################################################
--If using False Swipe, set true.
useSwipe = false
--##########################################################################################
--If using a Status Move, set true.
--Status Move List - {"glare", "stun spore", "thunder wave", "hypnosis", "lovely kiss", "sing", "sleep spore", "spore"}
useStatus = true


--#################################################--
----------------END OF CONFIGURATION-----------------
--#################################################--

require "scripts.catch.manager.basic"