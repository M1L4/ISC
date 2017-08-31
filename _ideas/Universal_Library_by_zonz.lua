function onBattleAction()
	-- This is a default battle action that can be over-written by a script if desired
	if catchSpecial() then
		return
	end
	basicBattle()
end

function isEqual(t1, t2)
	local ty1 = type(t1)
	local ty2 = type(t2)
	
	if ty1 ~= ty2 then
		return false
	end
	
	if ty1 ~= "table" and ty2 ~= "table" then
		return t1 == t2
	end
	
	for k1, v1 in pairs(t1) do
		local v2 = t2[k1]
		if v2 == nil or not isEqual(v1, v2) then
			return false
		end
	end
	
	for k2, v2 in pairs(t2) do
		local v1 = t1[k2]
		if v1 == nil or not isEqual(v1, v2) then
			return false
		end
	end
	return true
end

function tableLength(tab)
	local count = 0
	for k in pairs(tab) do
		count = count + 1
	end
	return count
end

function tableAdd(t1, t2)
	local new = {}
	for k, v in pairs(t1) do
		new[k] = v
	end
	for k, v in pairs(t2) do
		if new[k] then
			if type(new[k]) == type(v) then
				if type(v) == "string" then
					new[k] = new[k] .. v
				elseif type(v) == "number" then
					new[k] = new[k] + v
				elseif type(v) == "table" then
					new[k] = tableAdd(new[k], v)
				else
					error("Tables to add contain an invalid type: " .. type(v))
				end
			else
				error("Tables to add contain inequal types")
			end
		else
			new[k] = v
		end
	end
	return new
end

