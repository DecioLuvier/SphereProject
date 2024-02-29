local Static = require("scripts/Static")
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


--Ok, this code here is a mess, until I find a new way to look for the steamID, 
--unfortunately it is what it is  :/
---@param SteamID number
---@return APalPlayerController
function Player.GetPlayerController(SteamID)
    local palUtility =  Static.GetPalUtility()
    local allPlayersInfo = palUtility:GetPlayerListDisplayMessages(Static.GetWorld()) 

    if allPlayersInfo then
        for i = 1, #allPlayersInfo do
            --"Luvier,806377371,76561198071615417"
            local playerInfoString = allPlayersInfo[i]:get():ToString()
            --I just put on gpt some optimization is needed
            local playerInfo = {}
            local lastCommaIndex = playerInfoString:find(",[^,]*$")

            if lastCommaIndex then
                playerInfo[3] = playerInfoString:sub(lastCommaIndex + 1)
                playerInfoString = playerInfoString:sub(1, lastCommaIndex - 1)
            end
            for token in playerInfoString:gmatch("[^,]+") do
                table.insert(playerInfo, token)
            end
            --
            if SteamID == tonumber(playerInfo[3]) then
                local allplayersControllers = FindAllOf("PalPlayerController")

                for i = 1, #allplayersControllers do
                    local player = allplayersControllers[i] ---@type APalPlayerController
                    local playerState = player:GetPalPlayerState()
                    if playerState then
                        if tonumber(playerInfo[2]) == playerState.PlayerUId.A then
                            return player
                        end
                    end
                end
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