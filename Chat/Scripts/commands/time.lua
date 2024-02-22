local System = require("scripts/System")
local Static = require("scripts/Static")
local Player = require("scripts/Player")

local time = {}

time.permissionLevel  = "Admin"

---@param sender APalPlayerController
---@param arguments string[]
function time.execute(sender, arguments)
    local desiredHour = arguments[2]

    if desiredHour ~= nil then

        if tonumber(desiredHour) ~= nil then
            local HourNumber =  tonumber(desiredHour)

            if HourNumber >= 0 and HourNumber < 24 then
                local TimeManager = Static.GetTimeManager()
                TimeManager:SetGameTime_FixDay(tonumber(desiredHour))
                local playerName = Player.GetSteamName(sender)
                System.SendSystemAnnounce(sender, string.format('%s changed the game time to %s hours!', playerName, desiredHour))
            else
                System.SendSystemToPlayer(sender, 'Hour need to be in 0-23 interval')  
            end
        else
            System.SendSystemToPlayer(sender, 'Hour must be an integer.')
        end
    else
        System.SendSystemToPlayer(sender, 'Usage: /time Hour')
    end
end

return time