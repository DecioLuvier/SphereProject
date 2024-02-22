local Static = require("scripts/Static")
local Debbuger = require("scripts/Debbuger")

local FGuid = require("constructors/FGuid")

local System = {}

---@param PalPlayerController APalPlayerController
---@param Message string
function System.SendSystemToPlayer(PalPlayerController, Message)
    local PalUtility = Static.GetPalUtility()
    local PalPlayerState = PalPlayerController:GetPalPlayerState()
    PalUtility:SendSystemToPlayerChat(PalPlayerState, Message, FGuid.translate(PalPlayerState.PlayerUId))
    Debbuger.log(Message)
end

---@param PalPlayerCharacter APalPlayerController
---@param Message string
function System.SendSystemAnnounce(PalPlayerCharacter, Message)
    local PalUtility = Static.GetPalUtility()
    PalUtility:SendSystemAnnounce(PalPlayerCharacter, Message)
    Debbuger.log(string.format("[%s] %s", "System", Message))
end

return System