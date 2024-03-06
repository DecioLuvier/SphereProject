local Logger = {} 

Logger.consolePrefix = "[Sphere]" 
Logger.logFilePath = "!SphereLogs.txt"

---@param array table
---@param depth? number
local function ConvertArray(array, depth)
    depth = depth or 0
    for key, value in pairs(array) do
        local depthCharacters = string.rep(" ", depth)
        if type(value) == "table" then
            Logger.print(string.format("%sKey: %s", depthCharacters, key))
            ConvertArray(value, depth + 2)
        else
            Logger.print(string.format("%s%s %s", depthCharacters, key, tostring(value)))
        end
    end
end

---@param message string
function Logger.print(message)
    if type(message) == "table" then
        ConvertArray(message)
    else
        io.stdout:write(string.format("%s %s %s\n",  os.date("%H:%M:%S"), Logger.consolePrefix, message))
        Logger.Log(message)
    end
end

---@param message string
function Logger.Log(message)
    local file = io.open(Logger.logFilePath, "a")

    if file then
        file:write(message .. "\n")
        file:close()
    end    
end

function Logger.Initialize()
    local file = io.open(Logger.logFilePath, "w")

    if file then
        file:close()
    end    
end


return Logger