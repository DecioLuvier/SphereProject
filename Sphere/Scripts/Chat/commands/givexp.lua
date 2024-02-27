local System = require("scripts/System")
local Player = require("scripts/Player")
local Admin = require("scripts/Admin")

local givexp = {}

givexp.permissionLevel = "Admin"

---@param sender APalPlayerController
---@param arguments string[]
function givexp.execute(sender, arguments)

    if arguments[2] and arguments[3] then
        local givePlayer = Player.GetController(arguments[2])

        if givePlayer ~= nil then
            local quantity =  tonumber(arguments[3])

            if math.type(quantity) == "integer" then
                Admin.GiveXpToPlayer(givePlayer,quantity)
                System.SendSystemToPlayer(sender, "Experience given successfully")  
            else
                System.SendSystemToPlayer(sender, "Quantity must be a integer")
            end
        else
            System.SendSystemToPlayer(sender, "Player to give xp not found")
        end
    else
        System.SendSystemToPlayer(sender, "Usage: /givexp Player Quantity")
    end
end

return givexp