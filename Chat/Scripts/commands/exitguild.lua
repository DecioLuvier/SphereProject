local System = require("scripts/System")
local Player = require("scripts/Player")

local FGuid = require("constructors/FGuid")

local exitGuild = {}

exitGuild.permissionLevel = "Admin"

---@param sender APalPlayerController
---@param arguments string[]
function exitGuild.execute (sender, arguments)
    
    if arguments[2] then
        local exitPlayer = Player.GetController(arguments[2])

        if exitPlayer ~= nil then
            local NetworkTransmitter = Player.GetNetworkTransmitter(exitPlayer)
            NetworkTransmitter.Group:RequestExitGuild_ToServer(FGuid.translate(exitPlayer:GetPalPlayerState().PlayerUId))
            System.SendSystemToPlayer(sender, "Player successfully removed from the guild")
        else
            System.SendSystemToPlayer(sender, "Player to force exit guild not found")
        end
    else
        System.SendSystemToPlayer(sender, "Usage: /exitguild Player")
    end
end

return exitGuild