local Spawner = require("libs/Spawner")
local System = require("scripts/System")
local Player = require("scripts/Player")

local givepal = {}

givepal.permissionLevel = "Admin"

---@param sender APalPlayerController
---@param arguments string[]
function givepal.execute(sender, arguments)
    if arguments[2] and arguments[3] then
        local givePlayer = Player.GetPlayerController(tonumber(arguments[2]))

        if givePlayer ~= nil then
            local customPal = SphereGlobal.database.Pals[string.lower(arguments[3])]
            
            if customPal then
                Spawner.Spawn(customPal, Spawner.CallbackCaptureToPlayer,{ givePlayer:GetControlPalCharacter() })
            else
                System.SendSystemToPlayer(sender, "Invalid DataPalName")
            end
        else
            System.SendSystemToPlayer(sender, "Player not found")
        end
    else
        System.SendSystemToPlayer(sender, "Usage: /gpal SteamID DataPalName(Sphere/Data/Pals)")
    end
end

return givepal