--
-- spawner.lua
--
-- Copyright (c) 2024 DecioLuvier
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of
-- this software and associated documentation files (the "Software"), to deal in
-- the Software without restriction, including without limitation the rights to
-- use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
-- of the Software, and to permit persons to whom the Software is furnished to do
-- so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
--

local Admin = require("scripts/Admin")
local Monster = require("scripts/Monster")
local Ue4ss = require("scripts/Ue4ss")
local Static = require("scripts/Static")
local Debugger = require("scripts/Debugger")

local FPalSpawnerGroupList = require("constructors/FPalSpawnerGroupList")
local FPalSpawnerGroupInfo = require("constructors/FPalSpawnerGroupInfo")
local FPalSpawnerOneTribeInfo = require("constructors/FPalSpawnerOneTribeInfo")
local FPalDataTableRowName_PalHumanData = require("constructors/FPalDataTableRowName_PalHumanData")
local FPalDataTableRowName_PalMonsterData = require("constructors/FPalDataTableRowName_PalMonsterData")

local PassiveSkills = require("enums/PassiveSkills")

local Spawner = {}

Spawner.queue = {}

---@param SpawnedInstance APalCharacter
---@param TargetInstance APalPlayerCharacter|APalCharacter
function Spawner.CallbackTeleportToCharacter(SpawnedInstance,TargetInstance)
    Admin.TeleportCharacterToCharacter(SpawnedInstance,TargetInstance)
end

---@param SpawnedInstance APalCharacter
---@param PlayerInstance APalPlayerCharacter
function Spawner.CallbackCaptureToPlayer(SpawnedInstance,PlayerInstance)
    Admin.ForceCaptureToPlayer(SpawnedInstance,PlayerInstance)
end

---@param MonsterData table
---@param PostCallback function
---@param CallbackParameters table
function Spawner.Spawn(MonsterData,PostCallback,CallbackParameters) 
    local palID = Monster.IsMonsterDebugNameValid(MonsterData["ID"])
    local npcID = Monster.IsMonsterDebugNameValid(MonsterData["ID"])

    if palID == "None" and npcID == "None" then
        Debugger.log("ID to spawn monster not found")
    else
        local Level = tonumber(MonsterData["Level"]) 
        local Level_Max = tonumber(MonsterData["Level_Max"]) 
        local Num = tonumber(MonsterData["Num"]) 
        local Num_Max = tonumber(MonsterData["Num_Max"]) 

        if not Level and Level_Max and Num and Num_Max then
            Debugger.log("Level or Number to spawn monster not found")
        else
            local spawningMonster = FPalSpawnerOneTribeInfo.new(
                FPalDataTableRowName_PalMonsterData.new(FName(palID)),
                FPalDataTableRowName_PalHumanData.new(FName(npcID)),
                1,      --Here we define the level 1 as independent of situation because we will 
                1,  --level up to the desired level using give xp to fix the HP gain by talent and rank
                Num,
                Num_Max
            )
            local monsterGroup = FPalSpawnerGroupInfo.new(
                150, --I didn't find the purpose of this here
                0, --Undefined = 0    Day = 1    Night = 2  EPalOneDayTimeType_MAX = 3
                0, --Undefined = 0,Sun = 1,Cloud = 2,Rain = 3,Thunder = 4,Snow = 5,Fog = 6,Storm = 7,Snowstorm = 8,EPalWeatherConditionType_MAX = 9
                { 
                    spawningMonster --Important, in the future should be used to spawn an entire group, more info ahead.
                } 
            ) 
            --The main idea of how the code works is to search all spawners and when find one compatible with the conditions, 
            --change all spawn possibilities to the monster we want and force to spawn, calling a person function when instance is created
            --and go back to the default so as not to cause problems in the palworld eco system
            local allPalSpawner =  FindAllOf("BP_PalSpawner_Standard_C") ---@type ABP_PalSpawner_Standard_C[]       
            for i = 1,  #allPalSpawner do
                local palSpawner =  allPalSpawner[i]  

                if palSpawner.SpawnerType == 0 then --Check if not a boss
                    local alreadyPals = palSpawner.IndividualHandleList 
                    
                    if alreadyPals:GetArrayNum() == 0 then --Check if no pal spawned
                        local SpawnerGroupList = palSpawner.SpawnGroupList 
                        --This part is very poorly optimized and should change in future versions.
                        --One of the main problems I'm having is: When I use Empty() to a Tarray, 
                        --I really can't inject information again because UE4SS does not currently support. :(
                        --If you have any idea to pass this, please tell me.
                        local originalSpawnGroupList = FPalSpawnerGroupList.translate(SpawnerGroupList)
                        local desiredSpawnGroupList = {} 
                        for j = 1, SpawnerGroupList:GetArrayNum()  do
                            if  SpawnerGroupList[j].PalList:GetArrayNum() > 1 then
                                goto skip --This here is a countermeasure for spawners that for some reason have two spawningMonsters, normally they are NPCs.
                            end
                            desiredSpawnGroupList[j] = monsterGroup
                        end
                        Ue4ss.Merge(SpawnerGroupList,desiredSpawnGroupList)
                        palSpawner:SpawnRequest_ByOutside(true) --crashes when false for some reason
                        Ue4ss.Merge(SpawnerGroupList,originalSpawnGroupList) --reset default spawn options
                        --And now, we use the hook below for wait a instance to spawn 
                        --for not have the problem of returning some nil and crashing the server
                        Spawner.queue[tostring(palSpawner:GetAddress())] = {MonsterData,PostCallback,CallbackParameters}
                        break  
                    end
                end
                ::skip::
            end
        end
    end
