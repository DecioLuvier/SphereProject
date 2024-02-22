local System = require("scripts/System")
local Player = require("scripts/Player")
local Admin = require("scripts/Admin")
local ItemIDs = require("enums/Items")

local giveitem = {}

giveitem.permissionLevel = "Admin"

---@param sender APalPlayerController
---@param arguments string[]
function giveitem.execute(sender, arguments)

    if arguments[2] and arguments[3] and arguments[4] then
        local givePlayer = Player.GetController(arguments[2])

        if givePlayer ~= nil then
            
            if ItemIDs[arguments[3]] ~= nil then 
                local quantity =  tonumber(arguments[4])

                if math.type(quantity) == "integer" then
                    Admin.GiveItemToPlayer(givePlayer,arguments[3],quantity)
                else
                    System.SendSystemToPlayer(sender, "Quantity must be a integer")
                end
            else
                System.SendSystemToPlayer(sender, "Invalid item ID")
            end
        else
            System.SendSystemToPlayer(sender, "Player to give item not found")
        end
    else
        System.SendSystemToPlayer(sender, "Usage: /giveitem Player ItemName Quantity")
    end
end

return giveitem