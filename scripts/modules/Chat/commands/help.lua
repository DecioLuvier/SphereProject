local self = {}

self.adminOnly = false

---@param Sender APalPlayerController
---@param Arguments string[]
function self.execute(Sender, Arguments)
    local translation = PalLuaApi.Modules.Chat.database.Translation.data
    local commands = PalLuaApi.Modules.Chat.commands

    if Arguments[2] then
        local command = PalLuaApi.Utilities.GetFirstTableValue(commands, Arguments[2])
        if command and command.help then
            if not command.adminOnly or Sender.bAdmin then
                PalLuaApi.System.SendSystemToPlayer(Sender, command.help())
            end
        end
    else
        local message = ""
        for commandName, command in pairs(commands) do
            if not command.adminOnly or Sender.bAdmin then
                message = message .. string.format(" /%s;", commandName)
            end
        end
        PalLuaApi.System.SendSystemToPlayer(Sender, string.format("%s %s", translation.CommandsAvailable, message))
    end
end

return self