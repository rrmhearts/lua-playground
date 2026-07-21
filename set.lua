#!/bin/lua

Set = {}
Set.__index = Set

function t_compare(t1, t2)
    -- Check if they are the exact same table in memory
    if t1 == t2 then return true end
    
    -- Check if both are actually tables
    if type(t1) ~= "table" or type(t2) ~= "table" then return false end
    
    -- Track key count to ensure both tables have identical sizes
    local count = 0
    
    -- Loop through t1 and check if values exist and match in t2
    for k, v in pairs(t1) do
        if type(v) == "table" and type(t2[k]) == "table" then
            -- Recursively check nested tables
            if not t_compare(v, t2[k]) then return false end
        elseif v ~= t2[k] then
            -- Direct value mismatch
            return false
        end
        count = count + 1
    end
    
    -- Ensure t2 doesn't have extra keys that t1 lacks
    for _ in pairs(t2) do
        count = count - 1
    end
    
    return count == 0
end


function Set.new(...)
    local self = setmetatable({}, Set)

    local args = {...}

    if type(args[1]) == 'table' and #args == 1 then
        args = args[1]
    end
    
    self._contains = {}
    self._values = {}
    for _, v in pairs(args) do
        self._values[v] = v
        self._contains[v] = true
    end

    return self
end

-- make Set callable to do new
setmetatable(Set, {
    __call = function(cls, ...)
        return cls.new(...)
    end
})

function Set:__tostring()
    setstr = ''
    -- pairs SKIPS keys with nil values!
    for k, v in pairs(self._values) do
        if type(v) == 'table' then
            v = table.concat(v, ',')
            v = '{' .. v .. '}'
        end
        setstr = setstr .. v .. ' '
    end
    return setstr
end

function Set:remove(...)
    local args = {...}

    for _, value in pairs(args) do
        self._values[value] = nil
        self._contains[value] = false
    end
end

function Set:contains(value)
    if type(value) == 'table' then
        for _, v in pairs(self._values) do
            if type(self._values[v]) == 'table' then
                return t_compare(value, self._values[v])
            end
        end
    end
    return self._contains[value]
end

function Set:length()
    if self == nil then return 0 end
    count = 0
    for _, v in pairs(self._values) do
        count = count + 1
    end
    return count
end

function Set.__len(set)
    return set:length()
end

function Set.__add(...)
    local args = {...}
    local sum = {}

    for _, set in pairs(args) do
        for _, value in pairs(set._values) do
            sum[value] = value
        end
    end
    return Set.new(table.unpack(sum))
end

function Set.__sub(setA, setB)
    local newsetA = Set.new(table.unpack(setA._values))
    for _, v in pairs(setB._values) do
        newsetA:remove(v)
    end
    return newsetA
end

function Set.__band(setA, setB)
    local potents = {table.unpack(setA._contains) }
    for k, _ in pairs(potents) do
        potents[k] = false
    end
    for k, v in pairs(setB._values) do
        if potents[k] == false then potents[k] = true end
    end
    local result = {}
    for k, v in pairs(potents) do
        if v == true then table.insert(result, k) end
    end
    return Set.new(table.unpack(result))
end

function Set.__bor(setA, setB)
    local newsetA = Set.new(table.unpack(setA._values))
    for _, v in pairs(setB._values) do
        newsetA._values[v] = v
        newsetA._contains[v] = true
    end
    return newsetA
end

-- function Set.__pow(setA, number)

--     return Set.new(a, b)
-- end

function Set.__eq(setA, setB)
    if setA._values == setB._values then return true end
    if type(setA._values) ~= "table" or type(setB._values) ~= "table" then return false end
    count = 0
    for _, v in pairs(setA._values) do
        count = count + 1
        if not setB:contains(v) then return false end
    end
    for _, v in pairs(setB._values) do
        count = count -1
        if not setA:contains(v) then return false end
    end
    return count == 0
end

function Set.__lt(setA, setB) -- proper subset
    for _, v in pairs(setA._values) do
        if not setB:contains(v) then return false end
    end
    return true
end

function Set.__le(setA, setB)
    return Set.__lt(setA, setB) or Set.__eq(setA, setB)
end

function Set.__gt(setA, setB)
    for _, v in pairs(setB._values) do
        if not setA:contains(v) then return false end
    end
    return true
end

function Set.__ge(setA, setB)
    return Set.__gt(setA, setB) or Set.__eq(setA, setB)
end


setA = Set.new(1, 3, 2)
setB = Set.new({2, 3, 4, 7})
s = setA + setB  -- call __add(setA, setB) on setA's metatable

-- print(setA & setB)
assert (setA & setB == Set.new(2,3), '2&3')
assert (setA | setB == Set.new(1,2,3,4,7), '1|2|3|4|7')


assert(s == Set.new(1, 2, 3, 4, 7), "Addition fails")
assert(setA - setB == Set.new(1))
assert(setB - setA == Set.new(4))

assert (setA ~= setB, 'setA == setB')
assert (setA == Set.new(1, 2, 3), 'setA == Set.new(1, 2, 3)')
assert (setB == Set.new(2, 3, 4, 7), 'setB == Set.new(2, 3, 4, 7)')

assert(Set.new(2, 4) < setB, '{2,4} < setB')
assert(setA <= Set.new(3,2,1,5, 10), 'setA <= {3,2,1,5,10}')
assert(setA > Set.new({2, 3}), 'setA > {2,3}')
assert(setA >= Set.new({1, 2, 3}), 'setA >= {1,2,3}')

-- modifies setA and setB
assert (setA:remove(1) == setB:remove(7, 4), 'true')

assert (setA:length()==#setA, '2')
assert (setB:length()==#setB, '2')

newset = Set(4,5,6)
assert (Set.new(1,2,3):length() == #newset)




return Set