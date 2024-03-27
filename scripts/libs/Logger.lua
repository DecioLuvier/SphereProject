io.open("Sphere.log", "w"):close()

local self = {} 

self.consolePrefix = "[Sphere]" 

---@param array table
---@param depth? number
local function ConvertArray(array, depth)
    depth = depth or 0
    for key, value in pairs(array) do
        local depthCharacters = string.rep(" ", depth)
        if type(value) == "table" then
            self.Print(string.format("%sKey: %s", depthCharacters, key))
            self.Log(string.format("%sKey: %s", depthCharacters, key))
            ConvertArray(value, depth + 2)
        else
            self.Print(string.format("%s%s %s", depthCharacters, key, tostring(value)))
            self.Log(string.format("%s%s %s", depthCharacters, key, tostring(value)))
        end
    end
end

---@param message string|table
function self.Print(message)
    if type(message) == "table" then
        ConvertArray(message)
    else
        io.stdout:write(string.format("%s %s %s\n",  os.date("%H:%M:%S"), self.consolePrefix, message))
    end
end

---@param message string
function self.Log(message)
    local file = io.open("Sphere.log", "a")

    if file then
        file:write(message .. "\n")
        file:close()
    end    
end

return self