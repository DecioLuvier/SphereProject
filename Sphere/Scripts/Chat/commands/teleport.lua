local Admin = require("scripts/Admin")
local Player = require("scripts/Player")
local System = require("scripts/System")
local Palbox = require("scripts/Palbox")

local teleport = {}

teleport.permissionLevel = "Admin"

---@param playerController APalPlayerController
---@param target string
---@return string
local function teleport_Implementation(playerController,target)
    local playerToTeleport = playerController:GetControlPalCharacter()
    local match1, match2 = target:match("(%d+)_P(%d+)")

    if match1 and match2 then   --Check if the target is to a palbox 
        local palBoxOwner = Player.GetController(match1)

        if palBoxOwner then
            local allTargetPlayerPalBoxes = Palbox.GetPlayerPalBoxes(palBoxOwner)
            local selectedPalBox = allTargetPlayerPalBoxes[tonumber(match2)]

            if selectedPalBox then
                local palboxTarget = Palbox.GetPalBoxLocation(selectedPalBox)
                Admin.TeleportCharacterToLocation(playerToTeleport,palboxTarget)
                return "success"
            else
                return "Palbox to teleport not found"
            end
        else
           return "Owner of palbox not found"
        end
    else
        local targetPlayer = Player.GetController(target)

        if targetPlayer then
            Admin.TeleportCharacterToCharacter(playerToTeleport,targetPlayer:GetControlPalCharacter())
            return "success"
        else
            return "Player to teleport not found"
        end
    end
end

---@param sender APalPlayerController
---@param arguments string[]
function teleport.execute(sender, arguments)

    if arguments[2] then
        if arguments[3] then 
            local _targetPlayer = Player.GetController(arguments[2])

            if _targetPlayer then
                local _result = teleport_Implementation(_targetPlayer, arguments[3])
                System.SendSystemToPlayer(sender, _result)
            else
                System.SendSystemToPlayer(sender, "Player to teleport not found")
            end
        else
            local _result = teleport_Implementation(sender, arguments[2])
            System.SendSystemToPlayer(sender,_result)
        end
    else
        System.SendSystemToPlayer(sender, "Usage: See the CurseForge")
    end
end

return teleport 