--#################################################--
------------------- START OF SCRIPT-------------------
-- #################################################--


require "libs.util.collection"
require "libs.routing.pathing"

local Item = require "libs.game.enum.items"
local TeamManager = require "libs.team.manager"
local GameManager = require "libs.game.manager"
local ItemValue = require "libs.game.data.item_values"
local Ability = require "libs.game.enum.abilities"
local BattleManager = require "libs.battle.manager"
local pathfinder = require "externas.proshinepathfinder.pathfinder.movetoapp"
local map = nil

function onStart()
    healCounter = 0
    shinyCount = 0
    wildCount = 0
    matchCount = 0
    caughtPokemons = {}

    noSwitch = false
end

function onPause()
    printLog()
end

function onStop()
    printLog()
end

function onResume()
end

function onDialogMessage(message)
    if stringContains(message, "There you go, take care of them!") then
        healCounter = healCounter + 1
        safariOver = false
        log("You have visited the PokeCenter " .. healCounter .. " times.")
    end
end

function printLog()
    log("Info | " .. healCounter .. "\t\theals")
    log("Info | " .. matchCount .. "/" .. shinyCount .. "/" .. wildCount .. "\tmatching/shiny/wild  encounters")
    local catches = catchString()
    if catches ~= "\t" then
        log("Info | " .. catches .. "  catches")
    end
end

function catchString()
    local pokeStr = ""
    local catchesStr = ""
    for caughtPoke, catches in pairs(caughtPokemons) do
        if pokeStr ~= "" or catchesStr ~= "" then
            pokeStr = pokeStr .. "/"
            catchesStr = catchesStr .. "/"
        end

        pokeStr = pokeStr .. caughtPoke
        catchesStr = catchesStr .. catches
    end

    if #catchesStr == 1 then
        return catchesStr .. "\t\t" .. pokeStr
    end
    return catchesStr .. "\t" .. pokeStr
end


function onBattleMessage(wild)
    if stringContains(wild, "Success! You caught ") then
        local pke = wild:match("%b]["):sub(2, -2)

        if caughtPokemons[pke] then caughtPokemons[pke] = caughtPokemons[pke] + 1
        else caughtPokemons[pke] = 1 end

        failedRun = false
        canNotSwitch = false
        printLog()
    elseif stringContains(wild, "A Wild ") then
        wildCount = wildCount + 1

        if stringContains(wild, "SHINY ") then
            shinyCount = shinyCount + 1
        end

        for _, name in pairs(pokemonToCatch) do
            if stringContains(wild, name) then
                matchCount = matchCount + 1
            end
        end

    elseif stringContains(wild, "You have won the battle.") then
        failedRun = false
        canNotSwitch = false

    elseif stringContains(wild, "You failed to run away") or stringContains(wild, "$CantRun") then
        failedRun = true

    elseif stringContains(wild, "You can not switch this Pokemon") or stringContains(wild, "$NoSwitch") then
        canNotSwitch = true
    end
    for _, value in pairs(roleAbility) do
        if stringContains(wild, "is now " .. value) then
            roleMatched = true
            log("######ROLE ABILITY MATCHED!######")
            break
        end
    end
end





function updateFishing(list)
    -- Moves to a position and uses rod
    if getPlayerX() == list[1] and getPlayerY() == list[2] then
        return useItem(typeRod)
    else
        return moveToCell(list[1], list[2])
    end
end


function goToPath()
    local map = getMapName()
    if getMapName() ~= location then
        pathfinder.moveTo(map, location)

    elseif type(area) == "string" then
        area = area:upper()
        if area == "GRASS" then
            return moveToGrass()
        elseif area == "WATER" then
            return moveToWater()
        end

    elseif #area == 2 then
        return updateFishing(area)

    elseif #area > 4 then
        return moveToRandRect(area, minutesToMove)
    end
end

function startRole()
    if usedRole == false then
        if BattleManager.hasUsablePokemonWithMove("Role Play") then
            if getActivePokemonNumber() == BattleManager.hasUsablePokemonWithMove("Role Play") then
                if useMove("Role Play") then
                    usedRole = true
                end
            else
                if sendPokemon(BattleManager.hasUsablePokemonWithMove("Role Play")) then return end
            end
        else
            catch()
        end
    else
        if roleMatched == true then
            catch()
        else
            run()
        end
    end
end


function isTeamUsable()
    if not TeamManager.isUsable() then
        return false

    elseif useSync and not TeamManager.getSyncPkm(syncNature) then
        log("######No Usable " .. syncNature .. " Sync Pokemon. Using Pokecenter.######")
        return false

    elseif useRole and not BattleManager.hasUsablePokemonWithMove("Role Play") then
        log("######No Usable Pokemon With Role Play. Using Pokecenter.######")
        return false

    elseif useSwipe and not BattleManager.hasUsablePokemonWithMove("False Swipe") then
        log("######No Usable Pokemon With False Swipe. Using Pokecenter.######")
        return false
    end

    return true
end



function onPathAction()
    usedRole = false
    roleMatched = false
    canNotSwitch = false
    failedRun = false
    local map = getMapName()
    if buyBalls
        and getItemQuantity(typeBall) <= buyBallsAt
        and GameManager.restockItems(typeBall, buyBallAmount)
    then
        return true

    elseif useLeftovers
        and TeamManager.giveLeftoversTo(TeamManager.getFirstUsablePkm())
    then
        return true

    elseif not safariOver then
        if not isTeamUsable() then
            return  pathfinder.useNearestPokecenter(map)

        elseif not isTeamSorted() then
            return sortTeam()

        else
            return goToPath()
        end
    else
        log("###Safari Time Is Over, Using Pokecenter###")
        return pathfinder.useNearestPokecenter(map)
    end
