local self = {}

self.adminOnly = true

---@return string
function self.help()
    local Monsters = PalLuaApi.Modules.MonsterSpawner.database.Monster.data
    local MonstersNames = {}
    
    for MonsterNames, _ in pairs(Monsters) do
        table.insert(MonstersNames, MonsterNames)
    end
    
    return "DataPalName: ".. table.concat(MonstersNames, "; ")    
end

---@param Sender APalPlayerController
---@param Arguments string[]
function self.execute(Sender, Arguments)
    local translation = PalLuaApi.Modules.Chat.database.Translation.data
    local message = translation.GivePalUsage

    if Arguments[2] then
        local targetPlayer = Sender
        local dataMonsterName = Arguments[2]
        if Arguments[3] then
            targetPlayer = PalLuaApi.Player.GetControllerById(tonumber(Arguments[2]))
            dataMonsterName = Arguments[3]
        end
        if targetPlayer then
            local dataMonster = PalLuaApi.Utilities.GetFirstTableValue(PalLuaApi.Modules.MonsterSpawner.database.Monster.data, dataMonsterName)

            if dataMonster then
                PalLuaApi.Modules.MonsterSpawner.Spawn(dataMonster, PalLuaApi.Player.GetLocation(Sender), PalLuaApi.Modules.MonsterSpawner.CallbackCaptureToPlayer, { Sender.Character })
                message = translation.Success
            else
                message = translation.Invalid
            end
        else
            message = translation.TargetNotFound
        end
    end

    PalLuaApi.System.SendSystemToPlayer(Sender, message)
end

return self