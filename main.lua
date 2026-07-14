#!/bin/lua5.4

-- Examples of the differences
local my_string = "Hello" .. " World" -- Concatenation
local is_valid = true

if is_valid ~= false then
    print("Not equal is ~=")
end

if 0 then
    print("This WILL print. 0 is true in Lua.")
end

-- 1-based indexing!
local fruits = {"apple", "banana", "cherry"}
print(fruits[1]) -- prints "apple"
print(#fruits)   -- The '#' operator gets the length of the array (3)

local config = {
      resolution = "1920x1080",
      fullscreen = true,
      audio = {
          volume = 80,
          mute = false
      }
  }
  print(config.resolution) -- Syntax sugar for config["resolution"]

-- Execute the file and grab its return value
local config = dofile("config.lua")
print("Connecting to: " .. config.host)

-- Write to a file
local file = io.open("test.txt", "w")
if file then
    file:write("Hello, File!\n") -- Note the colon ':' syntax for method calls
    file:close()
end

-- Read from a file
local file = io.open("test.txt", "r")
if file then
    local content = file:read("*a") -- "*a" reads the whole file
    print(content)
    file:close()
end

-- Simple execution (prints to stdout, returns status)
os.execute("mkdir new_folder")
os.execute("rm -rf new_folder")

-- Capture output from a command (like Python's subprocess)
local handle = io.popen("ls -la")
if handle then
      local result = handle:read("*a")
      handle:close()
      print(result)
end

-- Assuming you compiled the C code into a shared library (e.g., math_ext.so)
-- 'require' now returns the table we built in C
local math_ext = require("math_ext")
-- sudo apt install build-essential liblua5.4-dev lua5.4
-- gcc -shared -fPIC -O2 math_ext.c -o math_ext.so -I/usr/include/lua5.4
--fPIC: Position Independent Code. This is required for shared libraries in Linux.
--shared: Tells the compiler to produce a shared object (.so) rather than an executable.

-- Call the C function just like a normal Lua function, but from a table.
local result = math_ext.add_in_c(10, 25)
print("Result: " .. result) -- Prints 35


-- Require the module once at the top of your program
require("stdlib_ext")

-- Using Math Extensions
print(math.PHI)               --> 1.6180339887499
print(math.gcd(48, 18))       --> 6
print(math.round(3.14159, 2)) --> 3.14
print(math.clamp(15, 0, 10))  --> 10

-- Using String Extensions (Object-Oriented Style)
local text = "   hello,world,lua   "
local clean_text = text:trim()
print("'" .. clean_text .. "'") --> 'hello,world,lua'

local parts = clean_text:split(",")
print(parts[1], parts[2])     --> hello    world

print(clean_text:starts_with("hello")) --> true
print(clean_text:ends_with("py"))     --> false

-- Using Table Extensions
local my_dict = { name = "Alice", age = 30 }
local keys = table.keys(my_dict) -- keys = {"name", "age"}
print(table.dump(keys))
print(table.is_empty(my_dict))   --> false
print(table.is_empty({}))       --> true

-- 1. Create a complex table with nested data
player = {
    name = "Hero",
    level = 42,
    inventory = {
        weapons = {"Sword", "Bow"},
        gold = 1500
    },
    is_active = true
}

-- 2. Create a circular reference (player targets themselves)
player.target = player 

-- 3. Print the table contents
print(table.dump(player))

print(getGlobalName(player))

frac = math.Fraction(1, 2)
print((frac*2):decimal())