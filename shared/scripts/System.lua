local Static = require("scripts/Static")
local Logger = require("libs/Logger")
local FGuid = require("constructors/FGuid")

local System = {}

---@param PalPlayerController APalPlayerController
---@param Message string
function System.SendSystemToPlayer(PalPlayerController, Message)
    local PalUtility = Static.GetPalUtility()
    Logger.Log(Message)
    local PalPlayerState = PalPlayerController:GetPalPlayerState()
    PalUtility:SendSystemToPlayerChat(Static.GetWorld(), string.format("Sphere - %s", Message), FGuid.translate(PalPlayerState.PlayerUId))
end

---@param Message string
function System.SendSystemAnnounce(Message)
    local PalUtility = Static.GetPalUtility()
    Logger.Log(Message)
    PalUtility:SendSystemAnnounce(Static.GetWorld(), string.format("%s", Message))
end

---@param instance APalCharacter
---@return string
function System.GetInstanceType(instance)
    local PalUtility = Static.GetPalUtility()

    if instance == nil then
        return "Undefined"
    elseif PalUtility:IsOtomo(instance) then
        return "Otomo"
    elseif instance:IsPlayerControlled() then
        return "Player"
    elseif PalUtility:IsBaseCampPal(instance) then
        return "BaseCampPal"
    elseif PalUtility:IsPalMonster(instance) then 
        return "PalMonster"
    elseif PalUtility:IsWildNPC(instance) then
        return "WildNPC"
    else
        return "Undefined"
    end
end

return System