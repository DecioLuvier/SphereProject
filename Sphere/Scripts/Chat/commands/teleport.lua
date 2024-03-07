local Admin = require("scripts/Admin")
local Player = require("scripts/Player")
local System = require("scripts/System")
local Palbox = require("scripts/Palbox")

local teleport = {}

teleport.permissionLevel = "Admin"

---@param sender APalPlayerController
---@param arguments string[]
function teleport.execute(sender, arguments)

    if arguments[2] then
        local match1, match2 = arguments[2]:match("(%d+)_P(%d+)")

        if match1 and match2 then   --Check if the target is to a palbox 
            local targetPlayer = Player.GetPlayerController(tonumber(match1))

            if targetPlayer then
                local allTargetPlayerPalBoxes = Palbox.GetPlayerPalBoxes(targetPlayer)
                local selectedPalBox = allTargetPlayerPalBoxes[tonumber(match2)]
    
                if selectedPalBox then
                    local palboxTarget = Palbox.GetPalBoxLocation(selectedPalBox)
                    Admin.TeleportCharacterToLocation(targetPlayer:GetControlPalCharacter(),palboxTarget)
                    System.SendSystemToPlayer(sender, "Success")
                else
                    System.SendSystemToPlayer(sender, "Palbox to teleport not found")
                end
            else
                System.SendSystemToPlayer(sender, "Player to teleport not found")
            end
        else
            local targetPlayer = Player.GetPlayerController(tonumber(arguments[2]))

            if targetPlayer then
                Admin.TeleportCharacterToCharacter(sender:GetControlPalCharacter(),targetPlayer:GetControlPalCharacter())
                System.SendSystemToPlayer(sender, "success")
            else
                System.SendSystemToPlayer(sender, "Player to teleport not found")
            end
        end
    else
        System.SendSystemToPlayer(sender, "Usage: /tp SteamIDorUID or SteamIDorUID_PX(where x is the palbox number)")
    end
end

return teleport 