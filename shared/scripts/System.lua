local Static = require("scripts/Static")
local Logger = require("libs/Logger")
local FGuid = require("constructors/FGuid")

local System = {}

System.prefix = "Sphere -" 

---@param PalPlayerController APalPlayerController
---@param Message string
function System.SendSystemToPlayer(PalPlayerController, Message)
    local PalUtility = Static.GetPalUtility()
    Logger.Log(Message)
    local PalPlayerState = PalPlayerController:GetPalPlayerState()
    PalUtility:SendSystemToPlayerChat(PalPlayerState, string.format("%s %s", System.prefix, Message), FGuid.translate(PalPlayerState.PlayerUId))
end

---@param PalPlayerCharacter APalPlayerController
---@param Message string
function System.SendSystemAnnounce(PalPlayerCharacter, Message)
    local PalUtility = Static.GetPalUtility()
    Logger.Log(Message)
    PalUtility:SendSystemAnnounce(PalPlayerCharacter, string.format("%s %s", System.prefix, Message))
end

return System