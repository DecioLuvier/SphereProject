local Static = require("scripts/Static")

local FGuid = require("constructors/FGuid")

local System = {}

System.prefix = "Sphere -" 

---@param PalPlayerController APalPlayerController
---@param Message string
function System.SendSystemToPlayer(PalPlayerController, Message)
    local PalUtility = Static.GetPalUtility()
    local PalPlayerState = PalPlayerController:GetPalPlayerState()
    PalUtility:SendSystemToPlayerChat(PalPlayerState, string.format("%s %s", System.prefix, Message), FGuid.translate(PalPlayerState.PlayerUId))
end

---@param PalPlayerCharacter APalPlayerController
---@param Message string
function System.SendSystemAnnounce(PalPlayerCharacter, Message)
    local PalUtility = Static.GetPalUtility()
    PalUtility:SendSystemAnnounce(PalPlayerCharacter, string.format("%s %s", System.prefix, Message))
end

return System