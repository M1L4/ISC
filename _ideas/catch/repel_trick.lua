function onStart()
    repel = false
end

function onSystemMessage()
    if stringContains (repel, "worn off") then
        repel = false
    end
    if stringContains (repel, "Repel is already") then
        repel = true
    end
end

function onBattleMessage(wild)
    if stringContains(wild, "caught") then
        playSound("Assets/cuccu.wav")
    end
    if stringContains(wild, "SHINY") then
        playSound("Assets/charge.wav")
    end
end

function onPathAction()
    if isOutside() and hasItem("Bicycle") and not isSurfing() and not isMounted() then
        return useItem("Bicycle")
    end
    if isPrivateMessageEnabled() then
        return disablePrivateMessage()
    end
    if isTeamInspectionEnabled() then
        return  disableTeamInspection()
    end
    if getMapName() == "Pokecenter Pacifidlog Town" then
        if  getTeamSize() >=4 then
            if isPCOpen() then
                if isCurrentPCBoxRefreshed() then
                    return depositPokemonToPC(4)
                else
                    return
                end
            else
                return usePC()
            end

        else
            moveToMap("Pacifidlog Town")
        end
    elseif getMapName() == "Pacifidlog Town" then
        moveToMap("Route 132")
    elseif getMapName() == "Route 132" then
        moveToMap("Route 133")
    elseif getMapName() == "Route 133" then
        moveToMap("Route 134")
    elseif getMapName("Route 134") then
        if repel == false then
            repel = true
            useItem("Max Repel")
        elseif repel == true then
            moveToRectangle(7, 17, 13, 17)
        end
    else
        playSound("Assets/charge.wav")
        log("GM teleport")
        return  useItem("Escape Rope") or logout()
    end
end

function onBattleAction()
    if isOpponentShiny() or getOpponentName() == "Alomomola"  then
        if getActivePokemonNumber() == 1 then -- make the first poke die
            return useMove("Soak") or weakAttack() or attack() or   run() or sendAnyPokemon()
        elseif getActivePokemonNumber() == 2 then
            return sendPokemon(3) or useItem("Greatball") or useItem("Pokeball") or useItem("Ultraball")  or sendUsablePokemon()
        elseif getActivePokemonNumber() == 3  and ( getOpponentHealth() > 1 ) then
            return weakAttack() or useItem("Pokeball") or sendUsablePokemon() or run() or sendAnyPokemon()
        elseif ( getOpponentHealth() == 1 ) then
            return useItem("Great Ball") or useItem("Pokeball") or useItem("Ultraball") or sendUsablePokemon()
        else
            return useItem("Great Ball") or useItem("Pokeball") or useItem("Ultraball") or sendUsablePokemon()
        end
    elseif getTeamSize() == 6 then
        return relog(5,"Relogging...")
    elseif getOpponentLevel() <= 35 and getActivePokemonNumber() == 2 then
        repel = false
        return   run() or sendAnyPokemon()
    elseif not isPokemonUsable(3) or not isPokemonUsable(2) then
        return relog(5,"Relogging...")
    else
        log(getOpponentLevel())
        return useMove("Soak")  or   run() or sendAnyPokemon() or  attack()
    end
end