local System = require("scripts/System")
local Monster = require("scripts/Monster")
local Spawner = require("libs/Spawner")
local Database = require("scripts/Database")

local spawn = {}

spawn.permissionLevel = "Admin"

---@param sender APalPlayerController
---@param arguments string[]
function spawn.execute(sender, arguments)

    if arguments[2] then
        local customPal = Database.read("Monsters")[arguments[2]]

        if customPal then
            Spawner.Spawn(customPal, Spawner.CallbackTeleportToCharacter,{ sender:GetControlPalCharacter() })

        elseif Monster.IsMonsterDebugNameValid(arguments[2]) then 
            local level = tonumber(arguments[3])
            local quantity = tonumber(arguments[4])

            if math.type(quantity) == "integer" and math.type(level) == "integer" then
                local simpleMonster = {
                    ID = arguments[2],
                    Level = level,
                    Level_Max = level,
                    Num = quantity,
                    Num_Max = quantity
                }
                Spawner.Spawn(simpleMonster, Spawner.CallbackTeleportToCharacter,{ sender:GetControlPalCharacter() })
            else
                System.SendSystemToPlayer(sender, "Level and Quantity must be integers")
            end
        else
            System.SendSystemToPlayer(sender, "Invalid Pal ID")
        end
    else
        System.SendSystemToPlayer(sender, "Usage: /spawn DebugName Level Quantity")
    end
end

return spawn