function test(x, ...)
test2(...)
end

function test2(...)
args = {...}
print(#args)
print(...)
end 

test("hallo", "x", "y")
test("hallo")