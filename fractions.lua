#!/bin/lua

Fraction = {}
Fraction.__index = Fraction

local function gcd(a, b)
    while b ~= 0 do
        a, b = b, a % b
    end
    return math.abs(a)
end

local function toFractions(...)
    local args = {...}
    local results = {}
    for _, val in ipairs(args) do
        if type(val) == 'number' then
            if math.type(val) == 'integer' then
                -- convert numbers to n/1
                table.insert(results, Fraction.new(val, 1))
            else
                -- convert floats to n/1
                whole, decimal = math.modf(val)
                local dec_digits = #string.gsub(tostring(decimal), "%.", "")
                numerator = whole * math.pow(10, dec_digits) + decimal * math.pow(10, dec_digits)
                num_int, _ = math.modf(numerator) -- = math.tointeger(math.floor(numerator))
                table.insert(results, Fraction.new(num_int, math.pow(10, dec_digits)))
            end
        elseif type(val) == "table" and getmetatable(val) == Fraction then
            -- it is already a fraction, leave it alone
            table.insert(results, val)
        else
            print(type(val))
            return args
        end
    end
    return table.unpack(results)
end

function Fraction.new(a, b)
    local self = setmetatable({}, Fraction)
    
    local div = gcd(a, b)
    self.a = math.tointeger(a / div)
    self.b = math.tointeger(b / div)
    return self
end

-- make Fraction callable to do new
setmetatable(Fraction, {
    __call = function(cls, a, b)
        return cls.new(a, b)
    end
})

function Fraction:__tostring()
    return self.a .. '/' .. self.b
end

function Fraction.__add(f1, f2)
    f1, f2 = toFractions(f1, f2)
    local a = f1.a * f2.b + f2.a * f1.b
    local b = f1.b * f2.b
    return Fraction.new(a, b)
end

function Fraction.__sub(f1, f2)
    f1, f2 = toFractions(f1, f2)
    local a = f1.a * f2.b - f2.a * f1.b
    local b = f1.b * f2.b
    return Fraction.new(a, b)
end

function Fraction.__mul(f1, f2)
    f1, f2 = toFractions(f1, f2)
    local a = f1.a * f2.a
    local b = f1.b * f2.b
    return Fraction.new(a, b)
end

function Fraction.__div(f1, f2)
    f1, f2 = toFractions(f1, f2)
    local a = f1.a * f2.b
    local b = f1.b * f2.a
    return Fraction.new(a, b)
end

function Fraction:decimal()
    -- the call requires s:decimal as well
    return self.a / self.b
end

f1 = Fraction.new(1, 2)
f2 = Fraction.new(2, 3)
print(f1, f2)
s = f1 + f2  -- call __add(f1, f2) on f1's metatable
s = s - Fraction.new(1, 6)
print(s, getmetatable(s))
print(s:decimal())

f1 = Fraction(1, 2)
f2 = Fraction(2, 3)
print(f1 + f2)
print(f1 - f2)
print(f1 * f2)
print(f1 / f2)
print(f1 * 5)
print(f1 / 2)
print(f1:decimal())

print((f1 * 1.15))
return Fraction