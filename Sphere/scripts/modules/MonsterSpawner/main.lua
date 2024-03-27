local self = {}

self.database = {
    Monster = {
        folderPath = "Sphere\\",
        fileName = "Monsters",
        copyDefault = true,
        overwrite = false,
        schema = require("modules/MonsterSpawner/schemas/Monster")
    }
}

self.queue = {}

---@param SpawnedInstance APalCharacter
---@param PlayerInstance APalPlayerCharacter
function self.CallbackCaptureToPlayer(SpawnedInstance,PlayerInstance)
    PalLuaApi.Admin.ForceCaptureToPlayer(SpawnedInstance,PlayerInstance)
end

---@param SpawnedInstance APalCharacter
---@param TargetInstance APalPlayerCharacter|APalCharacter
function self.CallbackTeleportToCharacter(SpawnedInstance,TargetInstance)
    PalLuaApi.Admin.TeleportCharacterToCharacter(SpawnedInstance,TargetInstance)
end

---@param Point1 FVector
---@param Point2 FVector
local function EuclideanDistance(Point1, Point2)
    local sum = 0
    for key, value in pairs(Point1) do
        sum = sum + (value - Point2[key])^2
    end
    return math.sqrt(sum)
end

---@param MonsterData table
---@param Location FVector
---@param PostCallback function
---@param CallbackParameters table
function self.Spawn(MonsterData, Location, PostCallback, CallbackParameters) 
    local allPalSpawner =  FindAllOf("BP_PalSpawner_Standard_C") ---@type ABP_PalSpawner_Standard_C[]   
    local nearestSpawner = nil

    local distance = nil
    for _, palSpawner in ipairs(allPalSpawner) do
        local spawnerLocation = PalLuaApi.structs.FVector.translate(palSpawner.BattleStartLocation)

        if nearestSpawner == nil then
            nearestSpawner = palSpawner
            distance = EuclideanDistance(spawnerLocation, Location)
        else
            local newDistance = EuclideanDistance(spawnerLocation, Location)
            if distance > newDistance then
                nearestSpawner = palSpawner
                distance = newDistance
            end
        end
    end

    local SpawnerGroupList = nearestSpawner.SpawnGroupList 
    local originalSpawnGroupList = PalLuaApi.structs.FPalSpawnerGroupList.translate(SpawnerGroupList)

    local desiredSpawnGroupList = {}
    for i = 1, SpawnerGroupList:GetArrayNum()  do
        desiredSpawnGroupList[i] = {
            Weight = 150,
            OnlyTime = 0,
            OnlyWeather = 0,
            PalList = {}, 
        }
        for j = 1, SpawnerGroupList[i].PalList:GetArrayNum()  do
            desiredSpawnGroupList[i].PalList[j] = {
                PalID = { 
                    Key = FName("None")
                },
                NPCID = { 
                    Key = FName("None")
                },
                Level = 1,
                Level_Max = 1,
                Num = MonsterData.Quantity,
                Num_Max = MonsterData.Quantity 
            }

            if j == 1 then
                if PalLuaApi.Enums.Npcs[MonsterData.DebugID] then
                    desiredSpawnGroupList[i].PalList[j].NPCID.Key = FName(MonsterData.DebugID)
                else
                    desiredSpawnGroupList[i].PalList[j].PalID.Key = FName(MonsterData.DebugID)
                end
            end
        end
    end

    PalLuaApi.Utilities.MergeTables(SpawnerGroupList,desiredSpawnGroupList)
    nearestSpawner:SpawnRequest_ByOutside(true) 
    PalLuaApi.Utilities.MergeTables(SpawnerGroupList,originalSpawnGroupList) 
    local key = tostring(nearestSpawner:GetAddress())
    self.queue[key] = {MonsterData,PostCallback,CallbackParameters}
end

---@param PalSpawner ABP_PalSpawner_Standard_C
function self.FindIndividualHandle(PalSpawner)
    local key =  tostring(PalSpawner:GetAddress())
    local match =  self.queue[key]
    if match then 
        local MonsterData = match[1]
        local PostCallback = match[2]
        local CallbackParameters = match[3]
        local alreadyPals = PalSpawner.IndividualHandleList
        
        for k = 1, PalSpawner.IndividualHandleList:GetArrayNum() do
            local IndividualCharacterHandle = alreadyPals[k] ---@type UPalIndividualCharacterHandle
            local spawnedInstance = IndividualCharacterHandle:TryGetIndividualActor()
            local IndividualParameter = IndividualCharacterHandle:TryGetIndividualParameter()
            local SaveParameter = IndividualParameter.SaveParameter
            local statsToChange = MonsterData["Stats"]
            local PassiveSkillList = MonsterData["PassiveSkillList"]
            local EquipedSkills = MonsterData["EquipedSkills"]
            local MasteredSkills = MonsterData["MasteredSkills"]
            local WildHPMultiplier = MonsterData["WildHPMultiplier"]

            if statsToChange then
                PalLuaApi.Utilities.MergeTables(SaveParameter, statsToChange)
            end
            local expNeeded = PalLuaApi.Static.PalExpDatabase:GetTotalExp(MonsterData["Level"], false)
            PalLuaApi.Admin.GiveXpToMonster(spawnedInstance,expNeeded)

            if PassiveSkillList then
                SaveParameter.PassiveSkillList:Empty()
                for l = 1, #PassiveSkillList do
                    local passiveSkill = PalLuaApi.Enums.PassiveSkills[PassiveSkillList[l]]
                    if passiveSkill then
                        IndividualParameter.AddPassiveSkill(FName("None"),FName(passiveSkill), FName("None"))
                    end
                end 
            end

            if EquipedSkills then
                IndividualParameter:ClearEquipWaza()
                for l = 1, #EquipedSkills do
                    local skill = PalLuaApi.Enums.Skills[EquipedSkills[l]]
                    if skill then
                        IndividualParameter:AddEquipWaza(skill)
                    end
                end
            end

            if MasteredSkills then
                SaveParameter.MasteredWaza:Empty()
                for l = 1, #MasteredSkills do
                    SaveParameter.MasteredWaza[l + 1] = FName("None")
                    local skill = PalLuaApi.Enums.Skills[MasteredSkills[l]]
                    if skill then
                        SaveParameter.MasteredWaza[l] = MasteredSkills[l]
                    end
                end
            end

            if WildHPMultiplier and (PostCallback ~= self.CallbackCaptureToPlayer) then
                SaveParameter.HP.Value = SaveParameter.HP.Value * WildHPMultiplier
            end
        

            PostCallback(spawnedInstance, table.unpack(CallbackParameters))
        end

        self.queue[key] = nil
    end
end

return self