local FPalSpawnerGroupInfo = require("structs/FPalSpawnerGroupInfo")

local FPalSpawnerGroupList = {}

---@param Userdata TArray<FPalSpawnerGroupInfo>
---@return TArray<FPalSpawnerGroupInfo>
function FPalSpawnerGroupList.translate(Userdata)
    local self = {}

    for i = 1, Userdata:GetArrayNum() do
        self[i] = FPalSpawnerGroupInfo.translate(Userdata[i])
    end

    return self
end

return FPalSpawnerGroupList