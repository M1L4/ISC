local Item = require "libs.game.enum.items"
local BattleMessage = require "libs.battle.enum.messages"
local BattleMessageManager = require "libs.battle.message_manager"
local DialogMessageManager = require "libs.dialog.message_manager"
require "libs.util.string"




API = require "libs.util.api"
local Tracker = API:new()

function Tracker:init()
    --time
    self.start_time = nil
    self.start_money = nil
    self.log_time = nil
    self._pause_time = nil
    self.paused_seconds = 0

    --encounters
    self.wild_encounters = 0
    self.shiny_encounters = 0
    self.heals = 0

    --earnings
    self.earnings = nil
    self.losses = nil
end


--bot controls
function Tracker:onStart()  self:_startTracking() end
function Tracker:onResume() self:_startTracking() end
function Tracker:onStop()
    self:_stopTracking()
    self:printFullLog()
end
function Tracker:onPause()
    self:_stopTracking()
    self:printFullLog()
end

function Tracker:_startTracking()
    --needed for printing logs every minutes
    self.log_time = os.time()

    --needed for bot time calc | doesn't reset until script changed
    --TODO: reset when bot account changed
    self.start_time = self.start_time or os.time()
    self.start_money = self.start_money or getMoney()
    self.earnings = self.earnings or { [Item.MONEY] = 0, [Item.EXP] = 0 }  --setting make default prints
    self.losses = self.losses or {}
    --self.paused_seconds = 0

    --prevent negative difftime values due to self._pause_time being nil
    if self._pause_time then
        local second_paused = os.difftime(os.time(), self._pause_time)
        self.paused_seconds = self.paused_seconds + second_paused
    end

end

function Tracker:_stopTracking()
    --needed for bot time calc
    self._pause_time = os.time()
end


--periodic updates
function Tracker:onPathAction()
    --update every minute
    if os.difftime(os.time(), self.log_time) > 60 then
        self:printSmallLog()
        self.log_time = os.time()
    end
end


--messages
function Tracker:onBattleMessage(msg)

    --encounters
    if string.match(msg, BattleMessage.SHINY_ENCOUNTER) then
        self.shiny_encounters = self.shiny_encounters + 1
        self:_printWildEncounters()

    elseif string.match(msg, BattleMessage.WILD_ENCOUNTER) then
        local pkm = string.match(msg, BattleMessage.WILD_ENCOUNTER)
        self.wild_encounters = self.wild_encounters + 1
        self:_printWildEncounters()
    end

    --earnings
    local items, amount = BattleMessageManager:getEarnings(msg)
    if items and amount then
        self:_addDictEntries(self.earnings, { [items] = amount })
    end

    --losses
    items, amount = BattleMessageManager:getLosses(msg)
    if items and amount then
        self:_addDictEntries(self.losses, { [items] = amount })
    end
end

function Tracker:onDialogMessage(msg)
    --earnings
    local items, amount = DialogMessageManager:getEarnings(msg)
    if items and amount then
        self:_addDictEntries(self.earnings, { [items] = amount })
    end

    --losses
    items, amount = DialogMessageManager:getLosses(msg)
    if items and amount then
        self:_addDictEntries(self.losses, { [items] = amount })
    end
end


--some local needed functions
function Tracker:printSmallLog()
    log("INFO | --Earnings--")
    self:printEarningsMain()
end

function Tracker:printFullLog()
    self:printBotTime()
    self:printHeals()
    self:_printWildEncounters()
    log("INFO | --Earnings--")
    self:printEarningsMain()
    self:printEarningsRest()
end

--- @summary :
--- @return :
--- @type : void
function Tracker:_printWildEncounters()
    log("INFO | --Encounters-- ")
    log("INFO | " .. self.wild_encounters .. " wild")
    if self.shiny_encounters > 0 then
        log("INFO | " .. self.shiny_encounters .. " shiny")
    end
end


function Tracker:printEarningsMain()
    for _, item in pairs({ Item.MONEY, Item.EXP }) do
        -- to make an accurate money per minute print
        -- TODO: getLossesValue() has to be implemented
        local amount = getMoney() - self.start_money --self.earnings[item]

        --Item.MONEY and Item.EXP gained, will be averaged
        local avgMin = math.floor(amount / self:_getMinutesElapsed())
        local avgH = math.floor(amount / self:_getHoursElapsed())

        local align = "\t"
        if item == Item.EXP then align = "\t\t" end

        log("INFO | " .. item .. ":"..align
            --trim Item.EXP to 2 digits after comma
            .. kFormatter(amount) .. " total | "
            .. kFormatter(avgMin) .. " per min | "
            .. kFormatter(avgH) .. " per hour")
    end
end

--- @summary :
--- @return :
--- @type : void
function Tracker:printEarningsRest()
    for item, amount in pairs(self.earnings) do
        if item ~= Item.MONEY and item ~= Item.EXP then
            --prints items gained
            log("INFO | " .. tostring(amount) .. "\t" .. item)
        end
    end

    if self.losses then log("INFO | --Losses--") end
    --TODO: substract the amount lost, from netto Item.MONEY earned
    --prints items used
    for item, amount in pairs(self.losses) do
        log("INFO | " .. tostring(amount) .. ": " .. item)
    end
end

--- @summary :
--- @return :
--- @type : string
function Tracker:printBotTime()
    local hours = self:_getHoursElapsed();          --no upper limit
    local mins = self:_getMinutesElapsed() % 60;    --upper limit 59, achieved via modulo
    local secs = self:_getSecondsElapsed() % 60;    --upper limit 59, achieved via modulo

    local bottime = string.format("%02dh %02dm %02ds", hours, mins, secs)
    log("INFO | --Bottime: " .. bottime .. "--")
end

--- @summary :
--- @return :
--- @type : string
function Tracker:printHeals()
    log("INFO | --Heals: " .. self.heals .. "--")
end

function Tracker:_getSecondsElapsed()
    local elapsed_second = os.difftime(os.time(), self.start_time)
    return elapsed_second - self.paused_seconds
end

--- @summary :
--- @return :
--- @type : float
function Tracker:_getMinutesElapsed()
    return self:_getSecondsElapsed() / 60
end

--- @summary :
--- @return :
--- @type : float
function Tracker:_getHoursElapsed()
    return self:_getMinutesElapsed() / 60
end

function Tracker:_addDictEntries(dict, entries)
    for k, v in pairs(entries) do
        --increase value if key exists
        if dict[k] then dict[k] = dict[k] + v
            --set value if key doesn't exist
        else dict[k] = v
        end
    end
end

return Tracker