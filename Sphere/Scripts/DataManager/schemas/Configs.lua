local validation = require("libs/Validator")

local Config = {}

Config.validate = validation.is_table {
    CreditMessage = validation.required(validation.is_boolean()),
    AllPlayersAdmin = validation.required(validation.is_boolean()),
    BroadcastJoin = validation.required(validation.is_boolean()),
    BroadcastExit = validation.required(validation.is_boolean()),
    ShowGameChatOnConsole = validation.required(validation.is_boolean()),
    NonSphereCommands = validation.optional(validation.is_array(validation.is_string()))
}

Config.default = {
    CreditMessage = true,
    AllPlayersAdmin = false,
    BroadcastJoin = true,
    BroadcastExit = true,
    ShowGameChatOnConsole = true,
    NonSphereCommands = {
        -- Default Palworld
        "shutdown",
        "doexit",
        "broadcast",
        "banplayer",
        "teleporttoplayer",
        "teleporttome",
        "showplayers",
        "info",
        "save",
        "adminpassword",
        -- Palguard Support
        "reloadcfg",
        "imcheater",
        "kick",
        "kickid",
        "ban",
        "banid",
        "ipban",
        "ipbanid",
        "ipban_ip",
        "addadminip",
        "setadmin",
        "whitelist_add",
        "whitelist_remove",
        "whitelist_get",
        "giveegg",
        "jetragon",
        "catwaifu",
        "goto",
        "give"
    }
}

return Config
