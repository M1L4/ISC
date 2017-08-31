local Class = {}
function Class:new (o)
  o = o or {}   -- create object if user does not provide one
  setmetatable(o, self)
  self.__index = self
  return o
end

q = Class:new()


-- Overwriting old one
function q:getStatus()
    print("getStatus new")
end
-- Creating pointer
q._getStatus = q.getStatus


-- Calling old function
q:_getStatus()
q:getStatus()




--Quest = {}
--function Quest:new (o)
--  o = o or {}
--  setmetatable(o, self)
--  self.__index = self
--  return o
--end
--
--function Quest:getStatus()
--    print("Default Status")
--end
--    
--q = Quest:new()
--
---- Creating pointer
--q._getStatus = q.getStatus
--
---- Overwriting old one
--function q:getStatus()
--    print("getStatus new")
--end
--
---- Calling old function
--q:_getStatus()
--
---- Calling new function
--q:getStatus()