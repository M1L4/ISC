local Class = {}
function Class:new (o)
  o = o or {}   -- create object if user does not provide one
  setmetatable(o, self)
  self.__index = self

  self:init()
  return o
end

--override
function Class:init()
end

return Class
