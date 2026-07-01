local fallback_table = { default_weapon = "Sword" }

local player = { name = "Hero" }
-- player.default_weapon is currently nil

-- Apply the rules:
setmetatable(player, { __index = fallback_table })

-- Lua looks for default_weapon in 'player', doesn't find it.
-- It sees the __index rule, looks in 'fallback_table', and finds "Sword"!
print(player.default_weapon) -- Prints: Sword

-- To Classes

-- 1. THE CLASS (Shared Methods)
local Enemy = {}

-- We set Enemy's __index to point to itself. 
-- This is a common shortcut so we can use the Enemy table AS the metatable later.
Enemy.__index = Enemy
-- can be replaced by self.__index = self in new()

-- A shared method
function Enemy:take_damage(amount)
    self.hp = self.hp - amount
    print("Enemy took " .. amount .. " damage. HP is now " .. self.hp)
end
-- same as Enemy.take_damage(self, amount)
-- function Enemy.take_damage(self, amount)
--     self.hp = self.hp - amount
--     print("Enemy took " .. amount .. " damage. HP is now " .. self.hp)
-- end

-- 2. THE CONSTRUCTOR
function Enemy.new(starting_hp)
    -- The Instance (Stores only unique state, no methods!)
    local instance = { hp = starting_hp }
    
    -- Link the Instance to the Class
    -- When the instance is missing a key, it will check Enemy.__index (which points to Enemy)
    setmetatable(instance, Enemy)
    -- could return setmetatable because returns instance
    
    return instance
end

-- 3. THE USAGE
local goblin = Enemy.new(100)
local orc = Enemy.new(250)

-- goblin doesn't have a 'take_damage' function inside it.
-- Lua falls back to the metatable's __index (the Enemy table), finds it, and runs it!
goblin:take_damage(20)