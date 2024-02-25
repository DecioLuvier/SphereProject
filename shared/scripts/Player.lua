local Static = require("scripts/Static")

local Permissions = require("enums/Permissions")

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

---@param input string
---@param target string
function Player.ComparatePermissionLevel(input,target)
    if Permissions[input] >= Permissions[target] then
        return true
    else
        return false
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

---@param Id number|string
---@return APalPlayerController
function Player.GetController(Id)
    local idNumber = tonumber(Id)
    if idNumber then --If the ID has a letter or nil just ignore
        local players = FindAllOf("PalPlayerController")
        for i = 1, #players do
            local player = players[i] ---@type APalPlayerController
            local playerState = player:GetPalPlayerState()
            if playerState then
                if idNumber == playerState.PlayerUId.A then
                    return player
                end
            end
            if idNumber == playerState.PlayerId then
                return player
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