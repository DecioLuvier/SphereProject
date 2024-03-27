local self = {}

self.database = {
    Config = {
        folderPath = "Sphere\\",
        fileName = "Announcements",
        copyDefault = true,
        overwrite = false,
        schema = require("modules/Announcement/schemas/config"),
    },
    Translation = {
        folderPath = "Sphere\\Translations\\",
        fileName = "Announcements",
        copyDefault = true,
        overwrite = false,
        schema = require("modules/Announcement/schemas/translation"),
    }
}

---@param PlayerCharacter APalPlayerCharacter
function self.OnCompleteInitializeParameter(PlayerCharacter)
    if PalLuaApi.Modules.Announcement.database.Config.data.BroadcastJoin then
        local playerName = PalLuaApi.Player.GetName(PlayerCharacter.Controller)
        local message = string.format("%s %s", playerName, PalLuaApi.Modules.Announcement.database.Translation.data.Join)
        
        if PalLuaApi.Modules.Announcement.database.Config.data.ShowAnnouncementsOnConsole then
            PalLuaApi.Logger.Print(message)
        else
            PalLuaApi.Logger.Log(message)
        end
        PalLuaApi.System.SendSystemAnnounce(message)
    end
end

---@param PlayerController APalPlayerController
function self.OnDestroyPawn(PlayerController)
    if PalLuaApi.Modules.Announcement.database.Config.data.BroadcastExit then
        if not PlayerController.Player:IsValid() then
            local playerName = PalLuaApi.Player.GetName(PlayerController)
            local message = string.format("%s %s", playerName, PalLuaApi.Modules.Announcement.database.Translation.data.Exit)
    
            if PalLuaApi.Modules.Announcement.database.Config.data.ShowAnnouncementsOnConsole then
                PalLuaApi.Logger.Print(message)
            else
                PalLuaApi.Logger.Log(message)
            end
            PalLuaApi.System.SendSystemAnnounce(message)
        end
    end
end

---@param DeadInfo FPalDeadInfo
function self.OnDead(DeadInfo)
    if PalLuaApi.Modules.Announcement.database.Config.data.BroadcastDeath then
        local victimType = PalLuaApi.System.GetInstanceType(DeadInfo.SelfActor)
        local killerType = PalLuaApi.System.GetInstanceType(DeadInfo.LastAttacker)

        if (victimType == "Player") or (victimType == "Player" and killerType == "Player") then
            local message = "Undefined"
            local victimName = "Undefined"
            if victimType == "Player" then
                victimName = PalLuaApi.Player.GetName(DeadInfo.SelfActor.Controller)
            else 
                victimName = PalLuaApi.Monster.TranslateDebugName(PalLuaApi.Monster.GetDebugNameByAActor(DeadInfo.SelfActor))
            end

            local translation = PalLuaApi.Modules.Announcement.database.Translation.data
            if DeadInfo.DeadType == 1 then
                local killerText = "Undefined"
                if killerType == "Otomo" then
                    if DeadInfo.LastAttacker.CharacterParameterComponent.Trainer.Controller:IsValid() then
                        killerText = string.format("%s %s %s", PalLuaApi.Player.GetName(DeadInfo.LastAttacker.CharacterParameterComponent.Trainer.Controller), translation.HoldingPalKill, PalLuaApi.Monster.GetDebugNameByAActor(DeadInfo.LastAttacker))
                    end
                elseif killerType == "Player" then
                    if DeadInfo.LastAttacker.Controller:IsValid() then
                        killerText = PalLuaApi.Player.GetName(DeadInfo.LastAttacker.Controller)
                    end
                elseif killerType == "BaseCampPal" then
                    killerText =  string.format("%s %s %s", PalLuaApi.Monster.TranslateDebugName(PalLuaApi.Monster.GetDebugNameByAActor(DeadInfo.LastAttacker), translation.BasePalKill, PalLuaApi.System.GetBaseCampPalGuild(DeadInfo.LastAttacker).GuildName:ToString()))
                elseif killerType == "PalMonster" then
                    killerText =  string.format("%s", PalLuaApi.Monster.TranslateDebugName(PalLuaApi.Monster.GetDebugNameByAActor(DeadInfo.LastAttacker)))
                elseif killerType == "WildNPC" then
                    killerText =  string.format("%s", PalLuaApi.Monster.TranslateDebugName(PalLuaApi.Monster.GetDebugNameByAActor(DeadInfo.LastAttacker)))
                end 
                message = string.format("%s %s %s", victimName, translation.Killed, killerText)
            elseif DeadInfo.DeadType == 2 then
                message = string.format("%s %s", victimName, translation.Perished)
            elseif DeadInfo.DeadType == 3 then
                message = string.format("%s %s", victimName, translation.Weather)
            elseif DeadInfo.DeadType == 4 or DeadInfo.DeadType == 9 then
                message = string.format("%s %s", victimName, translation.Fall)
            elseif DeadInfo.DeadType == 5 then
                message = string.format("%s %s", victimName, translation.Poison)
            elseif DeadInfo.DeadType == 6 then
                message = string.format("%s %s", victimName, translation.Burned)
            elseif DeadInfo.DeadType == 7 then
                message = string.format("%s %s", victimName, translation.Drowned)
            elseif DeadInfo.DeadType == 8 then
                message = string.format("%s %s", victimName, translation.Tower)
            end

            if PalLuaApi.Modules.Announcement.database.Config.data.ShowAnnouncementsOnConsole then
                PalLuaApi.Logger.Print(message)
            else
                PalLuaApi.Logger.Log(message)
            end

            PalLuaApi.System.SendSystemAnnounce(message)
        end
    end
end

--At some point I will optimize this
--I swear. 
---@param palsphere ABP_PalSphere_Body_C
function self.CaptureSuccessEvent(Palsphere)
    local Config = PalLuaApi.Modules.Announcement.database.Config.data
    if Config.BroadcastCatch then
        local trainer = {}
        Palsphere:FindOwnerPlayer(trainer)
        local saveParameter = Palsphere.targetHandle:TryGetIndividualParameter().SaveParameter

        local translation = PalLuaApi.Modules.Announcement.database.Translation.data

        local allValues = {
            Talent_HP = saveParameter.Talent_HP, 
            Talent_Melee = saveParameter.Talent_Melee, 
            Talent_Shot = saveParameter.Talent_Shot, 
            Talent_Defense = saveParameter.Talent_Defense,
        } 
        
        local postMessage = ""

        local total = 0
        for key, value in pairs(allValues) do
            if value > Config.captureBroadcastThreshold then
                postMessage = postMessage .. string.format("%s%% %s ", value, translation[key])
            end
            
            total = total + value
        end

        local porcentageTotal = (total / 400) * 100

        local initMessage = ""
        if porcentageTotal > Config.captureBroadcastThreshold then
            initMessage = string.format("%s%% ",porcentageTotal) 
        end

        local init2message = ""
        if saveParameter.IsRarePal then
            init2message = " " .. translation.Rare
        end
    
        if trainer.Player.Controller:IsValid() then
            local trainerMessage = string.format("%s %s", translation.CatchBy, PalLuaApi.Player.GetName(trainer.Player.Controller))
            if initMessage ~= "" or init2message ~= "" or postMessage ~= "" then
                PalLuaApi.System.SendSystemAnnounce(translation.PalCatch .. " " .. initMessage .. PalLuaApi.Monster.TranslateDebugName(PalLuaApi.Monster.GetDebugName(saveParameter)) .. init2message .. "; " .. postMessage .. trainerMessage)
            end
        end
    end
end

return self