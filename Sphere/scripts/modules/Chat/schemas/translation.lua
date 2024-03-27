local v = PalLuaApi.Validator

local self = {}

self.validate = v.is_table {
    DeniedAccess = v.required(v.is_string()),
    CommandNotFound = v.required(v.is_string()),
    Success = v.required(v.is_string()),
    TargetNotFound = v.required(v.is_string()),
    Invalid = v.required(v.is_string()),
    Guild = v.required(v.is_string()),
    Say = v.required(v.is_string()),
    Global = v.required(v.is_string()),
    TeleportUsage = v.required(v.is_string()),
    KitUsage = v.required(v.is_string()),
    SpawnUsage = v.required(v.is_string()),
    GivePalUsage = v.required(v.is_string()),
    CheckConsole = v.required(v.is_string()),
    CommandsAvailable = v.required(v.is_string())
}

self.default = {
    DeniedAccess = "Denied access.",
    CommandNotFound = "Command not found.",
    Success = "Command executed successfully!",
    TargetNotFound = "Target not found.",
    Invalid = "Invalid DataName.",
    Guild = "[Guild]",
    Say = "[Say]",
    Global = "[Global]",
    TeleportUsage = "Usage: /tp SteamIDorUID or /tp SteamIDorUID_PX(where x is the palbox number)",
    KitUsage = "Usage: /kit SteamIDorUID DataKitName or /kit DataKitName",
    SpawnUsage = "Usage: /spawn DataPalName(Sphere/Data/Pals)",
    GivePalUsage = "Usage: /gpal SteamIDorUID or /gpal DataPalName(Sphere/Data/Pals)",
    CheckConsole = "You should see the console to see the result.",
    CommandsAvailable = "You can use the following commands:"
}

return self
