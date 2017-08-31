--local Class = require "libs.util.inheritance"
--
----new instances
--a = Class:new{balance = 0}
--print (a.balance)
--
----subClass
--SubClass = Class:new()
--function SubClass:test()
--  print("testtest")
--end
--
--function SubClass:test2()
--  self.test()
--end
--
--s = SubClass:new{z="zzz"}
--print("self: "..s.self)
--s.test()
--print(s.z)
--s.test2()

Account = {balance = 0}

function Account:new (o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Account:deposit (v)
  self.balance = self.balance + v
end

a = Account:new()
a.deposit(50)
