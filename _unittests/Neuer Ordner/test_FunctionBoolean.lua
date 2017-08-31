function foo()
end

function foo2()
return foo()
end

print(foo()==true)
print(foo2()==true)

