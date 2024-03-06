local Static = require("scripts/Static")
local Logger = require("libs/Logger")
local FVector = require("constructors/FVector")

local Player = {}

---@param PlayerController APalPlayerController
---@return string
function Player.GetPermissionName(PlayerController)

    if PlayerController.bAdmin then
        return "Admin"
    else
        return "Member"
    end
end

---@param PlayerController APalPlayerController
---@return APalNetworkTransmitter
function Player.GetNetworkTransmitter(PlayerController)
    local PalPlayerCharacter = PlayerController:GetControlPalCharacter()
    local PalUtility = Static:GetPalUtility()
    return PalUtility:GetNetworkTransmitterByPlayerCharacter(PalPlayerCharacter)
end

---@param PlayerController APalPlayerController
---@return UPalNetworkPlayerComponent
function Player.GetPalNetworkPlayerComponent(PlayerController)
    local NetworkTransmitter = Player.GetNetworkTransmitter(PlayerController)
    return NetworkTransmitter:GetPlayer()
end

---@param PlayerController APalPlayerController
---@return string
function Player.GetName(PlayerController)
    local PalPlayerState = PlayerController:GetPalPlayerState()
    return PalPlayerState.PlayerNamePrivate:ToString()
end

---@param id number
---@return APalPlayerController
function Player.GetPlayerController(id)
    Logger.Log(string.format("Searching for %i", id))
    local palUtility =  Static.GetPalUtility()
    local allPlayersInfo = palUtility:GetPlayerListDisplayMessages(Static.GetWorld()) 

    if allPlayersInfo then
        for i = 1, #allPlayersInfo do
            --"Luvier,806377371,76561198071615417"
            local playerInfoString = allPlayersInfo[i]:get():ToString()
            Logger.Log(string.format("%i° = %s", i, playerInfoString))

            local last_comma = playerInfoString:find(",[^,]*$", 1)
            local second_comma = playerInfoString:find(",[^,]*,[^,]*$", 1)

            local SteamID = tonumber(playerInfoString:sub(last_comma + 1))
            local Uid = tonumber(playerInfoString:sub(second_comma + 1, last_comma - 1))

            if id == SteamID or id == Uid then
                Logger.Log(string.format("Found"))

                --Should change
                local allplayersControllers = FindAllOf("PalPlayerController")
                for i = 1, #allplayersControllers do
                    local player = allplayersControllers[i] ---@type APalPlayerController
                    local playerState = player:GetPalPlayerState()
                    if playerState then
                        if Uid == playerState.PlayerUId.A then
                            Logger.Log(string.format("Valid Uid"))
                            return player
                        else
                            Logger.Log(string.format("Invalid Uid"))
                        end
                    end
                end
                --

            end
        end
    end
    return nil
end

---@param PlayerController APalPlayerController
---@return FVector
function Player.GetPlayerLocation(PlayerController)
    return FVector.translate(PlayerController:GetControlPalCharacter().ReplicatedMovement.Location)
end

return Player