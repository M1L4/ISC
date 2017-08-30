function Set(list)
    local set = {}
    for _, l in ipairs(list) do set[l] = true end
    return set
end


--function isOnList(List)
--  result = false
--  if List[1] ~= "" then
--    for i=1, TableLength(List), 1 do
--      if getOpponentName() == List[i] then
--        result = true
--      end
--    end
--  end
--  return result
--end

function isOnList(item, List)
    for pos, name in pairs(List) do
        if item == name then
            return true
        end
    end
    return false
end

--iterates over table in sorted order
--https://www.lua.org/pil/19.3.html
function pairsByKeys(t, f)
    local a = {}
    for n in pairs(t) do table.insert(a, n) end
    table.sort(a, f)
    local i = 0 -- iterator variable
    local iter = function() -- iterator function
        i = i + 1
        if a[i] == nil then return nil
        else return a[i], t[a[i]]
        end
    end
    return iter
end

--https://stackoverflow.com/questions/640642/how-do-you-copy-a-lua-table-by-values
function copy(obj, seen)
    if type(obj) ~= 'table' then return obj end
    if seen and seen[obj] then return seen[obj] end
    local s = seen or {}
    local res = setmetatable({}, getmetatable(obj))
    s[obj] = res
    for k, v in pairs(obj) do res[copy(k, s)] = copy(v, s) end
    return res
end

--get all values of a dict
function getValues(t)
    local values = {}
    for k, v in pairs(t) do
        table.insert(values, v)
    end
    return values
end



function compare(t, fn)
    if t and #t == 0 then return nil end --, nil end
    local key, value = 1, t[1]
    for i = 2, #t do
        if fn(value, t[i]) then
            key, value = i, t[i]
        end
    end
    return value --key --,
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

function tablePrint(t)
    log("INFO | table: "..tostring(t))
    for i, v in pairs(t) do
       log("index: "..tostring(i).. "\tvalue: "..tostring(v))
    end
end

--https://web.archive.org/web/20131225070434/http://snippets.luacode.org/snippets/Deep_Comparison_of_Two_Values_3s
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