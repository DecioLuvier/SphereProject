local Static = require("scripts/Static")
local Debugger = require("scripts/Debugger")

local FGuid = require("constructors/FGuid")

local System = {}

---@param PalPlayerController APalPlayerController
---@param Message string
function System.SendSystemToPlayer(PalPlayerController, Message)
    local PalUtility = Static.GetPalUtility()
    local PalPlayerState = PalPlayerController:GetPalPlayerState()
    PalUtility:SendSystemToPlayerChat(PalPlayerState, Message, FGuid.translate(PalPlayerState.PlayerUId))
    Debugger.log(Message)
end

---@param PalPlayerCharacter APalPlayerController
---@param Message string
function System.SendSystemAnnounce(PalPlayerCharacter, Message)
    local PalUtility = Static.GetPalUtility()
    PalUtility:SendSystemAnnounce(PalPlayerCharacter, Message)
    Debugger.log(string.format("[%s] %s", "System", Message))
end

--[[
local function GetAllPlayersInfo() 
    local palUtility = StaticFindObject("/Script/Pal.Default__PalUtility") ---@type UPalUtility
    local palPlayerController =  FindFirstOf("PalPlayerController") ---@type APalPlayerController
    --I have no idea why, but it seems like you need a player to call this here, 
    --it doesn't seem to make a difference who calls it however
    local allPlayersInfo = palUtility:GetPlayerListDisplayMessages(palPlayerController) 

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
            local playerName = playerInfo[1] --"Luvier"
            local PlayerUId = playerInfo[2] --"806377371"
            local playerSteamID = playerInfo[3] --"76561198071615417"

        end
    end
    return nil
end
]]

return System