local FPalDataTableRowName_PalHumanData = require("constructors/FPalDataTableRowName_PalHumanData")
local FPalDataTableRowName_PalMonsterData = require("constructors/FPalDataTableRowName_PalMonsterData")

local FPalSpawnerOneTribeInfo = {}

---@param PalID FPalDataTableRowName_PalMonsterData
---@param NPCID FPalDataTableRowName_PalHumanData
---@param Level number
---@param Level_Max number
---@param Num number
---@param Num_Max number
---@return FPalSpawnerOneTribeInfo
function FPalSpawnerOneTribeInfo.new(PalID,NPCID,Level,Level_Max,Num,Num_Max)
    local self = {}

    self.PalID = PalID
    self.NPCID = NPCID
    self.Level = Level
    self.Level_Max = Level_Max
    self.Num = Num
    self.Num_Max = Num_Max

    return self
end

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