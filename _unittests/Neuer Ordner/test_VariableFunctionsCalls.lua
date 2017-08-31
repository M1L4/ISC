--function test(...)
--  print("#arg: "..arg["n"])
--  print("arg01: "..arg[1])
--end
--
--test("is working")


-- -----------------------------------

Class = {}
function Class:new (o)
  o = o or {}   -- create object if user does not provide one
  setmetatable(o, self)
  self.__index = self
  return o
end

function Class:test(...)
--    args = {...}
--    log(table.concat(args, " "))
    log(args[1])
--  print("#arg: "..arg["n"])
--  print("arg01: "..arg[1])
----  log("#arg: "..arg["n"])
--  log("#arg: "..arg[1])
  
end

obj = Class:new()
obj:test("is not working")
