local v = PalLuaApi.Validator

local self = {}

self.validate = v.is_table {
    ShowGameChatOnConsole = v.required(v.is_boolean()),
    NonSphereCommands = v.required(v.is_array(v.is_string()))
}

self.default = {
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
        "give",
        "getnearestbase",
        "gotonearestbase",
        "killnearestbase",
        "removedroppedpals",
        "adminlogout",
        "getip",
        "unban_ip"
    }
}

return self