end

--TODO: remove and use TeamManager
function sortTeam()
    if useSync and TeamManager.getSyncPkm(syncNature) then
        if TeamManager.getSyncPkm(syncNature) == 1 then
            return true
        else
            return swapPokemon(TeamManager.getSyncPkm(syncNature), 1)
        end
    end
    if not useSync and useRole and hasPokemonWithMove("Role Play") then
        if hasPokemonWithMove("Role Play") == 1 then
            return true
        else
            return swapPokemon(hasPokemonWithMove("Role Play"), 1)
        end
    end
    if not useSync and not useRole and useSwipe and hasPokemonWithMove("False Swipe") then
        if hasPokemonWithMove("False Swipe") == 1 then
            return true
        else
            return swapPokemon(hasPokemonWithMove("False Swipe"), 1)
        end
    end

    --replace with first usable pokemon
    for index = 1, getTeamSize() do
        if isPokemonUsable(index) and BattleManager.hasUsableAttack(index) then
            return swapPokemon(1, index)
        end
    end

    return false
end

function isTeamSorted()
    if useSync and TeamManager.getSyncPkm(syncNature) and TeamManager.getSyncPkm(syncNature) ~= 1 then
        return false

    elseif not useSync
        and useRole
        and hasPokemonWithMove("Role Play")
        and hasPokemonWithMove("Role Play") ~= 1
    then
        return false

    elseif not useSync and not useRole and
        useSwipe and hasPokemonWithMove("False Swipe") and hasPokemonWithMove("False Swipe") ~= 1 then
        return false
    end

    return useSync and getPokemonHealth(1) ~= 0 or isPokemonUsable(1)
end

function onBattleAction()
    log("DEBUG | -------------enter: onBattleAction-------------")
    local isEventPokemon = getOpponentForm() ~= 0

    -- Trainer Battle
    if not isWildBattle() then
        log("DEBUG | -------------trainer battle-------------")
        return attack() or sendUsablePokemon() or run()

        --wild battles
    elseif useRole
        and isOnList(getOpponentName(), pokemonToRole)
        and BattleManager.hasUsablePokemonWithMove("Role Play")
    then
        log("DEBUG | -------------roleplay-------------")
        startRole()

    elseif isOpponentShiny()
        or isEventPokemon
        or isOnList(getOpponentName(), pokemonToCatch)
        or (catchNotCaught and not isAlreadyCaught())
    then
        log("DEBUG | -------------catching-------------")
        return catch()

    elseif failedRun and canNotSwitch then
        log("###Failed Run & switch###")
        return BattleManager.useAnyAttack() or BattleManager.useAnyMove()

    elseif failedRun then
        log("###Failed Run###")
        return attack() or sendAnyPokemon()

    elseif canNotSwitch then
        log("###Can Not Switch###")
        return attack() or run()

    end

    log("DEBUG | -------------leave: onBattleAction-------------")
    return attack() or sendUsablePokemon() or run()
end

function catch()
    if isPokemonUsable(getActivePokemonNumber()) then
        if getOpponentHealthPercent() > throwHealth then
            if useSwipe and BattleManager.hasUsablePokemonWithMove("False Swipe") then
                if getActivePokemonNumber() == BattleManager.hasUsablePokemonWithMove("False Swipe") then
                    if useMove("False Swipe") then return end
                else
                    if sendPokemon(BattleManager.hasUsablePokemonWithMove("False Swipe")) then return end
                end
            elseif useStatus and BattleManager.hasUsablePokemonWithMove(statusMove) then
                if getActivePokemonNumber() == BattleManager.hasUsablePokemonWithMove(statusMove)["id"] then
                    if getOpponentStatus() == "None" then
                        if useMove(hasPokemonWithMove(statusMove)["move"]) then return end
                    else
                        if useItem(typeBall) then return end
                    end
                else
                    if sendPokemon(BattleManager.hasUsablePokemonWithMove(statusMove)["id"]) then return end
                end

            else
                if isPokemonUsable(getActivePokemonNumber()) then
                    if weakAttack() then return end
                else
                    if sendUsablePokemon() or sendAnyPokemon() or run() then return end
                end
            end

        else
            if useStatus and BattleManager.hasUsablePokemonWithMove(statusMove) then
                if getActivePokemonNumber() == BattleManager.hasUsablePokemonWithMove(statusMove)["id"] then
                    if getOpponentStatus() == "None" then
                        if useMove(TeamManager.getPkmWithMove()(statusMove)["move"]) then return end
                    else
                        if useItem(typeBall) then return end
                    end
                else
                    if sendPokemon(BattleManager.hasUsablePokemonWithMove(statusMove)["id"]) then return end
                end
            else
                if isPokemonUsable(getActivePokemonNumber()) then
                    if useItem(typeBall) then return end
                else
                    if sendUsablePokemon() or sendAnyPokemon() or run() then return end
                end
            end
        end
    else
        if sendUsablePokemon() or sendAnyPokemon() or run() then return end
    end
end