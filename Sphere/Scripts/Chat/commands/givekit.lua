local Spawner = require("libs/Spawner")
local System = require("scripts/System")
local Database = require("scripts/Database")
local Player = require("scripts/Player")
local Admin = require("scripts/Admin")

local kit = {}

kit.permissionLevel = "Admin"

---@param sender APalPlayerController
---@param arguments string[]
function kit.execute(sender, arguments)

    if arguments[2] and arguments[3] then
        local givePlayer = Player.GetController(arguments[2])

        if givePlayer ~= nil then
            local kit = Database.read("Kits")[arguments[3]]

            if kit then

                if kit["items"] then
                    for _, item in ipairs( kit["items"]) do
                        Admin.GiveItemToPlayer(givePlayer,item["ItemID"], item["Quantity"])
                    end
                end
                
                if kit["Monsters"] then
                    for _, monster in ipairs( kit["Monsters"]) do
                        Spawner.Spawn(monster, Spawner.CallbackCaptureToPlayer,{ givePlayer:GetControlPalCharacter() })
                    end
                end
            else
                System.SendSystemToPlayer(sender, "Invalid Kit Name")
            end
        else
            System.SendSystemToPlayer(sender, "Player Not found")
        end
    else
        System.SendSystemToPlayer(sender, "Usage: /givekit Player Kit")
    end
end

return kit