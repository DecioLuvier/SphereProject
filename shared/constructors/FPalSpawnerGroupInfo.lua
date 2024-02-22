local FPalSpawnerOneTribeInfo = require("constructors/FPalSpawnerOneTribeInfo")
local FPalSpawnerGroupInfo = {}

---@param Weight number
---@param OnlyTime number
---@param OnlyWeather number
---@param PalList table
---@return FPalSpawnerGroupInfo
function FPalSpawnerGroupInfo.new(Weight,OnlyTime,OnlyWeather,PalList)
    local self = {}

    self.Weight = Weight
    self.OnlyTime = OnlyTime
    self.OnlyWeather = OnlyWeather
    self.PalList = PalList

    return self
end

---@param Userdata FPalSpawnerGroupInfo
---@return FPalSpawnerGroupInfo
function FPalSpawnerGroupInfo.translate(Userdata)
    local self = {}

    self.Weight = Userdata.Weight
    self.OnlyTime = Userdata.OnlyTime
    self.OnlyWeather = Userdata.OnlyWeather
    self.PalList = {}
    local PalListCount = Userdata.PalList ---@type TArray
    for i = 1, PalListCount:GetArrayNum() do
        self.PalList[i] = FPalSpawnerOneTribeInfo.translate(Userdata.PalList[i])
    end

    return self
end

return FPalSpawnerGroupInfo