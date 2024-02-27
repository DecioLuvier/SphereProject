local Spawner = require("libs/Spawner")
local System = require("scripts/System")
local Database = require("scripts/Database")
local Monster = require("scripts/Monster")
local Player = require("scripts/Player")

local spawn = {}

spawn.permissionLevel = "Admin"

---@param sender APalPlayerController
---@param arguments string[]
function spawn.execute(sender, arguments)
    if arguments[2] and arguments[3] then
        local givePlayer = Player.GetController(arguments[2])

        if givePlayer ~= nil then
            local customPal = Database.read("Monsters")[arguments[3]]

            if customPal then
                Spawner.Spawn(customPal, Spawner.CallbackCaptureToPlayer,{ givePlayer:GetControlPalCharacter() })
            elseif Monster.IsMonsterDebugNameValid(arguments[3]) then 
                local level = tonumber(arguments[4])
                local quantity = tonumber(arguments[5])

                if math.type(quantity) == "integer" and math.type(level) == "integer" then
                    local simpleMonster = {
                        ID = arguments[3],
                        Level = level,
                        Level_Max = level,
                        Num = quantity,
                        Num_Max = quantity
                    }
                    Spawner.Spawn(simpleMonster, Spawner.CallbackCaptureToPlayer,{ givePlayer:GetControlPalCharacter() })
                else
                    System.SendSystemToPlayer(sender, "Level and Quantity must be integers")
                end
            else
                System.SendSystemToPlayer(sender, "Invalid Pal ID")
            end
        else
            System.SendSystemToPlayer(sender, "Player not found")
        end
    else
        System.SendSystemToPlayer(sender, "Usage: /givepal PlayerName Pal_ID Level Quantity")
    end
end

return spawn