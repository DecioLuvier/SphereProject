local Utilities = require("libs/Utilities")

local Fguid = require("constructors/Fguid")
local FVector = require("constructors/FVector")

local Palbox = {}

---@param PlayerController APalPlayerController
---@return ABP_BuildObject_PalBoxV2_C[]
function Palbox.GetPlayerPalBoxes(PlayerController) 
    local allPalBoxes = FindAllOf("BP_BuildObject_PalBoxV2_C")
    local playerGuildUid =  Fguid.translate(PlayerController:GetPalPlayerState().GuildBelongTo.ID)
    local playerPalBoxes = {}
    for i = 1, #allPalBoxes do
        local palBox = allPalBoxes[i] ---@type ABP_BuildObject_PalBoxV2_C
        local palBoxGuildUid = Fguid.translate(palBox.MapObjectModel.GroupIdBelongTo)

        if Utilities.CompareTables(palBoxGuildUid, playerGuildUid) then
            table.insert(playerPalBoxes, palBox)
        end
    end
    return playerPalBoxes
end

---@param PalBox ABP_BuildObject_PalBoxV2_C
---@return FVector
function Palbox.GetPalBoxLocation(PalBox) 
    local location = FVector.translate(PalBox.MapObjectModel.InitialTransformCache.Translation)
    --For some reason there are some palboxes that are stuck in the ground 
    --and sometimes this doesn't allow you to teleport, this could cause a bug later on.
    location.Z = location.Z + 200 
    return location
end

return Palbox