local v = PalLuaApi.Validator

local self = {}

self.validate = v.is_table {
    BroadcastJoin = v.required(v.is_boolean()),
    BroadcastExit = v.required(v.is_boolean()),
    BroadcastDeath = v.required(v.is_boolean()),
    BroadcastCatch = v.required(v.is_boolean()),
    captureBroadcastThreshold = v.required(v.is_positive()),
    BroadcastBossKill = v.required(v.is_boolean()),
    ShowAnnouncementsOnConsole = v.required(v.is_boolean()),
}

self.default = {
    BroadcastDeath = true,
    BroadcastJoin = true,
    BroadcastExit = true,
    BroadcastCatch = true,
    BroadcastBossKill = true,
    ShowAnnouncementsOnConsole = true,
    captureBroadcastThreshold = 90
}

return self
