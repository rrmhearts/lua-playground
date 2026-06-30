-- 1. Create a "Class" (just a table)
local FileHandler = {}
FileHandler.__index = FileHandler -- Fallback to itself
--__index allows for creating :printName function

-- 2. Constructor
function FileHandler.new(filename)
    local self = {filename = filename}
    setmetatable(self, FileHandler) -- Link instance to the class
    return self
end

-- 3. Method (Use colon ':' to automatically pass 'self')
function FileHandler:printName()
    print("Handling file: " .. self.filename)
end

-- Usage:
local myFile = FileHandler.new("config.json")
myFile:printName()