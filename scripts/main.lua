PalLuaApi = {}
PalLuaApi.Enums = {}
PalLuaApi.Enums.Items = require("enums/Items")
PalLuaApi.Enums.Npcs = require("enums/Npcs")
PalLuaApi.Enums.Pals = require("enums/Pals")
PalLuaApi.Enums.PalsFruitsSkills = require("enums/PalsFruitsSkills")
PalLuaApi.Enums.PalsLevelSkills = require("enums/PalsLevelSkills")
PalLuaApi.Enums.PassiveSkills = require("enums/PassiveSkills")
PalLuaApi.Enums.Skills = require("enums/Skills")
PalLuaApi.structs = require("structs/FQuat")
PalLuaApi.structs.FQuat = require("structs/FQuat")
PalLuaApi.structs.FVector = require("structs/FVector")
PalLuaApi.structs.FGuid = require("structs/FGuid")
PalLuaApi.structs.FPalSpawnerGroupList = require("structs/FPalSpawnerGroupList")
PalLuaApi.Logger = require("libs/Logger")
PalLuaApi.Manager = require("libs/Manager")
PalLuaApi.Utilities = require("libs/Utilities")
PalLuaApi.Validator = require("libs/Validator")
PalLuaApi.Debugger = require("libs/Debugger")
PalLuaApi.Logger.Print("Starting Sphere")
PalLuaApi.Logger.Log("Starting Sphere")

LoopAsync(100, function()
    if not FindFirstOf("World"):IsValid() then
        PalLuaApi.Logger.Log("Waiting for world start...")
        return false
    end
    local tryWorld = FindFirstOf("World"):GetFullName()
    if tryWorld == "World /Temp/Untitled_0.Untitled" then
        PalLuaApi.Logger.Log("Invalid world...")
        return false
    end
    PalLuaApi.Logger.Print(string.format("Found %s", tryWorld))
    PalLuaApi.Logger.Log(string.format("Found %s", tryWorld))

    PalLuaApi.Static = require("classes/Static")
    PalLuaApi.Player = require("classes/Player")
    PalLuaApi.System = require("classes/System")
    PalLuaApi.Palbox = require("classes/Palbox")
    PalLuaApi.Monster = require("classes/Monster")
    PalLuaApi.Admin = require("classes/Admin")
    PalLuaApi.Modules = {}
    PalLuaApi.Modules.MonsterSpawner = require("modules/MonsterSpawner/main")
    PalLuaApi.Modules.Chat = require("modules/Chat/main")
    PalLuaApi.Modules.Announcement = require("modules/Announcement/main")
    PalLuaApi.Manager.refreshAllDatabases()

    RegisterHook("/Script/Pal.PalPlayerState:EnterChat_Receive", function(argument1, argument2)
        local self = argument1:get() ---@type APalPlayerState
        local chatMessage = argument2:get() ---@type FPalChatMessage
        PalLuaApi.Modules.Chat.EnterChat_Receive(self, chatMessage)
    end)

    RegisterHook("/Game/Pal/Blueprint/Spawner/BP_PalSpawner_Standard.BP_PalSpawner_Standard_C:FindIndividualHandle", function(argument1, argument2)
        local self = argument1:get() ---@type ABP_PalSpawner_Standard_C
        --local handle = argument2:get() ---@type UPalIndividualCharacterHandle
        PalLuaApi.Modules.MonsterSpawner.FindIndividualHandle(self)
    end)

    RegisterHook("/Script/Pal.PalPlayerCharacter:OnCompleteInitializeParameter", function(argument1, argument2)
        local self = argument1:get() ---@type APalPlayerCharacter
        --local InCharacter = argument2:get() ---@type APalPlayerCharacter
        PalLuaApi.Modules.Announcement.OnCompleteInitializeParameter(self)
    end)

    RegisterHook("/Script/Pal.PalPlayerController:OnDestroyPawn", function(argument1, argument2)
        local self = argument1:get() ---@type APalPlayerController
        --local DestroyedActor = argument2:get() ---@type AActor
        PalLuaApi.Modules.Announcement.OnDestroyPawn(self)
    end)

    RegisterHook("/Game/Pal/Blueprint/Component/DamageReaction/BP_AIADamageReaction.BP_AIADamageReaction_C:OnDead", function(argument1, argument2)
        --local self = argument1:get() ---@type UBP_AIADamageReaction_C
        local deadInfo = argument2:get() ---@type FPalDeadInfo
        PalLuaApi.Modules.Announcement.OnDead(deadInfo)
    end)

    RegisterHook("/Game/Pal/Blueprint/Weapon/Other/NewPalSphere/BP_PalSphere_Body.BP_PalSphere_Body_C:CaptureSuccessEvent", function(argument1)
        local self = argument1:get() ---@type ABP_PalSphere_Body_C
        PalLuaApi.Modules.Announcement.CaptureSuccessEvent(self)    
    end)

    return true
end)