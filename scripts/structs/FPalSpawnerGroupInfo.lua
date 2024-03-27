local FPalSpawnerOneTribeInfo = require("structs/FPalSpawnerOneTribeInfo")
local FPalSpawnerGroupInfo = {}

---@param Userdata FPalSpawnerGroupInfo
---@return FPalSpawnerGroupInfo
function FPalSpawnerGroupInfo.translate(Userdata)
    local self = {}

    self.Weight = Userdata.Weight
    self.OnlyTime = Userdata.OnlyTime
    self.OnlyWeather = Userdata.OnlyWeather
    self.PalList = {}
    for i = 1, Userdata.PalList:GetArrayNum() do
        self.PalList[i] = FPalSpawnerOneTribeInfo.translate(Userdata.PalList[i])
    end

    return self
end

return FPalSpawnerGroupInfo