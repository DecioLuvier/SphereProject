local self = {}

self.adminOnly = true

---@param Sender APalPlayerController
---@param Arguments string[]
function self.execute(Sender, Arguments)
    local translation = PalLuaApi.Modules.Chat.database.Translation.data
    PalLuaApi.Manager.refreshAllDatabases()
    PalLuaApi.System.SendSystemToPlayer(Sender, translation.CheckConsole)
end

return self