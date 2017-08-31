

local input = 3666

--local seconds = input%60
--local minutes = input%60*60
--local hours = math.floor(input/60)
--
--
--print(seconds)
--print(minutes)
--print(hours)
--
--
--seconds = 60
--minutes = seconds/60
--hours = minutes/60
--
--print(seconds)
--print(minutes)
--print(hours)
--
--
local hours = string.format("%02d", math.floor(input / 60 / 60));
local mins = string.format("%02d", input /60);
local secs = string.format("%02d", input);

print(hours)
print(mins)
print(secs)

