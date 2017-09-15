-- ---------
-- imports
-- ---------

local Pokemon = require "libs.game.enum.pokemons"
local Nature = require "libs.game.enum.natures"
local Item = require "libs.game.enum.items"
local Map = require "libs.routing.enum.maps"
local Ability = require "libs.game.enum.abilities"

local TeamManager = require "libs.team.manager"

require "scripts.catch.manager.basic"

--#################################################--
------------------- GLOBAL SETTINGS-------------------
-- #################################################--

name = "Basic Catcher"
author = "m1l4"
description = "Crazy3001' basic Catcher modification."


--Put in the pokemon you want to catch. Leave "" if none. Example: pokemonToCatch = {"Pokemon 1", "Pokemon 2", "Pokemon 3"}
pokemonToCatch = { Pokemon.ABRA } --If you have a pokemonToRole, don't put them here too, unless you want to catch that pokemon with any ability.
--##########################################################################################
--If you want to catch Pokemon that are not registered as caught in your Pokedex, set true.
catchNotCaught = true
--##########################################################################################
--Determines the percentage that the opponents health has to be to start throwing pokeballs. If using False Swipe, leave at 1.
throwHealth = 100
--##########################################################################################
--If fishing, what type of rod to use. (Old Rod, Good Rod, Super Rod)
typeRod = "Super Rod"
--##########################################################################################
--If set true, if you have Leftovers, it will give it to your lead Pokemon.--
useLeftovers = true
--##########################################################################################


--#################################################--
------------------- BALL SETTINGS-------------------
-- #################################################--


--Must be filled in. Determines what type of ball to use when catching, and what type to buy. Example: typeBall = "Pokeball"
typeBall = Item.POKEBALL
--Set true if you want to buy your type of ball when you get low.
buyBalls = true
--If buying balls, put in the amount of balls you want to have in your inventory.
buyBallAmount = 50
--Will buy more balls when your type of ball reaches X.
buyBallsAt = 15


--#################################################--
------------------- LOCATION SETTINGS-------------------
-- #################################################--


--Location you want to hunt. Example: location = "Dragons Den"
location = Map.ROUTE_6
--##########################################################################################
-- Put "Grass" for grass, "Water" for water, {x, y} for fishing cell, {x1, y1, x2, y2} for rectangle
-- If you're using a rectangle, you can set more rectangles to hunt in just by adding 4 more parameters. Example: area = {x1, y1, x2, y2, x1, y1, x2, y2}
area = "grass" --{84,35,84,38, 84,36,85,38, 81,38,85,38, 79,36,80,38, 81,34,83,34, 77,37,80,37, 31,34,31,31, 31,31,35,31, 39,27,40,29, 35,25,31,25, 29,30,32,32 } --"Grass"
-- If you're using multiple rectangles, this is the amount of time in minutes that we'll stay in one rectangle before moving to a different one
minutesToMove = 4


--#################################################--
------------------- TEAM SETTINGS-------------------
-- #################################################--


--##########################################################################################
--If using a Sync Pokemon, set true.
useSync = false
--Put in the nature of your All Day Sync Pokemon. Example: syncNature = "Adamant"
syncNature = Nature.CALM
--##########################################################################################
--If using Role Play, set true.
useRole = false
--If using Role Play, put in the abilities you want to catch. If not using, put "". You can have multiple Abilities/multiple Pokemon. Example: roleAbility = {"Ability 1", "Ability 2", "Ability 3"}
roleAbility = { "" }
--If using Role Play, put in the pokemon you want to Role. If not using, put "". You can have multiple Pokemon. Example: pokemonToRole = {"Pokemon 1", "Pokemon 2"}
pokemonToRole = { "" }
--##########################################################################################
--If using False Swipe, set true.
useSwipe = false
--##########################################################################################
--If using a Status Move, set true.
--Status Move List - {"glare", "stun spore", "thunder wave", "hypnosis", "lovely kiss", "sing", "sleep spore", "spore"}
useStatus = true


--#################################################--
---------------- END OF CONFIGURATION-----------------
-- #################################################--


_onStart = onStart
function onStart()
    local arenaTrapUser = TeamManager.getPkmWithAbility(Ability.ARENA_TRAP)
    if not arenaTrapUser then
        return fatal("Please add a Arena Trap Ability Pokemon to start hunt Abra")
    end

    return _onStart()
end

--when battle starts and we found an abra, put arena trapper in play
_onBattleAction = onBattleAction
function onBattleAction()
    local arenaTrapUser = TeamManager.getPkmWithAbility(Ability.ARENA_TRAP)
    if getOpponentName() == Pokemon.ABRA then
        if getActivePokemonNumber() ~= arenaTrapUser then
            return sendPokemon(arenaTrapUser)
        end
    end

    return _onBattleAction()
end

--search only with alive arena trapper
_isTeamUsable = isTeamUsable
function isTeamUsable()
    local arenaTrapUser = TeamManager.getPkmWithAbility(Ability.ARENA_TRAP)
    if getPokemonHealth(arenaTrapUser) <= 0 then
        log("######No Usable ArenaTrap Pokemon. Using Pokecenter.######")
        return false
    end

    return _isTeamUsable()
end

--use arena trapper only if needed = less time healing, when underleveled
_sortTeam = sortTeam
function sortTeam()
    local arenaTrapUser = TeamManager.getPkmWithAbility(Ability.ARENA_TRAP)
    if arenaTrapUser == 1 and #TeamManager.getUsablePkm() > 1 then
        return swapPokemon(arenaTrapUser, getTeamSize())
    end

    return _sortTeam()
end

_isTeamSorted = isTeamSorted
function isTeamSorted()
    local arenaTrapUser = TeamManager.getPkmWithAbility(Ability.ARENA_TRAP)
    if arenaTrapUser == 1 and #TeamManager.getUsablePkm() > 1 then
        return false
    end

    return _isTeamSorted()
end