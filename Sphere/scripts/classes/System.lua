local self = {}

---@param PalPlayerController APalPlayerController
---@param Message string
function self.SendSystemToPlayer(PalPlayerController, Message)
    PalLuaApi.Logger.Log(string.format("System.SendSystemToPlayer %s %s", PalPlayerController:GetFullName(), Message))
    local palUtility =  PalLuaApi.Static.PalUtility
    local world = PalLuaApi.Static.World
    local playerState = PalPlayerController.PlayerState
    local playerUid = PalLuaApi.structs.FGuid.translate(playerState.PlayerUId)
    palUtility:SendSystemToPlayerChat(world, Message, playerUid)
end

---@param Message string
function self.SendSystemAnnounce(Message)
    PalLuaApi.Logger.Log(string.format("System.SendSystemAnnounce %s", Message))
    local palUtility =  PalLuaApi.Static.PalUtility
    local world = PalLuaApi.Static.World
    palUtility:SendSystemAnnounce(world, Message)
end

---@param instance APalCharacter
---@return string
function self.GetInstanceType(instance)
    PalLuaApi.Logger.Log(string.format("System.GetInstanceType %s", instance:GetFullName()))
    local palUtility =  PalLuaApi.Static.PalUtility
    if instance == nil then
        return "Undefined"
    elseif palUtility:IsOtomo(instance) then
        return "Otomo"
    elseif type(instance.PlayerCameraYaw) == "number" then
        return "Player"
    elseif palUtility:IsBaseCampPal(instance) then
        return "BaseCampPal"
    elseif palUtility:IsPalMonster(instance) then 
        return "PalMonster"
    elseif palUtility:IsWildNPC(instance) then
        return "WildNPC"
    else
        return "Undefined"
    end
end

---@param instance APalCharacter
---@return UPalGroupGuildBase 
function self.GetBaseCampPalGuild(instance) 
    local instanceBaseCampID = PalLuaApi.structs.FGuid.translate( instance.CharacterParameterComponent.IndividualParameter.BaseCampId)
    local allGuilds = FindAllOf("PalGroupGuildBase")

    for _, guild in ipairs(allGuilds) do
        for index = 1, guild.BaseCampIds:GetArrayNum() do
            if PalLuaApi.Utilities.CompareTables(PalLuaApi.structs.FGuid.translate(guild.BaseCampIds[index]), instanceBaseCampID) then
                return guild
            end
        end
    end
end

return self