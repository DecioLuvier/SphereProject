local FPalDataTableRowName_PalHumanData = {}

---@param Key FName
---@return FPalDataTableRowName_PalHumanData
function FPalDataTableRowName_PalHumanData.new(Key)
    local self = {}

    self.Key = Key

    return self
end

---@param Userdata FPalDataTableRowName_PalHumanData
---@return FPalDataTableRowName_PalHumanData
function FPalDataTableRowName_PalHumanData.translate(Userdata)
    local self = {}

    self.Key = Userdata.Key

    return self
end

return FPalDataTableRowName_PalHumanData