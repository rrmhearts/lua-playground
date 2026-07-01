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