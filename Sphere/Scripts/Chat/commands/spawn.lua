local System = require("scripts/System")
local Spawner = require("scripts/Spawner")

local spawn = {}

spawn.permissionLevel = "Admin"

---@param sender APalPlayerController
---@param arguments string[]
function spawn.execute(sender, arguments)

    if arguments[2] then
        local customPal = SphereGlobal.database.Pals[arguments[2]]

        if customPal then
            Spawner.Spawn(customPal, Spawner.CallbackTeleportToCharacter,{ sender:GetControlPalCharacter() })
            System.SendSystemToPlayer(sender, "Success")
        else
            System.SendSystemToPlayer(sender, "Invalid DataPalName")
        end
    else
        System.SendSystemToPlayer(sender, "Usage: /spawn DataPalName(Sphere/Data/Pals)")
    end
end

return spawn