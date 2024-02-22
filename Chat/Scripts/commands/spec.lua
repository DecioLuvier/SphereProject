local System = require("scripts/System")

local spec = {}

spec.permissionLevel = "Admin"

---@param sender APalPlayerController
---@param arguments string[]
function spec.execute(sender, arguments)

    if arguments[2]  then
        local PalPlayerCharacter = sender:GetControlPalCharacter()
        local state = arguments[2]
        
        if state == "on" then
            PalPlayerCharacter:SetSpectatorMode(true)
            PalPlayerCharacter.CharacterMovement.RunSpeed_Default = 10000
        elseif state == "off" then
            PalPlayerCharacter:SetSpectatorMode(false)
            PalPlayerCharacter.CharacterMovement.RunSpeed_Default = 350
        else
            System.SendSystemToPlayer(sender, 'State must be an boolean.')
        end
    else
        System.SendSystemToPlayer(sender, 'Usage: /spec on|off')
    end
end

return spec