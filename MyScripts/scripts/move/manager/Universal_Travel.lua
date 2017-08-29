name = "modified Universal Traveler - Crazy3001"
author = "m1l4"
description = "Press Start."


if not goToNearestPokecenter then
  goToNearestPokecenter =  false    --set true to use the nearest pokecenter
end

if not location then
  location =  ""
end

if not item or not amount then
  item = "" -- put the item you want to buy here
  amount = 0 -- put the amount of the item you want here
end


--#################################################--
----------------END OF CONFIGURATION-----------------
--#################################################--


--#################################################--
-------------------START OF SCRIPT-------------------
--#################################################--


local pf = require "libs.routing.proShinePathfinder.Pathfinder.MoveToApp"
local map = nil

function onStart()
  shinyCounter = 0
  catchCounter = 0
  wildCounter = 0
  if goToNearestPokecenter == true then
    log("Travelling to " .. getMapName(goToNearestPokecenter) .. ".")
  else
    log("Travelling to " .. location .. ".")
  end
end

function onPause()
  log("***********************************PAUSED************************************")
end

function onResume()
  log("***********************************RESUMED***********************************")
  if goToNearestPokecenter == true then
    log("Travelling to " .. getMapName(goToNearestPokecenter) .. ".")
  else
    log("Travelling to " .. location .. ".")
  end
end

function onBattleMessage(wild)
  if stringContains(wild, "A Wild SHINY ") then
    shinyCounter = shinyCounter + 1
    wildCounter = wildCounter + 1
    log("Info | Shinies Encountered: " .. shinyCounter)
    log("Info | Pokemon Caught: " .. catchCounter)
    log("Info | Pokemon Encountered: " .. wildCounter)
  elseif stringContains(wild, "Success! You caught ") then
    catchCounter = catchCounter + 1
    log("Info | Shinies Encountered: " .. shinyCounter)
    log("Info | Pokemon Caught: " .. catchCounter)
    log("Info | Pokemon Encountered: " .. wildCounter)
  elseif stringContains(wild, "A Wild ") then
    wildCounter = wildCounter + 1
    log("Info | Shinies Encountered: " .. shinyCounter)
    log("Info | Pokemon Caught: " .. catchCounter)
    log("Info | Pokemon Encountered: " .. wildCounter)
  elseif message == "You failed to run away!" then
    failedRun = true
  elseif message == "You can not switch this Pokemon!" then
    canNotSwitch = true
  end
end

function onPathAction()
  local map = getMapName()
  canNotSwitch = false
  failedRun = false

  if goToNearestPokecenter == true then
    pf.useNearestPokecenter(map)
    if getMapName(goToNearestPokecenter) == getMapName() then
    end
  elseif item and amount > 0 then
    if not pf.useNearestPokemart(map, item, amount) then
      fatal("Finished Buying Item.")
    end
  else
    pf.moveTo(map, location)
    if getMapName() == location then
    end
  end
end

function onBattleAction()
  if isWildBattle() and isOpponentShiny() or (catchNotCaught and not isAlreadyCaught()) then
    if useItem("Ultra Ball") or useItem("Great Ball") or useItem("Pokeball") then
      return
    end
  end
  if isWildBattle() then
    if isPokemonUsable(getActivePokemonNumber()) then
      if fight then
        return attack() or sendUsablePokemon() or run()
      else
        return run()
      end
    else
      return run() or sendUsablePokemon()
    end
  elseif canNotSwitch then
    canNotSwitch = false
    return attack() or run()
  else
    if failedRun then
      failedRun = false
      return sendUsablePokemon() or attack()
    else
      return run() or sendUsablePokemon()
    end
  end
  return run() or sendUsablePokemon()
end
