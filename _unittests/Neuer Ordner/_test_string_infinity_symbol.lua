local lvl_cap = nil
local description = "A basic leveler heading to map \"%s\" leveling until %s."


local level = nil
if lvl_cap then    level = "lv "..tostring(level)
else                    level = "∞" --utf8.char(9658)
end
description = string.format(description, "VictoryRoad", level)
print (description)