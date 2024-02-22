local System = require("scripts/System")
local Admin = require("scripts/Admin")
local Player = require("scripts/Player")

local givetech = {}

givetech.permissionLevel = "Admin"

---@param sender APalPlayerController
---@param arguments string[]
function givetech.execute(sender, arguments)

    if arguments[2] and arguments[3] then
        local givePlayer = Player.GetController(arguments[2])

        if givePlayer ~= nil then
            local quantity =  tonumber(arguments[3])

            if math.type(quantity) == "integer" then
                Admin.GiveTechToPlayer(givePlayer,quantity)
                System.SendSystemToPlayer(sender, "Technology points given successfully") 
            else
                System.SendSystemToPlayer(sender, "Quantity must be a integer")
            end
        else
            System.SendSystemToPlayer(sender, "Player to give Technology not found")
        end
    else
        System.SendSystemToPlayer(sender, "Usage: /givetech Player Quantity")
    end
end

return givetech