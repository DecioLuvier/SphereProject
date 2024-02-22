local FPalDataTableRowName_PalMonsterData = {}

---@param Key FName
---@return FPalDataTableRowName_PalMonsterData
function FPalDataTableRowName_PalMonsterData.new(Key)
    local self = {}

    self.Key = Key

    return self
end


---@param Userdata FPalDataTableRowName_PalMonsterData
---@return FPalDataTableRowName_PalMonsterData
function FPalDataTableRowName_PalMonsterData.translate(Userdata)
    local self = {}

    self.Key = Userdata.Key

    return self
end

return FPalDataTableRowName_PalMonsterData