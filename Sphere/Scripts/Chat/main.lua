--The inspiration for creating this plugin came from the repository 
--https://github.com/aytimothy/PalworldEssentials/

local Debugger = require("scripts/Debugger")
local Player = require("scripts/Player")
local System = require("scripts/System")

local manager = require("./manager")
local commands = manager["commands"]
local ignore = manager["ignore"]

---@param message FPalChatMessage
local function FormatChatMessage(message)
    local sender = message.Sender:ToString()
    local messageType = message.Category
    local message = message.Message:ToString()
    local messageTypeText = "None"

    if messageType == 1 then
        messageTypeText = "Global"
    elseif messageType == 2 then
        messageTypeText = "Guild"
    elseif messageType == 3 then
        messageTypeText = "Say"
    end
    return string.format("[%s] %s: %s", messageTypeText, sender, message)
end

---@param Command string
---@return string[]
local function GetArguments(Command)
    local Arguments = {}
    for argument in Command:gmatch("%S+") do
        table.insert(Arguments, argument)
    end
    return Arguments
end

---@param player APalPlayerController
---@param ChatMessage FPalChatMessage
local function ListenChatMessage(player, ChatMessage)
    local messageText = ChatMessage.Message:ToString()
    Debugger.log(FormatChatMessage(ChatMessage))
    
    if string.match(messageText, "^/") then
        local commandString = string.sub(messageText, 2)
        local commandArgs = GetArguments(commandString)

        if commandArgs[1] then
            local selectedCommand = commandArgs[1]

            if not ignore[selectedCommand] then

                ChatMessage.SenderPlayerUId["A"] = 2345678   --Remove default system message making "miss" target, 
                ChatMessage.ReceiverPlayerUId["A"] = 2345678 --This should be revised in future versions

                if commands[selectedCommand] then
                    if Player.ComparatePermissionLevel(Player.GetPermissionName(player), commands[selectedCommand].permissionLevel) then
                        commands[selectedCommand].execute(player, commandArgs)
                    else
                        System.SendSystemToPlayer(player, "Denied access")
                    end
                else
                    System.SendSystemToPlayer(player, "Command Not Found")
                end
            end
        end
    end
end

RegisterHook("/Script/Pal.PalPlayerState:EnterChat_Receive", function(self, ChatMessage)
    local PalPlayerState = self:get() ---@type APalPlayerState
    local ChatMessage = ChatMessage:get() ---@type FPalChatMessage
    local palPlayerController = Player.GetController(PalPlayerState.PlayerId)
    ListenChatMessage(palPlayerController, ChatMessage)
    self:get().ChatCounter = 0 --Remove chat restriction
end)

RegisterHook("/Script/Pal.PalPlayerCharacter:OnCompleteInitializeParameter", function(self)
    local palPlayerCharacter = self:get() ---@type APalPlayerCharacter
    local palPlayerController =  palPlayerCharacter:GetPalPlayerController()
    local playerName = Player.GetName(palPlayerController)
    local playerEnterMessage = string.format("%s joined the game!", playerName)
    System.SendSystemAnnounce(palPlayerController, playerEnterMessage)
end)

RegisterHook("/Script/Pal.PalPlayerController:OnDestroyPawn", function(self)
    local palPlayerController = self:get() ---@type APalPlayerController
    local playerName = Player.GetName(palPlayerController)
    local playerLeaveMessage = string.format("%s disconnected.", playerName)
    System.SendSystemAnnounce(palPlayerController, playerLeaveMessage)
end)