local BattleMessage = require "libs.battle.enum.messages"
local BattleMessageManager = require "libs.battle.message_manager"
local DialogMessageManager = require "libs.dialog.message_manager"
require "libs.util.string"


local MONEY = "Pokedollar(s)"
local EXP = "EXP"

API = require "libs.util.api"
local Tracker = API:new()

function Tracker:init()
    --time
    self.start_time = nil
    self.log_time = nil
    self._pause_time = nil
    self.paused_seconds = 0

    --encounters
    self.wild_encounters = 0
    self.shiny_encounters = 0
    self.heals = 0

    --earnings
    self.earnings = { [MONEY] = 0, [EXP] = 0 }
    self.losses = {}
end


--bot controls
function Tracker:onStart()
    self.start_time = os.time()
    self.log_time = os.time()
    self.paused_seconds = 0
end

function Tracker:onStop()
    self:printFullLog()
end

function Tracker:onPause()
    self._pause_time = os.time()
    self:printFullLog()
end

function Tracker:onResume()
    local second_paused = os.difftime(os.time(), self._pause_time)
    self.paused_seconds = self.paused_seconds + second_paused
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
    for _, item in pairs({ MONEY, EXP }) do
        local amount = self.earnings[item]

        --money and exp gained, will be averaged
        local avgMin = math.floor(amount / self:_getMinutesElapsed())
        local avgH = math.floor(amount / self:_getHoursElapsed())

        local align = "\t"
        if item == EXP then align = "\t\t" end

        log("INFO | " .. item .. ":"..align
            --trim exp to 2 digits after comma
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
        if item ~= MONEY and item ~= EXP then
            --prints items gained
            log("INFO | " .. tostring(amount) .. "\t" .. item)
        end
    end

    if self.losses then log("INFO | --Losses--") end
    --TODO: substract the amount lost, from netto money earned
    --prints items used
    for item, amount in pairs(self.losses) do
        if item ~= MONEY then
            log("INFO | " .. tostring(amount) .. ": " .. item)
        end
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