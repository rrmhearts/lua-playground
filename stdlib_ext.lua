-- stdlib_ext.lua
local M = {}

-- Function to find the name
function getGlobalName(value)
    for name, val in pairs(_G) do
        if val == value then
            return name
        end
    end
    return nil
end

-------------------------------------------------------------------------------
-- 1. MATH EXTENSIONS
-------------------------------------------------------------------------------
-- Add useful mathematical constants missing from standard Lua
math.PHI = 1.618033988749895
math.TAU = 6.283185307179586 -- 2 * PI
math.Fraction = require("fractions")

-- Greatest Common Divisor (Euclidean algorithm)
function math.gcd(a, b)
    while b ~= 0 do
        a, b = b, a % b
    end
    return math.abs(a)
end

-- Least Common Multiple
function math.lcm(a, b)
    if a == 0 or b == 0 then return 0 end
    return math.abs(a * b) / math.gcd(a, b)
end

-- Round to nearest integer or specific decimal place
function math.round(num, decimal_places)
    local mult = 10^(decimal_places or 0)
    return math.floor(num * mult + 0.5) / mult
end

-- Clamp a value between a minimum and maximum bounds
function math.clamp(val, min, max)
    if val < min then return min end
    if val > max then return max end
    return val
end

-------------------------------------------------------------------------------
-- 2. STRING EXTENSIONS
-- Note: Extending the global 'string' table allows for method syntax: s:trim()
-------------------------------------------------------------------------------

-- Remove leading and trailing whitespace
function string.trim(s)
    return s:match("^%s*(.-)%s*$")
end

-- Split a string into a table using a delimiter (plain text, not pattern)
function string.split(s, delimiter)
    local result = {}
    local from = 1
    local delim_from, delim_to = string.find(s, delimiter, from, true)
    
    while delim_from do
        table.insert(result, string.sub(s, from, delim_from - 1))
        from = delim_to + 1
        delim_from, delim_to = string.find(s, delimiter, from, true)
    end
    
    table.insert(result, string.sub(s, from))
    return result
end

-- Check if a string starts with a specific substring
function string.starts_with(s, start)
    return string.sub(s, 1, string.len(start)) == start
end

-- Check if a string ends with a specific substring
function string.ends_with(s, send)
    return send == "" or string.sub(s, -string.len(send)) == send
end

-------------------------------------------------------------------------------
-- 3. TABLE EXTENSIONS
-------------------------------------------------------------------------------

-- Perform a shallow copy of a table
function table.shallow_copy(t)
    local target = {}
    for k, v in pairs(t) do
        target[k] = v
    end
    return target
end

-- Extract all keys from a dictionary-style table
function table.keys(t)
    local keys = {}
    for k, _ in pairs(t) do
        table.insert(keys, k)
    end
    return keys
end

-- Check if a table is empty (handles both arrays and dictionaries)
function table.is_empty(t)
    return next(t) == nil
end

-- Recursively dump a table to a readable string
function table.dump(t)
    local function dump_helper(obj, indent, seen)
        -- Handle non-table types
        if type(obj) ~= 'table' then
            if type(obj) == 'string' then
                return '"' .. obj .. '"'
            end
            return tostring(obj)
        end
        
        -- Prevent infinite loops from circular references
        if seen[obj] then 
            return tostring(obj) .. " [circular reference]" 
        end
        seen[obj] = true
        
        -- Build the string for the table
        local s = '{\n'
        for k, v in pairs(obj) do
            -- Format the key
            local key
            if type(k) == 'string' then
                key = k
            else
                key = '[' .. tostring(k) .. ']'
            end
            
            -- Recursively format the value
            local value = dump_helper(v, indent .. '  ', seen)
            
            s = s .. indent .. '  ' .. key .. ' = ' .. value .. ',\n'
        end
        return s .. indent .. '}'
    end
    
    return dump_helper(t, "", {})
end


-- return module
return M
