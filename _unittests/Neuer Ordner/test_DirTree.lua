require "libs.routing.dirTree"
c = select(1, ...)

print("0: "..tostring(c))
print("1: "..getParentDir("", 1))
print("2: "..getParentDir(select(1, ...), 1))

print("3: "..getParentDir(""))
