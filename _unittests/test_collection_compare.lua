--isc as a git project, seems to be the entry point
require "isc.myscripts.libs.util.collection"


local pkm, pkmLvl, pkmHealth = nil, nil, nil
local result, val, expected = nil, nil, nil

function getMessage(result, expected, val)
    return string.format("---error: %s != %s   | val: %s", tostring(result), tostring(expected), tostring(val))
end


--TODO: replace with imported functions (wrapping needed for getPokemonHealth and co...), when figerued out how to require from intellij

function deepcompare(t1,t2,ignore_mt)
    local ty1 = type(t1)
    local ty2 = type(t2)
    if ty1 ~= ty2 then return false end
    -- non-table types can be directly compared
    if ty1 ~= 'table' and ty2 ~= 'table' then return t1 == t2 end
    -- as well as tables which have the metamethod __eq
    local mt = getmetatable(t1)
    if not ignore_mt and mt and mt.__eq then return t1 == t2 end
    for k1,v1 in pairs(t1) do
        local v2 = t2[k1]
        if v2 == nil or not deepcompare(v1,v2) then return false end
    end
    for k2,v2 in pairs(t2) do
        local v1 = t1[k2]
        if v1 == nil or not deepcompare(v1,v2) then return false end
    end
    return true
end

function compare(t, fn)
    if t and #t == 0 then return nil end --, nil end
    local key, value = 1, t[1]
    for i = 2, #t do
        if fn(value, t[i]) then
            key, value = i, t[i]
        end
    end
    return key --, value
end

function filter(t, fn, ...)
    local newtbl = {}
    for key, value in pairs(t) do
        if fn(key, ...) then
            table.insert(newtbl, value)
        end
    end

    if #newtbl > 0 then return newtbl end
end

--comparers
local function maxLVL(a,b) return pkmLvl[b] > pkmLvl[a] end
local function minLVL(a,b) return pkmLvl[b] < pkmLvl[a] end
--filters
local function alive(a) return pkmHealth[a] > 0 end
local function levelable(a, lvl_cap) return pkmLvl[a] < lvl_cap end

-- --max Level-- --
pkm = {         1,  2,  3,  4,  5,  6}
pkmLvl = {      5, 55, 33, 15, 75,  3 }
result, val = compare(pkm, maxLVL)
expected = 5
assert(result == expected, getMessage(result, expected, val))

pkmLvl = {      5, 55, 88, 15, 75, 3}
result, val = compare(pkm, maxLVL)
expected = 3
assert(result == expected, getMessage(result, expected, val))

pkmLvl = {      99, 55, 88, 15, 75, 3}
result, val = compare(pkm, maxLVL)
expected = 1
assert(result == expected, getMessage(result, expected, val))


-- --min Level-- --
pkmLvl = {      5, 55, 33, 15, 75,  3 }
result, val = compare(pkm, minLVL)
expected = 6
assert(result == expected, getMessage(result, expected, val))

pkmLvl = {      5, 55, 88, 15, 75, 3}
result, val = compare(pkm, minLVL)
expected = 6
assert(result == expected, getMessage(result, expected, val))

pkmLvl = {      99, 55, 88, 15, 75, 99}
result, val = compare(pkm, minLVL)
expected = 4
assert(result == expected, getMessage(result, expected, val))



pkmHealth = {   0,  0,  0,  0,  0,  0 }
result = filter(pkm, alive)
expected = nil
assert(result == expected, getMessage(result, expected, val))

pkmHealth = {   0,  0,  55,  0,  0,  0}
result = filter(pkm, alive)
expected = {3}
assert(deepcompare(result ,expected, true), getMessage(result, expected, val))



pkmLvl = {      99, 55, 88, 15, 75, 99}
result = filter(pkm, levelable, 15)
expected = nil
assert(result == expected, getMessage(result, expected, val))

pkmLvl = {      99, 55, 88, 15, 75, 99}
result = filter(pkm, levelable, 89)
expected = {2,3,4,5}
assert(deepcompare(result ,expected, true), getMessage(result, expected, val))