local Admin = require("scripts/Admin")
local Player = require("scripts/Player")
local System = require("scripts/System")

local teleport = {}

teleport.permissionLevel = "Admin"

---@param sender APalPlayerController
---@param arguments string[]
function teleport.execute(sender, arguments)

    if arguments[2] and arguments[3] then

        if Player.GetController(arguments[2]) then
            local teleportPlayer = Player.GetController(arguments[2]):GetControlPalCharacter()
            
            if Player.GetController(arguments[3]) then  
                local targetPlayer = Player.GetController(arguments[3]):GetControlPalCharacter()
                Admin.TeleportCharacterToCharacter(teleportPlayer,targetPlayer)
                System.SendSystemToPlayer(sender, "Teleport done successfully")  
            else
                System.SendSystemToPlayer(sender, "Target to teleport not found")         
            end 
        else
            System.SendSystemToPlayer(sender, "Player to teleport not found")
        end
    else
        System.SendSystemToPlayer(sender, "Usage: /teleport Player Target")
    end
end

return teleport