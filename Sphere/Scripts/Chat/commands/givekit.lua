local System = require("scripts/System")
local Player = require("scripts/Player")
local Admin = require("scripts/Admin")

local kit = {}

kit.permissionLevel = "Admin"

---@param sender APalPlayerController
---@param arguments string[]
function kit.execute(sender, arguments)

    if arguments[2] and arguments[3] then
        local givePlayer = Player.GetPlayerController(tonumber(arguments[2]))

        if givePlayer ~= nil then
            local customKit = SphereGlobal.database.Kits[arguments[3]]

            if customKit then

                if customKit["Items"] then

                    for _, item in ipairs( customKit["Items"]) do
                        Admin.GiveItemToPlayer(givePlayer,item["ItemID"], item["Quantity"])
                    end
                end
            else
                System.SendSystemToPlayer(sender, "Invalid Kit Name")
            end
        else
            System.SendSystemToPlayer(sender, "Player Not found")
        end
    else
        System.SendSystemToPlayer(sender, "Usage: /gkit SteamID DataKitName(Sphere/Data/Kit)")
    end
end

return kit