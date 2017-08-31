local test_value = 100

--#######class definitions#######
local Class = { a = test_value}
function Class:new (o)
    o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self
    return o
end

local NewClass = Class:new()

--#######test inheritance#######
a = Class:new()
b = NewClass:new()

assert (a.a == test_value)
assert (b.a == test_value)

b.a = 20

assert (a.a == test_value)
assert (b.a == 20)


--#######function definitions#######
function NewClass:getArg(arg)
    return arg
end

--#######test function calls#######
print(b:getArg())
--assert(b.getArg() == b)