end

ExecuteWithDelay(5000, function()
    RegisterHook("/Game/Pal/Blueprint/Spawner/BP_PalSpawner_Standard.BP_PalSpawner_Standard_C:FindIndividualHandle", function(self,batata)
        --And now we can finally customize the monster
        local palSpawner = self:get()
        local key =  tostring(palSpawner:GetAddress())
        local match =  Spawner.queue[key]
    
        if match then 
            local MonsterData = match[1]
            local PostCallback = match[2]
            local CallbackParameters = match[3]
            local alreadyPals = palSpawner.IndividualHandleList
            for k = 1, palSpawner.IndividualHandleList:GetArrayNum() do
                local IndividualCharacterHandle = alreadyPals[k] ---@type UPalIndividualCharacterHandle
                local spawnedInstance = IndividualCharacterHandle:TryGetIndividualActor()
                local IndividualParameter = IndividualCharacterHandle:TryGetIndividualParameter()
                local SaveParameter = IndividualParameter.SaveParameter
                local statsToChange = MonsterData["Stats"]
                local PassiveSkillList = MonsterData["PassiveSkillList"]
                local EquipedSkills = MonsterData["EquipedSkills"]
                local MasteredSkills = MonsterData["MasteredSkills"]
    
                if statsToChange then
                    Ue4ss.Merge(SaveParameter, statsToChange)
                end
                local PalExpDatabase = Static.GetPalExpDatabase()
                local expNeeded = PalExpDatabase.GetTotalExp(math.random(MonsterData["Level"], MonsterData["Level_Max"]),false)
                Admin.GiveXpToMonster(spawnedInstance,expNeeded)
    
                if PassiveSkillList then
                    SaveParameter.PassiveSkillList:Empty()
                    for l = 1, #PassiveSkillList do
                        IndividualParameter.AddPassiveSkill(FName("None"),FName(PassiveSkills[PassiveSkillList[l]]), FName("None"))
                    end 
                end
    
                if EquipedSkills then
                    local ValidEquipedSkills = {}
                    for l = 1, #EquipedSkills do
                        local _waza = Monster.CanLearnWaza(MonsterData["ID"],EquipedSkills[l])
                        if _waza then
                            ValidEquipedSkills[#ValidEquipedSkills + 1] = _waza
                        end
                    end      
                    IndividualParameter.ClearEquipWaza()
                    for l = 1, #ValidEquipedSkills do
                        IndividualParameter.AddEquipWaza(ValidEquipedSkills[l])
                    end
                end
    
                if MasteredSkills then
                    local ValidMasteredSkills = {}
                    for l = 1, #MasteredSkills do
                        local _waza = Monster.CanLearnWaza(MonsterData["ID"],MasteredSkills[l])
                        if _waza then
                            ValidMasteredSkills[#ValidMasteredSkills + 1] = _waza
                        end
                    end      
                    SaveParameter.MasteredWaza:Empty()
                    for l = 1, #ValidMasteredSkills do
                        SaveParameter.MasteredWaza[l + 1] = FName("None")
                        SaveParameter.MasteredWaza[l] = ValidMasteredSkills[l]
                    end
                end
                PostCallback(spawnedInstance, table.unpack(CallbackParameters))
            end
            Spawner.queue[key] = nil
        end
    end) 
end)



return Spawner