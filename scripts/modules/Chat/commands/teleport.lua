local self = {}

self.adminOnly = true

---@param Sender APalPlayerController
---@param Arguments string[]
function self.execute(Sender, Arguments)
    local translation = PalLuaApi.Modules.Chat.database.Translation.data
    local message = translation.TeleportUsage

    if Arguments[2] then
        local match1, match2 = Arguments[2]:match("(%d+)_P(%d+)")
        if match1 and match2 then 
            local targetPlayer = PalLuaApi.Player.GetControllerById(tonumber(match1))

            if targetPlayer then
                local allTargetPlayerPalBoxes = PalLuaApi.Palbox.GetPlayerPalBoxes(targetPlayer)
                local selectedPalBox = allTargetPlayerPalBoxes[tonumber(match2)]
                if selectedPalBox then
                    local location = PalLuaApi.Palbox.GetPalBoxLocation(selectedPalBox)
                    location.Z = location.Z + 500 
                    PalLuaApi.Admin.TeleportCharacterToLocation(targetPlayer.Character,location)
                    message = translation.Success
                else
                    message = translation.TargetNotFound
                end
            else
                message = translation.TargetNotFound
            end
        else
            local targetPlayer = PalLuaApi.Player.GetControllerById(tonumber(Arguments[2]))

            if targetPlayer then
                PalLuaApi.Admin.TeleportCharacterToCharacter(Sender.Character,targetPlayer.Character)
                message = translation.Success
            else
                message = translation.TargetNotFound
            end
        end  
    end

    PalLuaApi.System.SendSystemToPlayer(Sender, message)
end

return self 