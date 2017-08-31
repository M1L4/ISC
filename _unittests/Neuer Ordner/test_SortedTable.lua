require "libs.util.collection"

battlers = {a=2, b =7, z=1}

print "disorderd"
for i in pairs(battlers) do
  print (i)
end

print "alphabetical"
for i in pairsByKeys(battlers) do
  print (i)
end

print "distance"
for i in pairsByKeys(battlers, function(a,b) return battlers[a]<battlers[b] end) do
  print (i)
end


