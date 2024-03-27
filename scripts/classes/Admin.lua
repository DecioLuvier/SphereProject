local self = {}

---@param Character APalCharacter
---@param Exp number
function self.GiveXpToMonster(Character,Exp)
    PalLuaApi.Logger.Log(string.format("Admin.GiveXpToMonster %s %s", Character:GetFullName(), Exp))
    local palUtility =  PalLuaApi.Static.PalUtility
    palUtility:GiveExpToAroundCharacter(Character,PalLuaApi.structs.FVector.translate(Character.CharacterMovement.LastUpdateLocation),10,Exp,Character.CharacterParameterComponent.IndividualParameter.SaveParameter.CharacterClass, false)  
end

---@param Character APalPlayerCharacter
---@param Exp number
function self.GiveXpToPlayer(Character,Exp)
    PalLuaApi.Logger.Log(string.format("Admin.GiveXpToPlayer %s %s", Character:GetFullName(), Exp))
    Character.PlayerState:GrantExpForParty(Exp)
end

---@param PlayerController APalPlayerController
---@param ItemID string
---@param Quantity number
function self.GiveItemToPlayer(PlayerController, ItemID, Quantity)
    PalLuaApi.Logger.Log(string.format("Admin.GiveItemToPlayer %s %s %s", PlayerController:GetFullName(), ItemID, Quantity))
    local playerCharacter = PlayerController:GetControlPalCharacter()
    local NetworkTransmitter = PalLuaApi.Static.PalUtility:GetNetworkTransmitterByPlayerCharacter(playerCharacter)
    local PalNetworkPlayerComponent =  NetworkTransmitter:GetPlayer()
    PalNetworkPlayerComponent:RequestAddItem_ToServer(FName(ItemID), Quantity, true)
end

---@param Character APalCharacter
---@param Target APalCharacter
function self.TeleportCharacterToCharacter(Character, Target)
    PalLuaApi.Logger.Log(string.format("Admin.TeleportCharacterToCharacter %s %s", Character:GetFullName(), Target:GetFullName()))
    local locationTarget =  PalLuaApi.structs.FVector.translate(Target.CharacterMovement.LastUpdateLocation)
    local FQuat = {X = 0,Y = 0,Z = 0,W = 0,}
    PalLuaApi.Static.PalUtility:TeleportAroundLoccation(Character, locationTarget, FQuat)
end

---@param Character APalCharacter
---@param Target FVector
function self.TeleportCharacterToLocation(Character, Target)
    PalLuaApi.Logger.Log(string.format("Admin.TeleportCharacterToLocation %s", Character:GetFullName()))
    local FQuat = {X = 0,Y = 0,Z = 0,W = 0,}
    PalLuaApi.Static.PalUtility:TeleportAroundLoccation(Character, Target, FQuat)
end

---@param SpawnedInstance APalCharacter
---@param PlayerInstance APalPlayerCharacter
function self.ForceCaptureToPlayer(SpawnedInstance,PlayerInstance)
    PalLuaApi.Logger.Log(string.format("Admin.ForceCaptureToPlayer %s %s", SpawnedInstance:GetFullName(), PlayerInstance:GetFullName()))
    PalLuaApi.Static.PalUtility:PalCaptureSuccess(PlayerInstance, SpawnedInstance)
end

return self