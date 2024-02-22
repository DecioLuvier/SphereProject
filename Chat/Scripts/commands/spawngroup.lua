local System = require("scripts/System")
local Spawner = require("libs/Spawner")
local Database = require("scripts/Database")

local spawngroup = {}

spawngroup.permissionLevel = "Admin"

---@param sender APalPlayerController
---@param arguments string[]
function spawngroup.execute(sender, arguments) 

    if arguments[2] then
        local palGroup = Database.read("Groups")[arguments[2]]

        if palGroup then
            for _, item in ipairs(palGroup) do

                if type(item) == "table" then
                    Spawner.Spawn(item, Spawner.CallbackTeleportToCharacter,{ sender:GetControlPalCharacter() })
                else
                    local customPal = Database.read("Monsters")[item]

                    if customPal then
                        Spawner.Spawn(customPal, Spawner.CallbackTeleportToCharacter,{ sender:GetControlPalCharacter() })
                    else
                end 
                end
            end
        else
            System.SendSystemToPlayer(sender, "Invalid Pal Group Name")
        end
    else
        System.SendSystemToPlayer(sender, "Usage: /spawn GroupName")
    end
end

return spawngroup