local Logger = {} 

Logger.prefix = "[Sphere]" 
Logger.Path = ".\\Mods\\shared\\"

---@param array table
---@param depth? number
local function logArray(array, depth)
    depth = depth or 0
    for key, value in pairs(array) do
        local depthCharacters = string.rep(" ", depth)
        if type(value) == "table" then
            Logger.print(string.format("%sKey: %s", depthCharacters, key))
            logArray(value, depth + 2)
        else
            Logger.print(string.format("%s%s %s\n", depthCharacters, key, tostring(value)))
        end
    end
end

---@param message string
function Logger.print(message)
    if type(message) == "table" then
        logArray(message)
    else
        os.execute(string.format("echo %s %s", Logger.prefix, message))
    end
end

function Logger.start()
    Logger.print("--------")
    Logger.print("Version: V2.0 02/29/2024")
    Logger.print("Starting...")
    Logger.print("--------")
end

function Logger.credit()
    Logger.print("--------")
    Logger.print("Our plugin will always be free!")
    Logger.print("Creator: Decio Luvier (#pw_another)")
    Logger.print("Special thanks to Patreon supporters:")
    Logger.print("#minhon.")
    Logger.print("https://discord.gg/cS62fmW6TF")
    Logger.print("--------")
end

return Logger