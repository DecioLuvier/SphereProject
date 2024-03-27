local FPalDataTableRowName_PalHumanData = require("structs/FPalDataTableRowName_PalHumanData")
local FPalDataTableRowName_PalMonsterData = require("structs/FPalDataTableRowName_PalMonsterData")

local FPalSpawnerOneTribeInfo = {}

---@param Userdata FPalSpawnerOneTribeInfo
---@return FPalSpawnerOneTribeInfo
function FPalSpawnerOneTribeInfo.translate(Userdata)
    local self = {}

    self.PalID = FPalDataTableRowName_PalMonsterData.translate(Userdata.PalID)
    self.NPCID = FPalDataTableRowName_PalHumanData.translate(Userdata.NPCID)
    self.Level = Userdata.Level
    self.Level_Max = Userdata.Level_Max
    self.Num = Userdata.Num
    self.Num_Max = Userdata.Num_Max

    return self
end

return FPalSpawnerOneTribeInfo