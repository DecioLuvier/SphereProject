local v = PalLuaApi.Validator

local self = {}

self.validate = v.is_table {
    Join = v.required(v.is_string()),
    Exit = v.required(v.is_string()),
    Perished = v.required(v.is_string()),
    Weather = v.required(v.is_string()),
    Fall = v.required(v.is_string()),
    Poison = v.required(v.is_string()),
    Burned = v.required(v.is_string()),
    Drowned = v.required(v.is_string()),
    Tower = v.required(v.is_string()),
    Killed = v.required(v.is_string()),
    HoldingPalKill = v.required(v.is_string()),
    BasePalKill = v.required(v.is_string()),
    PalCatch = v.required(v.is_string()),
    CatchBy = v.required(v.is_string()),
    Talent = v.required(v.is_string()),
    Talent_HP = v.required(v.is_string()),
    Talent_Melee = v.required(v.is_string()),
    Talent_Shot = v.required(v.is_string()),
    Talent_Defense = v.required(v.is_string()),
    Rare = v.required(v.is_string())
}

self.default = {
    Join = "joined the game!",
    Exit = "disconnected.",
    Perished = "perished himself",
    Weather = "died to extreme weather",
    Fall = "hit the ground too hard",
    Poison = "poisoned to death",
    Burned = "burned to death",
    Drowned = "drowned",
    Tower = "died in a tower boss",
    Killed = "was killed by",
    HoldingPalKill = "using",
    BasePalKill = "defending the guild",
    PalCatch = "How lucky! A",
    CatchBy = "was captured by",
    Talent = "IV's",
    Talent_HP = "HP",
    Talent_Melee = "Attack",
    Talent_Shot = "Sp.Atk",
    Talent_Defense = "Defense",
    Rare = "Shiny"
}

return self
