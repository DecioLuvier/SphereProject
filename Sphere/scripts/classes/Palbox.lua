local self = {}

---@param PlayerController APalPlayerController
---@return ABP_BuildObject_PalBoxV2_C[]
function self.GetPlayerPalBoxes(PlayerController) 
    PalLuaApi.Logger.Log(string.format("Palbox.GetPlayerPalBoxes %s", PlayerController:GetFullName()))
    local allPalBoxes = FindAllOf("BP_BuildObject_PalBoxV2_C")
    local playerGuildUid =  PalLuaApi.structs.FGuid.translate(PlayerController.PlayerState.GuildBelongTo.ID)
    local playerPalBoxes = {}
    for i = 1, #allPalBoxes do
        local palBox = allPalBoxes[i] ---@type ABP_BuildObject_PalBoxV2_C
        local palBoxGuildUid = PalLuaApi.structs.FGuid.translate(palBox.MapObjectModel.GroupIdBelongTo)

        if PalLuaApi.Utilities.CompareTables(palBoxGuildUid, playerGuildUid) then
            table.insert(playerPalBoxes, palBox)
        end
    end
    return playerPalBoxes
end

---@param PalBox ABP_BuildObject_PalBoxV2_C
---@return FVector
function self.GetPalBoxLocation(PalBox) 
    return PalLuaApi.structs.FVector.translate(PalBox.MapObjectModel.InitialTransformCache.Translation)
end

return self