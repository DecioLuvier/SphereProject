local self = {}

self.database = {
    Config = {
        folderPath = "Sphere\\",
        fileName = "Chat",
        copyDefault = true,
        overwrite = false,
        schema = require("modules/Chat/schemas/config"),
    },
    Translation = {
        folderPath = "Sphere\\Translations\\",
        fileName = "Chat",
        copyDefault = true,
        overwrite = false,
        schema = require("modules/Chat/schemas/translation"),
    },
    Kits = {
        folderPath = "Sphere\\",
        fileName = "Kits",
        copyDefault = true,
        overwrite = false,
        schema = require("modules/Chat/schemas/Kits")
    }
}

self.commands = {
    tp = require("modules/Chat/commands/teleport"),
    kit = require("modules/Chat/commands/kit"),
    spawn = require("modules/Chat/commands/spawn"),
    gpal = require("modules/Chat/commands/givepal"),
    reloadsphere = require("modules/Chat/commands/reload"),
    help = require("modules/Chat/commands/help")
}

---@param PalPlayerState APalPlayerState
---@param ChatMessage FPalChatMessage
function self.EnterChat_Receive(PalPlayerState, ChatMessage)
    local Config = PalLuaApi.Modules.Chat.database.Config.data
    local Translation = PalLuaApi.Modules.Chat.database.Translation.data

    local sender = ChatMessage.Sender:ToString()
    local messageType = ChatMessage.Category
    local message = ChatMessage.Message:ToString()
    local messageTypeText = "Undefined"
    if messageType == 1 then
        messageTypeText = Translation.Global
    elseif messageType == 2 then
        messageTypeText = Translation.Guild
    elseif messageType == 3 then
        messageTypeText = Translation.Say
    end

    if Config.ShowGameChatOnConsole then
        PalLuaApi.Logger.Print(string.format("%s %s: %s", messageTypeText, sender, message))
    else
        PalLuaApi.Logger.Log(string.format("%s %s: %s", messageTypeText, sender, message))
    end

    if string.match(message, "^/") then 
        local commandArgs = {}
        for argument in string.sub(message, 2):gmatch("%S+") do
            table.insert(commandArgs, argument)
        end

        if commandArgs[1] then
            if PalLuaApi.Utilities.ArrayContainValue(Config.NonSphereCommands, commandArgs[1]) then
                PalLuaApi.Logger.Log(string.format("Executing NonSphereCommand %s", commandArgs[1]))
            else
                PalLuaApi.Logger.Log(string.format("Executing SphereCommand, %s", commandArgs[1]))
                ChatMessage.SenderPlayerUId["A"] = -1  
                ChatMessage.ReceiverPlayerUId["A"] = -1
                local command = PalLuaApi.Utilities.GetFirstTableValue(self.commands, commandArgs[1])
                local playerController = PalPlayerState.PawnPrivate.Controller

                if command ~= nil then
                    if playerController.bAdmin then
                        command.execute(playerController, commandArgs)
                    else
                        if command.adminOnly then
                            PalLuaApi.System.SendSystemToPlayer(playerController, Translation.DeniedAccess)
                        else
                            command.execute(playerController, commandArgs)
                        end
                    end
                else
                    PalLuaApi.System.SendSystemToPlayer(playerController, Translation.CommandNotFound)
                end
            end
        end
    end

    PalPlayerState.ChatCounter = 0 
end

return self