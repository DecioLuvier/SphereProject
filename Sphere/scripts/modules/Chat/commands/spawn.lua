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
    local message = translation.SpawnUsage

    if Arguments[2] then
        local dataMonster = PalLuaApi.Utilities.GetFirstTableValue(PalLuaApi.Modules.MonsterSpawner.database.Monster.data, Arguments[2])

        if dataMonster then
            PalLuaApi.Modules.MonsterSpawner.Spawn(dataMonster, PalLuaApi.Player.GetLocation(Sender), PalLuaApi.Modules.MonsterSpawner.CallbackTeleportToCharacter, { Sender.Character })
            message = translation.Success
        else
            message = translation.Invalid
        end
    end

    PalLuaApi.System.SendSystemToPlayer(Sender, message)
end

return self