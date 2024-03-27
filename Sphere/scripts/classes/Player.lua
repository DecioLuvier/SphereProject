local self = {}

---@param PlayerController APalPlayerController
---@return string
function self.GetName(PlayerController)
    PalLuaApi.Logger.Log(string.format("Player.GetName %s", PlayerController:GetFullName()))
    return PlayerController.PlayerState.PlayerNamePrivate:ToString()
end

---@param PlayerController APalPlayerController
---@return FVector
function self.GetLocation(PlayerController)
    PalLuaApi.Logger.Log(string.format("Player.GetLocation %s", PlayerController:GetFullName()))
    return PalLuaApi.structs.FVector.translate(PlayerController.Character.ReplicatedMovement.Location)
end

---@param id number
---@return APalPlayerController
function self.GetControllerById(id)
    PalLuaApi.Logger.Log(string.format("Player.GetControllerById %s", id))
    local palUtility =  PalLuaApi.Static.PalUtility
    local world = PalLuaApi.Static.World
    local allPlayersInfo = palUtility:GetPlayerListDisplayMessages(world) 
    if allPlayersInfo then
        for i = 1, #allPlayersInfo do
            local playerInfoString = allPlayersInfo[i]:get():ToString()
            PalLuaApi.Logger.Log(string.format("%i° = %s", i, playerInfoString))
            local last_comma = playerInfoString:find(",[^,]*$", 1)
            local second_comma = playerInfoString:find(",[^,]*,[^,]*$", 1)
            local SteamID = tonumber(playerInfoString:sub(last_comma + 1))
            local Uid = tonumber(playerInfoString:sub(second_comma + 1, last_comma - 1))
            if id == SteamID or id == Uid then
                local palPlayerCharacter = palUtility:GetPlayerCharacterByPlayerIndex(world, i - 1)
                PalLuaApi.Logger.Log(palPlayerCharacter:GetFullName())
                return palPlayerCharacter:GetPalPlayerController()
            end
        end
    end
    return nil
end

return self