function tableConcat(t1, t2)
	local new = {}
	for k, v in pairs(t1) do
		new[k] = v
	end
	for k, v in pairs(t2) do
		if new[k] then
			if type(k) == "string" then
				new["_" .. k] = v
			else
				new[#new + 1] = v
			end
		else
			new[k] = v
		end
	end
	return new
end

local meta = {__index = table, __len = tableLength, __add = tableAdd, __eq = isEqual, __concat = tableConcat}

function indexedTable(t)
	return setmetatable(t or {}, meta)
end

expGains = indexedTable{}
startMoney = 0
savedServer = "None"
savedName = "Unknown"
startTime = 0
savedTime = false

function libStart()
	startMoney = getMoney()
	savedServer = getServer()
	savedName = getAccountName()
	
	if not savedTime then -- Saves startTime variable only when starting the script the first time, to show correct time after sequential script stops/relogging
		savedTime = true
		startTime = os.time()
	end
end

function libStop()
	saveExp(expGains)
	for k, v in pairs(expGains) do
		log(k .. " gained a total of " .. v .. " Exp.")
	end
	expGains:clear()
	if getServer() ~= "None" and getMoney() - startMoney > 0 then
		log("You gained " .. getMoney() - startMoney .. " Pokedollars.")
		saveMoney(getMoney() - startMoney)
	end
	log("Bot running time: " .. string.format("%02i", (os.difftime(os.time(), startTime) / 3600)) .. ":" .. string.format("%02i", ((os.difftime(os.time(), startTime) % 3600) / 60)))
end

function libPause()
	for k, v in pairs(expGains) do
		log(k .. " has gained a total of " .. v .. " Exp.")
	end
	if getMoney() - startMoney > 0 then
		log("You have gained " .. getMoney() - startMoney .. " Pokedollars.")
	end
	log("Bot running time: " .. string.format("%02i", (os.difftime(os.time(), startTime) / 3600)) .. ":" .. string.format("%02i", ((os.difftime(os.time(), startTime) % 3600) / 60)))
end

function libResume()
end

loggedName = false
forceWeakMove = false
currentPokemonHealth = 0
currentOpponentHealth = 0

function libPathAction()
	loggedName = false
	forceWeakMove = false
	currentPokemonHealth = 0
	currentOpponentHealth = 0
end

timerSwitch = false
function timer(delay)
	timerSwitch = true
	invoke(timer, delay, delay)
end

options = {}
textOptions = {}
saveOptions = false
optionChanged = false -- Global value

function libUpdate()
	
	if getOption("Force new line") then
		setOption("Force new line", false)
		cancelInvoke(randomTimer)
		randomTimer(averageTimeBetweenSwitches, 20)
	end
	
	if saveOptions then
		local optionCount = getOptionCount()
		local textCount = getTextOptionCount()
		local save = false
		if #options < optionCount then
			for i = 1, optionCount do
				options[i] = getOption(i)
			end
			save = true
		end
		if #textOptions < textCount then
			for i = 1, textCount do
				textOptions[i] = getTextOption(i)
			end
			save = true
		end
		for i = 1, optionCount do
			if options[i] ~= getOption(i) then
				optionChanged = true
				options[i] = getOption(i)
				save = true
			end
		end
		for i = 1, textCount do
			if textOptions[i] ~= getTextOption(i) then
				textOptions[i] = getTextOption(i)
				save = true
			end
		end
		if save then
			saveOptionsToFile()
		end
	end
end

function libDialogMessage(message)
	if message:find("heal your Pokemon?") and getOption("Force Heal") then
		setOption("Force Heal", false)
	end
end

function libBattleMessage(message)
	local index = message:find("gained")
	if index then
		local name = message:sub(1, index - 2)
		local expGained = tonumber((message:gsub(name .. " gained ", ""):gsub(" Exp.", "")))
		if expGains:containsKey(name) then
			expGains[name] = expGains[name] + expGained
		else
			expGains[name] = expGained
		end
	end
	if message:find("Success! You caught ") and isOpponentShiny() then
		saveShinyLog()
		playSound("Assets/fanfare.wav")
	end
	if message:find("absorbed") then
		forceWeakMove = true
	end
	if message:find("Come Back") then
		currentPokemonHealth = 0
		forceWeakMove = false
	end
	if message:find("The Opposing Trainer is changing Pokemon.") then
		loggedName = false
		currentOpponentHealth = 0
	end
	if message:find("fainted") and getPokemonHealth(getActivePokemonNumber()) > 0 then
		log(getPokemonName(getActivePokemonNumber()) .. " dealt " .. currentOpponentHealth .. " damage!")
	end	
	if message:find("Attacks") and not message:find("Attacks!") then		
		local current = getPokemonName(getActivePokemonNumber())
		local health = getPokemonHealth(getActivePokemonNumber())
		
		if currentOpponentHealth > getOpponentHealth() then
			log(current .. " dealt " .. currentOpponentHealth - getOpponentHealth() .. " damage!")
		end
		currentOpponentHealth = getOpponentHealth()
		
		if currentPokemonHealth > health then
			log("The opponent " .. getOpponentName() .. " dealt " .. currentPokemonHealth - health .. " damage!")			
		end
		currentPokemonHealth = health
	end
end

function libBattleAction()
	if not loggedName then
		loggedName = true
		log("Opponent " .. getOpponentName() .. " is level " .. getOpponentLevel() .. " with " .. getOpponentHealth() .. " HP.")
	end		
	if currentOpponentHealth == 0 then
		currentOpponentHealth = getOpponentHealth()
	end
	
	if currentPokemonHealth == 0 then
		currentPokemonHealth = getPokemonHealth(getActivePokemonNumber())
	end
end

registerHook("onStart", libStart)
registerHook("onStop", libStop)
registerHook("onPause", libPause)
registerHook("onResume", libResume)
registerHook("onPathAction", libPathAction)
registerHook("onUpdate", libUpdate)
registerHook("onDialogMessage", libDialogMessage)
registerHook("onBattleMessage", libBattleMessage)
registerHook("onBattleAction", libBattleAction)

local optionFileLocation
local slidersToSave
local textToSave

function loadOptions(fileName, sliderNumber, textNumber)
	saveOptions = true
	if fileName then
		optionFileLocation = fileName
	else
		fileName = getScriptName() .. ".txt"
	end
	if sliderNumber then
		slidersToSave = sliderNumber
	else
		sliderNumber = getOptionCount()
	end
	if textNumber then
		textToSave = textNumber
	else
		textNumber = getTextOptionCount()
	end
    file = readLinesFromFile("Script Options/" .. fileName)
    if #file ~= 0 then    
        for i = 1, sliderNumber do
            setOption(i, file[i] == "true")
        end        
        for i = 1, textNumber do
            setTextOption(i, file[i + sliderNumber] or "")
        end        
    end    
end

function saveOptionsToFile(fileName, sliderNumber, textNumber)
	fileName = fileName or optionFileLocation or getScriptName() .. ".txt"
	sliderNumber = sliderNumber or slidersToSave or getOptionCount()
	textNumber = textNumber or textToSave or getTextOptionCount()
    local text = {}
    for i = 1, sliderNumber do
        text[i] = tostring(getOption(i))
    end    
    for i = 1, textNumber do
        text[i + sliderNumber] = getTextOption(i)
    end
    logToFile("Script Options/" .. fileName, text, true)
end

function sleep(seconds)
	local t = os.clock()
	while t + seconds > os.clock() do end
end

function saveShinyLog()
	local file = indexedTable(readLinesFromFile("Shiny Count.txt"))
	local shinyFound = getOpponentName()
	local headerIndex, endIndex = file:indexOf("[" .. savedName .. " - " .. savedServer .. "]")
	if headerIndex then
		local containsName = false
		for i = headerIndex, endIndex do
			if file[i]:find(shinyFound) then
				containsName = true
				local number = tonumber(file[i]:sub(file[i]:find(": ") + 2))
				file[i] = shinyFound .. ": " .. number + 1
			end
		end
		if not containsName then
			file:insert(endIndex, shinyFound .. ": 1")
		end
	else
		if #file > 0 then
			file:insert("")
		end
		file:insert("[" .. savedName .. " - " .. savedServer .. "]")
		file:insert(shinyFound .. ": 1")
	end
	logToFile("Shiny Count.txt", file, true)
end

function saveExp()
	if expGains:count() == 0 then
		return
	end
	local file = indexedTable(readLinesFromFile("Exp Gained.txt"))
	local headerIndex, endIndex = file:indexOf("[" .. savedName .. " - " .. savedServer .. "]")
	if headerIndex then
		for poke, exps in pairs(expGains) do
			local containsName = false
			for i = headerIndex, endIndex do
				if file[i]:find(poke) and file[i]:sub(1, file[i]:find(": ") - 1) == poke then
					containsName = true
					local colon = file[i]:find(": ")
					local name = file[i]:sub(1, colon - 1)
					local Exp = tonumber(file[i]:sub(colon + 2))
					file[i] = name .. ": " .. Exp + exps
				end
			end
			if not containsName then
				file:insert(endIndex, poke .. ": " .. exps)
			end
		end
	else
		if #file > 0 then
			file:insert("")
		end
		file:insert("[" .. savedName .. " - " .. savedServer .. "]")
		for poke, exps in pairs(expGains) do
			file:insert(poke .. ": " .. exps)
		end	
	end
	logToFile("Exp Gained.txt", file, true)
end

function saveMoney(money)
	local file = indexedTable(readLinesFromFile("Money Gained.txt"))
	local headerIndex = file:indexOf("[" .. savedName .. " - " .. savedServer .. "]")
	if headerIndex then
		file[headerIndex + 1] = tonumber(file[headerIndex + 1]) + money
	else
		if #file > 0 then
			file:insert("")
		end
		file:insert("[" .. savedName .. " - " .. savedServer .. "]")
		file:insert(money)
	end
	logToFile("Money Gained.txt", file, true)
end

function print(...)
	local args
	if type(...) == "table" then
		args = ...
	else
		args = {...}
	end
	log(table.concat(args, args.del or args.delim or args.delimator or "  "))
end

lineswitch = false
function moveToLine(x1, y1, x2, y2)	
	if type(x1) == "table" then
		if x1[1] ~= x1[3] and x1[2] ~= x1[4] then
			return fatal("error with moveToLine: coordinates should be a straight line from each other", "Assets/error.wav")
		end
		if lineswitch then
			if getPlayerX() == x1[1] and getPlayerY() == x1[2] then
				lineswitch = not lineswitch
			else
				return moveToCell(x1[1], x1[2])
			end
		else
			if getPlayerX() == x1[3] and getPlayerY() == x1[4] then
				lineswitch = not lineswitch
			else
				return moveToCell(x1[3], x1[4])
			end
		end
	else
		if x1 ~= x2 and y1 ~= y2 then
			return fatal("error with moveToLine: coordinates should be a straight line from each other.", "Assets/error.wav")
		end
		if lineswitch then
			if getPlayerX() == x1 and getPlayerY() == y1 then
				lineswitch = not lineswitch
			else
				return moveToCell(x1, y1)
			end
		else
			if getPlayerX() == x2 and getPlayerY() == y2 then
				lineswitch = not lineswitch
			else
				return moveToCell(x2, y2)
			end
		end
	end	
end

function fightTrainers()
	local tempBattlers = getActiveBattlers()
	if tempBattlers[1] and not getMapName():find("Pokecenter") then
		if talkToNpcOnCell(tempBattlers[1].x, tempBattlers[1].y) then
			logOnce("Battling " .. tempBattlers[1].name .. " at " .. tempBattlers[1].x .. ", " .. tempBattlers[1].y)
			return true
		end
	end
	return false
end

function collectItems()	
	local tempItems = getDiscoverableItems()
	if tempItems[1] then
		if talkToNpcOnCell(tempItems[1].x, tempItems[1].y) then
			logOnce("Collecting item at " .. tempItems[1].x .. ", " .. tempItems[1].y)
			return true
		end
	end
	
	local tempBerries = getActiveBerryTrees()
	if tempBerries[1] then
		if talkToNpcOnCell(tempBerries[1].x, tempBerries[1].y) then
			logOnce("Collecting berries at " .. tempBerries[1].x .. ", " .. tempBerries[1].y)
			return true
		end
	end
	
	return false
end

function headbuttTrees()
	local tempTrees = getActiveHeadbuttTrees()
	if tempTrees[1] then
		local tempHeadbutter = findExternalMoveUser("Headbutt")
		if tempHeadbutter then
			if talkToNpcOnCell(tempTrees[1].x, tempTrees[1].y) then
				logOnce("Headbutting tree at " .. tempTrees[1].x .. ", " .. tempTrees[1].y)
				pushDialogAnswer(tempHeadbutter)			
				return true
			end
		end
	end
	return false
end

function useDigSpots()
	local tempDigspots = getActiveDigSpots()
	if tempDigspots[1] then
		local tempDigger = findExternalMoveUser("Dig")
		if tempDigger then
			if talkToNpcOnCell(tempDigspots[1].x, tempDigspots[1].y) then
				logOnce("Digging the spot at " .. tempDigspots[1].x .. ", " .. tempDigspots[1].y)
				pushDialogAnswer(tempDigger)
				return true
			end
		end
	end
	return false
end

validNpcs = indexedTable{11, 42, 43, 44, 45, 49, 50, 51, 52, 55, 56, 57, 58, 59, 60, 61, 62, 63, 70, 71, 101, 119}

function getFilteredItems(includeTrainers, includeHeadbutt)
	local npcs = indexedTable(getNpcData())
	local tempHeadbutter = findExternalMoveUser("Headbutt")
	local tempDigger = findExternalMoveUser("Dig")
	
	for i = #npcs, 1, -1 do
		local npc = npcs[i]
		if ((not validNpcs:contains(npc.type) and not npc.canBattle)
			or (npc.type == 101 and (not includeHeadbutt or not tempHeadbutter))
			or (npc.type == 11 and npc.los >= 100)
			or (npc.type == 119 and
				((getRegion() == "Kanto" and not hasItem("Earth Badge")) or
				(getRegion() == "Johto" and not hasItem("Rising Badge")) or
				(getRegion() == "Hoenn" and not hasItem("Rain Badge"))))
			or (npc.name == "Digspot" and not tempDigger)
			or (npc.canBattle and (not includeTrainers or getMapName():find("Pokecenter")))
			or not canMoveToCell(npc.x, npc.y))
		then		
			npcs:remove(i)
		end
	end
	
	if #npcs == 0 then
		return false
	end
	
	local lowestDistance = 9999
	local index
	
	for i, npc in pairs(npcs) do
		local distance = getPathLength(npc.x, npc.y)
		if distance > -1 and distance < lowestDistance then
			lowestDistance = distance
			index = i
		end
	end
	
	if not index then
		logOnce("error with getFilteredItems: no target")
		return false
	end
	
	local npc = npcs[index]
	
	if npc.isBerry and talkToNpcOnCell(npc.x, npc.y) then
		logOnce("Collecting " .. npc.name .. " berries at " .. npc.x .. ", " .. npc.y .. ".")
		return true
	end
	
	if npc.canBattle and talkToNpcOnCell(npc.x, npc.y) then
		if npc.name == "" then
			npc.name = "[Unknown]"
		end
		logOnce("Battling " .. npc.name .. " at " .. npc.x .. ", " .. npc.y .. ".")
		return true
	end
	
	if npc.type == 11 and talkToNpcOnCell(npc.x, npc.y) then
		logOnce("Collecting item at " .. npc.x .. ", " .. npc.y .. ".")
		return true
	end
	
	if npc.type == 101 and talkToNpcOnCell(npc.x, npc.y) then
		logOnce("Headbutting tree at " .. npc.x .. ", " .. npc.y .. " with " .. getPokemonName(tempHeadbutter) .. ".")
		pushDialogAnswer(tempHeadbutter)
		return true
	end
	
	if npc.name == "Digspot" and talkToNpcOnCell(npc.x, npc.y) then
		logOnce("Digging spot at " .. npc.x .. ", " .. npc.y .. " with " .. getPokemonName(tempDigger) .. ".")
		pushDialogAnswer(tempDigger)
		return true
	end
	
	if npc.type == 63 and talkToNpcOnCell(npc.x, npc.y) then
		logOnce("Comforting abandoned Pokemon at " .. npc.x .. ", " .. npc.y .. ".")
		return true
	end
	
	if npc.type == 119 and talkToNpcOnCell(npc.x, npc.y) then
		logOnce("Talking to the PokeStop guy at " .. npc.x .. ", " .. npc.y .. ".")
		return true
	end
	
	if talkToNpcOnCell(npc.x, npc.y) then
		logOnce("Activating unknown NPC named " .. npc.name .. " at " .. npc.x .. ", " .. npc.y .. ". Type: [" .. npc.type .. "] Los: [" .. npc.los .. "]")
		return true
	end
	
	return false
end

function mergeTables(t1, t2)
	for k, v in pairs(t2) do
		t1[#t1 + 1] = v
	end
end

function findExternalMoveUser(moveName)
	for i = 1, getTeamSize() do
		if hasMove(i, moveName) and getPokemonHappiness(i) > 200 then
			return i
		end
	end
	return nil
end

function basicBattle(kill, swap)
	if swap then
		return swapBattle(kill)
	end
	if isWildBattle() and not kill then
		return run() or sendAnyPokemon()
	end
	if getOpponentHealth() == 1 then
		return weakAttack() or run() or sendAnyPokemon()
	end
	return attack() or run() or sendAnyPokemon()
end

function swapBattle(kill, upperLimit)
	local index = getHighestLevel(upperLimit)
	if getActivePokemonNumber() ~= index then
		return sendPokemon(index) or run() or sendUsablePokemon()
	elseif isWildBattle() and not kill then
		return run() or sendAnyPokemon()
	end
	return attack() or run() or sendAnyPokemon()
end

function catchSpecial(uncaught)
	if isWildBattle() and (isOpponentShiny() or getOpponentForm() ~= 0 or (uncaught and not isAlreadyCaught())) and (hasItem("Pokeball") or hasItem("Great Ball") or hasItem("Ultra Ball")) then
		if getOpponentName() == "Abra" or getOpponentName() == "Magikarp" then
			return useItem("Ultra Ball") or useItem("Great Ball") or useItem("Pokeball") or run() or sendAnyPokemon()
		end
		local tempSwiper = findUsablePokemonWithMove("False Swipe")
		local sporeUser = findUsablePokemonWithMove("Spore")
		if tempSwiper then
			if getActivePokemonNumber() ~= tempSwiper and sendPokemon(tempSwiper) then
				return true
			elseif getOpponentHealthPercent() > 30 and useMove("False Swipe") then
				return true
			elseif sporeUser and getOpponentStatus() == "" then
				if getActivePokemonNumber() ~= sporeUser and sendPokemon(sporeUser) then
					return true
				elseif useMove("Spore") or run() or sendAnyPokemon() then
					return true
				end
			elseif useItem("Pokeball") or useItem("Great Ball") or useItem("Ultra Ball") or run() or sendAnyPokemon() then
				return true
			end
		end
		local index = getLowestLevel()
		if getActivePokemonNumber() ~= index and sendPokemon(index) then
			return true
		elseif getOpponentLevel() / getPokemonLevel(index) < 0.75 and (useItem("Pokeball") or useItem("Great Ball") or useItem("Ultra Ball")) then
			return true
		elseif getOpponentHealthPercent() > 50 and weakAttack() then
			return true
		elseif useItem("Pokeball") or useItem("Great Ball") or useItem("Ultra Ball") or run() or sendAnyPokemon() then
			return true
		end
	end
	return false
end

function attemptCatch(...)
	names = indexedTable({...})
	if not names:contains(getOpponentName()) then
		return false
	end
	
	if not hasItem("Pokeball") and not hasItem("Great Ball") and not hasItem("Ultra Ball") then
		return false
	end
	
	if isWildBattle() then
		if getOpponentName() == "Abra" then
			if useItem("Ultra Ball") or useItem("Great Ball") or useItem("Pokeball") or run() or sendAnyPokemon() then
				return true
			end
		end
		local tempSwiper = findUsablePokemonWithMove("False Swipe")
		if tempSwiper then
			if getActivePokemonNumber() ~= tempSwiper and sendPokemon(tempSwiper) then
				return true
			elseif getOpponentHealthPercent() > 30 and useMove("False Swipe") then
				return true
			elseif useItem("Pokeball") or useItem("Great Ball") or useItem("Ultra Ball") or run() or sendAnyPokemon() then
				return true
			end
		end
		local index = getLowestLevel()
		if getActivePokemonNumber() ~= index and sendPokemon(index) then
			return true
		elseif getOpponentHealthPercent() > 50 and weakAttack() then
			return true
		elseif useItem("Pokeball") or useItem("Great Ball") or useItem("Ultra Ball") or run() or sendAnyPokemon() then
			return true
		end
	end
	return false
end

function getLowestLevel()
	level = 100
	index = 1
	
	for i = getTeamSize(), 1, -1 do
		if getPokemonLevel(i) <= level and isPokemonUsable(i) then
			level = getPokemonLevel(i)
			index = i
		end
	end
	
	return index	
end

function getHighestLevel(upperLimit)
	level = 1
	index = 1
	
	for i = upperLimit or getTeamSize(), 1, -1 do
		if getPokemonLevel(i) >= level and isPokemonUsable(i) then
			level = getPokemonLevel(i)
			index = i
		end
	end
	
	return index	
end

function findUsablePokemonWithMove(moveName)
	for i = 1, getTeamSize() do
		if hasMove(i, moveName) and getRemainingPowerPoints(i, moveName) > 0 and getPokemonHealth(i) > 0 then
			return i
		end
	end
	return nil
end

function findMove(moveName)
	for i = 1, getTeamSize() do
		if hasMove(i, moveName) then
			return i
		end
	end
	return nil
end

function findSync(nature)
	for i = 1, getTeamSize() do
		if getPokemonNature(i):upper() == nature:upper() and getPokemonAbility(i) == "Synchronize" then
			return i
		end
	end
	return nil
end

function findSyncWithRoleplay(nature)
	for i = 1, getTeamSize() do
		if getPokemonNature(i):upper() == nature:upper() and getPokemonAbility(i) == "Synchronize" and hasMove(i, "Role Play") then
			return i
		end
	end
	return nil
end

function findUsableSyncWithRoleplay(nature)
	for i = 1, getTeamSize() do
		if getPokemonNature(i):upper() == nature:upper() and getPokemonAbility(i) == "Synchronize" and hasMove(i, "Role Play") and getPokemonHealth(i) > 0 then
			return i
		end
	end
	return nil
end

function findUniqueIdInParty(Id)
	for i = 1, getTeamSize() do
		if getPokemonUniqueId(i) == Id then
			return i
		end
	end
	return nil
end

function getUniqueIdByName(name)
	for i = 1, getTeamSize() do
		if getPokemonName(i) == name then
			return getPokemonUniqueId(i)
		end
	end
	return nil
end

function arePokemonUsable(...)
	for _, p in pairs({...}) do
		if not isPokemonUsable(p) then
			return false
		end
	end
	return true
end

function lastMap()
	if Path == nil then
		return fatal("Please define the Path table")
	end
	if getMapName() == Path[#Path] then
		return true
	end
	logOnce(getMapName() .. " -> " .. Path[getPathIndex() + 1])
	moveToMap(Path[getPathIndex() + 1])
end

function firstMap()
	if Path == nil then
		return fatal("Please define the Path table")
	end
	if getMapName() == Path[1] then
		return true
	end
	logOnce(getMapName() .. " -> " .. Path[getPathIndex() - 1])
	moveToMap(Path[getPathIndex() - 1])
end

function getPathIndex()
	for i = 1, #Path do
		if getMapName() == Path[i] then
			return i
		end
	end
	fatal("error: current map is not present in the Path table.")
end

lastLogged = ""
function logOnce(str)
	if lastLogged ~= str then
		log(str)
		lastLogged = str
	end
end

lastLogged2 = ""
function logOnce2(str)
	if lastLogged2 ~= str then
		log(str)
		lastLogged2 = str
	end
end

pcUsed = false
currentBoxId = 1
function retrievePokemon(name, slot)
	
	slot = slot or 6
	
	if type(name) == "table" then
		retrieveSpecial(name, slot)
		return
	end
	
	if not name or name == "" then
		return fatal("Please define the name of the Pokemon you wish to search for.")
	end
	
	if not isPCOpen() and not usePC() then
		return fatal("PC not found")
	end
	
	if isPCOpen() and isCurrentPCBoxRefreshed() then
	
		if currentBoxId > getPCBoxCount() then
			currentBoxId = 1
			pcUsed = true
			log(name .. " not found.")
			return
		end
		
		if getCurrentPCBoxId() == currentBoxId then
			log("Checking box " .. currentBoxId .. "...")
			for i = 1, getCurrentPCBoxSize() do
				if getPokemonNameFromPC(currentBoxId, i) == name then
					local text = name .. " found. "
					if getTeamSize() < 6 and slot > getTeamSize() then
						withdrawPokemonFromPC(currentBoxId, i)
						text = text .. " Withdrawing."
					else
						swapPokemonFromPC(currentBoxId, i, slot)
						text = text .. " Swapping with " .. getPokemonName(slot) .. " in slot " .. slot .. "."
					end
					log(text)
					pcUsed = true
					currentBoxId = 1
					return
				end
			end
		end
		
		currentBoxId = currentBoxId + 1
		
		return openPCBox(currentBoxId)
	end
end

function retrieveSpecial(creds, slot)

	-- Usage:	
	-- retrievePokemon({name = "pokeName", shiny = true, ability = "Sturdy", etc.})
	
	
	if not creds.name or creds.name == "" then
		return fatal("Please define the name of the Pokemon you wish to search for.")
	end
	
	if not isPCOpen() and not usePC() then
		return fatal("PC not found")
	end
	
	if isPCOpen() and isCurrentPCBoxRefreshed() then
	
		if currentBoxId > getPCBoxCount() then
			currentBoxId = 1
			pcUsed = true
			log(creds.name .. " with specified credential(s) not found.")
			return
		end
		
		if getCurrentPCBoxId() == currentBoxId then
			log("Checking box " .. currentBoxId .. "...")
			for i = 1, getCurrentPCBoxSize() do
				if getPokemonNameFromPC(currentBoxId, i) == creds.name
				and (not creds.shiny or isPokemonFromPCShiny(currentBoxId, i))
				and (not creds.level or getPokemonLevelFromPC(currentBoxId, i) >= creds.level)
				and (not creds.ability or getPokemonAbilityFromPC(currentBoxId, i) == creds.ability)
				and (not creds.nature or getPokemonNatureFromPC(currentBoxId, i) == creds.nature)
				and (not creds.region or getPokemonRegionFromPC(currentBoxId, i) == creds.region)
				then
					local text = creds.name .. " found. "
					if getTeamSize() < 6 and slot > getTeamSize() then
						withdrawPokemonFromPC(currentBoxId, i)
						text = text .. " Withdrawing."
					else
						swapPokemonFromPC(currentBoxId, i, slot)
						text = text .. " Swapping with " .. getPokemonName(slot) .. " in slot " .. slot .. "."
					end
					log(text)
					pcUsed = true
					currentBoxId = 1
					return
				end
			end
		end
		
		currentBoxId = currentBoxId + 1
		
		return openPCBox(currentBoxId)
	end
	
end

function chooseForgetMove(moveName, pokemonIndex, movePower, moveAcc, moveType, moveDType)
	if movesToKeep and movesToKeep:contains(moveName) then
		movePower = 99999
	end
	local pokeType = getPokemonType(pokemonIndex)
	local ForgetMoveTP = movePower * (math.abs(moveAcc) / 100)
	if pokeType[1] == moveType or pokeType[2] == moveType then
		ForgetMoveTP = ForgetMoveTP * 1.5
	end
	if moveDType == "Physical" then
		ForgetMoveTP = ForgetMoveTP * (getPokemonStat(pokemonIndex, "ATK") / 100)
	else
		ForgetMoveTP = ForgetMoveTP * (getPokemonStat(pokemonIndex, "SPATK") / 100)
	end
	-- log("Incoming new move: " .. moveName .. " - Power: " .. movePower .. " - ACC: " .. moveAcc .. " - Type: " .. moveType .. " - DType: " .. moveDType)
	for moveId = 1, 4 do
		local MoveName = getPokemonMoveName(pokemonIndex, moveId)
		if MoveName and (not movesToKeep or not movesToKeep:contains(moveName)) and MoveName ~= "Cut" and MoveName ~= "Surf" and MoveName ~= "Rock Smash" and MoveName ~= "Dive" and MoveName ~= "Role Play" and MoveName ~= "Headbutt" and (MoveName ~= "Sleep Powder" or hasItem("Plain Badge")) then
			local CalcMoveTP = getPokemonMovePower(pokemonIndex, moveId) * (math.abs(getPokemonMoveAccuracy(pokemonIndex, moveId)) / 100)
			if pokeType[1] == getPokemonMoveType(pokemonIndex, moveId):title() or pokeType[2] == getPokemonMoveType(pokemonIndex, moveId):title() then
				CalcMoveTP = CalcMoveTP * 1.5
			end
			if getPokemonMoveDamageType(pokemonIndex, moveId) == "Physical" then
				CalcMoveTP = CalcMoveTP * (getPokemonStat(pokemonIndex, "ATK") / 100)
			else
				CalcMoveTP = CalcMoveTP * (getPokemonStat(pokemonIndex, "SPATK") / 100)
			end
			if CalcMoveTP < ForgetMoveTP then
				ForgetMoveTP = CalcMoveTP
				moveName = MoveName
			end
		end
	end
	return moveName
end

function onLearningMove(moveName, pokemonIndex, movePower, moveAcc, moveType, moveDType)
	local moveToForget = chooseForgetMove(moveName, pokemonIndex, movePower, moveAcc, moveType, moveDType)
	if moveToForget ~= moveName then
		log(getPokemonName(pokemonIndex) .. ": [Learning Move: " .. moveName .. "  -->  Forgetting Move: " .. moveToForget .. "]")
		return forgetMove(moveToForget)
	else
		log(getPokemonName(pokemonIndex) .. ": [Ignoring new Move: " .. moveName .. "]")
	end
end

function giveItem(item, slot)
	
	if getPokemonHeldItem(slot) == item then
		return false
	end

	if hasItem(item) then
		log("Giving " .. item .. " to " .. getPokemonName(slot) .. ".")
		giveItemToPokemon(item, slot)
		return true
	else
		for i = getTeamSize(), 1, -1 do
			if getPokemonHeldItem(i) == item then
				log("Retrieving " .. item .. " from " .. getPokemonName(i) .. ".")
				takeItemFromPokemon(i)
				return true
			end
		end
	end
	return false
end

function string.title(str)
	return str:gsub("(%a)([%w_']*)", function(a,b) return a:upper() .. b:lower() end)
end

function string.split(str, delimiter)
    local result = {}
    for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

function string.replace(str, character, replacement)
	return str:gsub("%" .. character .. "+", replacement)
end

function string.startsWith(str, check)
   return str:sub(1, check:len()) == check
end

function string.insert(str, index, insertion)
	if str:len() == 0 then
		return insertion
	end
	local start = str:sub(1, index - 1)
	local ending = str:sub(index)
	return start .. insertion .. ending
end

function useMount(mount)
	if (getMapName() == "Blackthorn City" and isInRectangle(26, 5, 28, 7))
	or (getMapName() == "Route 20" and isInRectangle(70, 37, 79, 42))
	or (getMapName() == "Sootopolis City" and isInRectangle(42, 64, 54, 72))
	then
		return false
	end
	mount = mount or "Bicycle"
    if not hasItem(mount) or isMounted() or isSurfing() or not isOutside() then
        return false
    else
        log("Using: " .. mount)
        assert(useItem(mount), "Error using item: " .. mount .. ".")
        return true
    end
end

function isInRectangle(x1, y1, x2, y2)
	return getPlayerX() >= x1 and getPlayerY() >= y1 and getPlayerX() <= x2 and getPlayerY() <= y2
end

function table.contains(tab, value)
	for k, v in pairs(tab) do
		if v == value then
			return true
		end
	end
	return false
end

function table.tostring(tab)
	return table.toString(tab)
end

function table.toString(tab)
    local start = true
    local ret = "["
    for k, v in pairs(tab) do
        if start then
            start = false
        else
            ret = ret .. ", "
        end
        ret = ret .. "[" .. k .. "] = "
        if type(v) == "nil"
            then ret = ret .. "Nil"
        elseif type(v) == "string"
            then ret = ret .. "\""..v.."\""
        elseif type(v) == "function"
            then ret = ret .. "Function"
        elseif type(v) == "number"
            then ret = ret .. v
        elseif type(v) == "userdata"
            then ret = ret .. "Userdata"
        elseif type(v) == "thread"
            then ret = ret .. "Thread"
        elseif type(v) == "table" then
            if type(v.show) == "function" then
				ret = ret .. "(" .. tostring(v:tostring()) .. ")"
            else
				ret = ret .. table.toString(v)
            end
        elseif type(v) == "boolean"
            then if v
                 then ret = ret .. "True"
                 else ret = ret .. "False"
            end
        end
    end
    ret = ret .. "]"
    return ret
end

function table.containsKey(tab, key)
	for k in pairs(tab) do
		if k == key then
			return true
		end
	end
	return false
end

function table.indexOf(tab, fromVal, toVal)
	toVal = toVal or ""
	local index
	local endIndex -- Finds the first index of toVal after the first index of fromVal
	for k, v in pairs(tab) do
		if v == fromVal then
			index = k
			break
		end
	end
	if index then
		for i = index, #tab do
			if tab[i] == toVal then
				endIndex = i
				break
			end
		end
	end
	return index, endIndex or #tab
end

function table.sub(tab, startIndex, endIndex)
	endIndex = endIndex or #tab
	local newTab = indexedTable{}
	for i = startIndex, endIndex do
		newTab:insert(tab[i])
	end
	return newTab
end

function table.clone(tab)
	local newTab = {}
	for k, v in pairs(tab) do
		newTab[k] = v
	end
	return newTab
end

function table.merge(t1, t2)
	for k, v in pairs(t2) do
		t1[#t1 + 1] = v
	end
end

function table.clear(tab, replacement)
	-- If replacement is left out, will delete all keys
	for k in pairs(tab) do
		tab[k] = replacement
	end
end

function table.count(tab)
	local count = 0
	for _ in pairs(tab) do
		count = count + 1
	end
	return count
end

function getFirstAliveIndex()
	for i = 1, getTeamSize() do
		if getPokemonHealth(i) > 0 then
			return i
		end
	end
	return nil
end

function getFirstUsableIndex()
	for i = 1, getTeamSize() do
		if isPokemonUsable(i) then
			return i
		end
	end
	return nil
end

function getLastUsableIndex()
	for i = getTeamSize(), 1, -1 do
		if not isPokemonUsable(i) then
			return i - 1
		end
	end
	return getTeamSize()
end

function sortTeamByUsableAndLevel()
	return sortTeamRangeByUsableAndLevel(1, 6)
end

function sortTeamRangeByUsableAndLevel(from, to)
	from = from or 1
	to = to or getTeamSize()
	from = math.max(from, 1)
	to = math.min(to, getTeamSize())
	
	local usableCount = 0
	for i = from, to do
		if isPokemonUsable(i) then
			usableCount = usableCount + 1
		end
	end
	
	if usableCount == 0 then
		return false
	end
	
	for i = from, from + usableCount - 1 do
		if not isPokemonUsable(i) then
			for j = to, from, -1 do
				if isPokemonUsable(j) then
					log(getPokemonName(i) .. " is no longer usable. Swapping with " .. getPokemonName(j) .. ".")
					swapPokemon(i, j)
					return true
				end
			end
		end
	end
	
	for i = from, to do		
		currentIndex = i
		currentLevel = getPokemonLevel(i)
		
		for j = to, i + 1, -1 do -- j = i + 1, to do
			if getPokemonLevel(j) < currentLevel and isPokemonUsable(j) then
				currentIndex = j
				currentLevel = getPokemonLevel(j)
			end
		end
		
		if currentIndex ~= i and isPokemonUsable(i) then
			local difference = getPokemonLevel(i) - getPokemonLevel(currentIndex)
			if difference == 1 then
				log(getPokemonName(currentIndex) .. " is 1 level lower than " .. getPokemonName(i) .. ". Moving " .. getPokemonName(currentIndex) .. " to slot " .. i .. ".")
			else
				log(getPokemonName(currentIndex) .. " is " .. difference .. " levels lower than " .. getPokemonName(i) .. ". Moving " .. getPokemonName(currentIndex) .. " to slot " .. i .. ".")
			end
			swapPokemon(i, currentIndex)
			return true
		end
	end
	return false
end

function hasTypeDisadvantage()
	return getTypeAdvantage() < 1
end

function getTypeAdvantage()
	local pokeType = getPokemonType(getActivePokemonNumber())
	local opponentType = getOpponentType()
	return getDamageMultiplier(pokeType[1], opponentType) * getDamageMultiplier(pokeType[2], opponentType)
end

function getTotalUsableByLevel(level)
	local count = 0
	for i = 1, getTeamSize() do
		if getPokemonLevel(i) >= level and isPokemonUsable(i) then
			count = count + 1
		end
	end
	return count
end

function getTotalUsable(from, to)
	from = from or 1
	to = to or getTeamSize()
	from = math.max(from, 1)
	to = math.min(to, getTeamSize())
	local count = 0
	for i = from, to do
		if isPokemonUsable(i) then
			count = count + 1
		end
	end
	return count
end

randomSwitch = false
function randomTimer(baseTime, deviation)
	randomSwitch = true
	
	-- deviation is a percentage value to randomly deviate from baseTime.
	-- randomTimer(50, 20) will pick a random value between 40 and 60 (50 plus or minus 20 percent of 50)
	
	local negative = 1
	if math.random() > 0.5 then
		negative = -1
	end
	local randTime = (baseTime + (math.random(0, baseTime - (baseTime * ((100 - deviation) / 100)))) * negative) - truncate(math.random() * negative)
	
	log("Picking new line. Next line pick due in " .. randTime .. " seconds.")
	
	invoke(randomTimer, randTime, baseTime, deviation)	
end

averageTimeBetweenSwitches = 600 -- in seconds, default 2 minutes

startedTimer = false -- Checked when we call the algorithm so we're not calling randomTimer unnecessarily

relevantCellTypes = {["Normal Ground"] = true, ["Water"] = true, ["Grass"] = true}
maps = {} --maps[name] holds maps by their name
          --every map is a table of lines with properties: [Length:[int], Type:{"Normal Ground","Water","Grass"}, Direction:{"Row","Column"}, Left:[int], Top:[int], Right:[int], Bottom[int]]
currentLine = nil
currentMapName = nil

function calculateRows()
    for row = 1, getMapHeight() do
        local lastCellType = "None"
        local startX = 0
        for x = 1, getMapWidth() + 1 do
            if x > getMapWidth() or getCellType(x, row) ~= lastCellType then
                if relevantCellTypes[lastCellType] then
                    local line = {}
                    line.Length = x - startX
                    line.Type = lastCellType
                    line.Direction = "Row"
                    line.Left = startX
                    line.Right = x - 1
                    line.Top = row
                    line.Bottom = row
					table.insert(maps[currentMapName], line)
                end
                startX = x
            end
            if x <= getMapWidth() then
                lastCellType = getCellType(x, row)
            end
        end
    end
end

function calculateColumns()
    for column = 1, getMapWidth() do
        local lastCellType = "None"
        local startY = 0
        for y = 1, getMapHeight() + 1 do
            if y > getMapHeight() or getCellType(column, y) ~= lastCellType then
                if relevantCellTypes[lastCellType] then
                    local line = {}
                    line.Length = y - startY
                    line.Type = lastCellType
                    line.Direction = "Column"
                    line.Left = column
                    line.Right = column
                    line.Top = startY
                    line.Bottom = y - 1
                    table.insert(maps[currentMapName], line)
                end
                startY = y
            end
            if y <= getMapHeight() then
                lastCellType = getCellType(column, y)
            end
        end
    end
end

function calculateMap()
    maps[currentMapName] = {}
    calculateRows()
    calculateColumns()
end

function getClosestManhattanSpot(leftX, topY, rightX, bottomY)
    local x, y = getPlayerX(), getPlayerY()
    
    if x < leftX then x = leftX
    elseif x > rightX then x = rightX
    end
    
    if y < topY then y = topY
    elseif y > bottomY then y = bottomY
    end
    
    return x, y
end

function getLineDistance(line)
    -- calculates the distance between the player and the clostest spot on a line
    -- MANHATTAN DISTANCE
    local x, y = getClosestManhattanSpot(line.Left, line.Top, line.Right, line.Bottom)
    return getPathLength(x, y)
end

function evaluateLine(line)
    -- Do a rating of the lines on the current map, taking into account:
    --  -Distance from Player
    --  -Length of Line
    local dist = getLineDistance(line)
    if dist == -1 then return -100 end
    return line.Length / (dist + 4)
end

function chooseLine(groundType)
    -- Weights are evalutions squared
    local sum = 0
    for i, line in ipairs(maps[currentMapName]) do
        if line.Type == groundType then
            local val = evaluateLine(line)
            sum = sum + val * val
        end
    end
    math.randomseed(os.time() + 100) --so it is different from the seed used for the random check
    local rnd = math.random(1, sum)
    for i, line in ipairs(maps[currentMapName]) do
        if line.Type == groundType then
            local val = evaluateLine(line)
            rnd = rnd - val * val
            if rnd <= 0 and not isEqual(currentLine, line) and line.Length > 5 then
                currentLine = line
                return
            end
        end
    end
    fatal("Fail in Choose Line", "Assets/error.wav")
end

function walk(groundType)
	
	if not startedTimer then
		startedTimer = true
		randomTimer(averageTimeBetweenSwitches, 20) -- 20 percent deviation
	end
	
    if getMapName() ~= currentMapName then
        currentMapName = getMapName()
        if not maps[currentMapName] then
            calculateMap()
        end
    end
	
	if randomSwitch then
		randomSwitch = false
		if currentLine then
			log("Old line: (" .. currentLine.Left .. ", " .. currentLine.Top .. ", " .. currentLine.Right .. ", " .. currentLine.Bottom .. ")")
		end
		chooseLine(groundType)
		log("New line: (" .. currentLine.Left .. ", " .. currentLine.Top .. ", " .. currentLine.Right .. ", " .. currentLine.Bottom .. ")")
    end
    moveToLine(currentLine.Left, currentLine.Top, currentLine.Right, currentLine.Bottom)
end

function moveToGrass()
    log("moved to grass")
    walk("Grass")
end

function moveToWater()
    walk("Water")
end

function moveToNormalGround()
    walk("Normal Ground")
end

function truncate(num, decAmount)
	decAmount = decAmount or 2 -- Number of digits after the decimal to keep
	if decAmount <= 0 then
		return math.modf(num)
	end
	num = tostring(num)
	local index = num:find("%.")
	if not index then -- No fractional part is present
		return tonumber(num)
	end
	return tonumber(num:sub(1, index + decAmount))
end

function math.clamp(num, min, max)
	num = math.min(num, max)
	num = math.max(num, min)
	return num
end

function waitUntilTime(hour, minute)
	minute = minute or 0
	hour = math.clamp(hour, 0, 23)
	minute = math.clamp(minute, 0, 59)
	
	-- 10 seconds represents 1 in-game minute
	
	-- Convert target and current time to real-time seconds
	local target = hour * 600 + minute * 10
	local current = getTime() * 600 + getMinute() * 10	
	
	-- Get difference between target and current
	local timeToWait = math.abs(target - current)
	
	if target < current then
		timeToWait = 14400 - timeToWait -- 24 hours minus time, if our wait period will pass 23:59
	end
	
	if minute < 10 then
		minute = "0" .. minute
	end
	
	relog(timeToWait, "Logging out. Will log back in in " .. timeToWait .. " seconds. (Waiting until " .. hour .. ":" .. minute .. ")")
end

function waitUntilMorning()
	if isMorning() then
		return
	end
	waitUntilTime(4)
end

function waitUntilDay()
	if isNoon() then
		return
	end
	waitUntilTime(10)
end

function waitUntilNight()
	if isNight() then
		return
	end
	waitUntilTime(20)
end

--[[
function findLibFolder()
	local tab = getScriptPath():split("\\")
	local newPath = ""
	for i = #tab - 1, 1, -1 do
		if tab[i] == "Release" or tab[i]:find("PROShine") then
			return newPath .. "Libs"
		else
			newPath = "../" .. newPath
		end
	end
	return nil
end

pf = require(findLibFolder() .. "Pathfinder/MoveToApp")
function moveTo(tempMap)
	return pf.moveTo(getMapName(), tempMap)
end

function useNearestPokecenter()
	return pf.useNearestPokecenter(getMapName())
end

function useNearestPokemart(item, amount)
	return pf.useNearestPokemart(getMapName(), item, amount)
end

function moveToPC()
	return pf.moveToPC(getMapName())
end
]]
