name = "Abra Catcher"
Author = "Precious"
credits = "All most every credit goes to Zonz for giving me the hint about how to find Arena Trap,Synchronize Ability Pokemon in your team."
Description = [[It will catch Abra at Route 5 with sync ability and Arena Trap ability Pokemon. 
You can place them anywhere script will place them auto.]]

function onStart()
    abra_count = 0
    abraEncounter = 0
    wildCounter = 0
    shinyCounter = 0
end

function getPokemonWithAbility(abilityName)
    for i = 1, getTeamSize() do
        if getPokemonAbility(i) == abilityName then
            return i
        end
    end
    return nil
end

function onPathAction()
    if isPokemonUsable(1) then
        if getMapName() == "Pokecenter Cerulean" then
            moveToMap("Cerulean City")
        elseif getMapName() == "Cerulean City" then
            moveToCell(16, 50)
        elseif getMapName() == "Route 5" then
            moveToGrass()
        end
    else
        if getMapName() == "Route 5" then
            moveToCell(14, 0)
        elseif getMapName() == "Cerulean City" then
            moveToMap("Pokecenter Cerulean")
        elseif getMapName() == "Pokecenter Cerulean" then
            usePokecenter()
        end
    end
end

function onBattleAction()
    --switch in
    if getOpponentName() == "Abra" then
        playSound("Assets/moment.wav")

        --allows to switch arena trapper during hunt
        local arenaTrapUser = getPokemonWithAbility("Arena Trap")
        --only send Arena trapper if it isn't active battler and is still alive
        if getActivePokemonNumber() ~= arenaTrapUser and getPokemonHealth(arenaTrapUser) > 0 then
            return sendPokemon(arenaTrapUser)
        end
    end

    --catch
    if getOpponentName() == "Abra" or isOpponentShiny() then
        return useItem("Pokeball") or useItem("Great Ball") or useItem("Ultra Ball") or sendUsablePokemon()
    end

    --behaviour if no match
    return run() or sendUsablePokemon()
end

function onBattleMessage(message)
    if stringContains(message, " caught ") then
        playSound("Assets/whoo.wav")
        abra_count = abra_count + 1
    elseif stringContains(message, "Abra") then
        abraEncounter = abraEncounter + 1
    elseif stringContains(message, "A Wild") then
        wildCounter = wildCounter + 1
    elseif stringContains(message, "A Wild Shiny ") then
        wildCounter = wildCounter + 1
        shinyCounter = shinyCounter + 1
    end
end

function onPause()
    log("You have caught " .. abra_count .. " Abra's ")
    log("Abra encountered: " .. abraEncounter)
    log("Shinies Caught: " .. shinyCounter)
    log("Pokemons encountered: " .. wildCounter)
end