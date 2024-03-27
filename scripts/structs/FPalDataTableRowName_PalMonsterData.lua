local FPalDataTableRowName_PalMonsterData = {}

---@param Userdata FPalDataTableRowName_PalMonsterData
---@return FPalDataTableRowName_PalMonsterData
function FPalDataTableRowName_PalMonsterData.translate(Userdata)
    local self = {}

    self.Key = Userdata.Key

    return self
end

return FPalDataTableRowName_PalMonsterData