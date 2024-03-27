local v = PalLuaApi.Validator

local self = {}

local function vPalSkill()
    return function(value, key, data)
        local Skill = value ---@type string 
        local DebugName = data["DebugID"] ---@type string
        if not PalLuaApi.Enums.Npcs[DebugName] or PalLuaApi.Enums.Pals[DebugName] then
            return false
        elseif not PalLuaApi.Enums.Skills[Skill] then
            return false, string.format("%s is not a valid skill", Skill)
        elseif not PalLuaApi.Monster.CanLearnSkill(DebugName, Skill) then
            return false, string.format("%s cannot learn %s", DebugName, Skill)
        else
            return true
        end
    end
end

local function vDebugID()
    return function(value, key, data)
        if PalLuaApi.Enums.Npcs[value] or PalLuaApi.Enums.Pals[value] then
            return true
        else
            return false, string.format("%s is not a valid npc or pal", value) 
        end
    end
end

self.validate = v.is_array(
    v.is_table {
        DebugID = v.required(v.is_string(vDebugID())),
        Level = v.required(v.is_integer(v.in_range(1,50))),
        Quantity = v.required(v.is_integer(v.in_range(1,10))),
        WildHPMultiplier = v.optional(v.is_number()),
        Stats = v.optional(v.is_table {
            NickName = v.optional(v.is_string()),
            IsRarePal = v.optional(v.is_boolean()),
            Rank = v.optional(v.is_integer(v.in_range(0,5))),
            Rank_HP = v.optional(v.is_integer(v.in_range(0,100))),
            Rank_Attack = v.optional(v.is_integer(v.in_range(0,100))),
            Rank_Defence = v.optional(v.is_integer(v.in_range(0,100))),
            Rank_CraftSpeed = v.optional(v.is_integer(v.in_range(0,100))),
            Talent_HP = v.optional(v.is_integer(v.in_range(0,100))),
            Talent_Melee = v.optional(v.is_integer(v.in_range(0,100))),
            Talent_Shot = v.optional(v.is_integer(v.in_range(0,100))),
            Talent_Defense = v.optional(v.is_integer(v.in_range(0,100))),
        }),
        PassiveSkillList = v.optional(v.is_array(v.array_max(4, v.is_string(v.is_KeyOfList(PalLuaApi.Enums.PassiveSkills))))),
        EquipedSkills = v.optional(v.is_array(v.array_max(3, vPalSkill()))),
        MasteredSkills = v.optional(v.is_array(v.array_max(15, vPalSkill()))),
    }
)

self.default = {
    Godnubis = {
        DebugID = "Anubis",
        Level = 35,
        Quantity = 1,
        WildHPMultiplier = 100,
        Stats = {
            NickName = "The Pharaoh",
            IsRarePal = true,
            Rank = 5,
            Rank_HP = 5,
            Rank_Attack = 5,
            Rank_Defence = 5,
            Rank_CraftSpeed = 5,
            Talent_HP = 100,
            Talent_Melee = 100,
            Talent_Shot = 100,
            Talent_Defense = 100
        },
        PassiveSkillList = {
            "Lucky",
            "Legend",
            "Artisan",
            "Serious"
        },
        EquipedSkills = {
            "IGNIS_BLAST",
            "SOLAR_BLAST",
            "SPARK_BLAST"
        },
        MasteredSkills = {
            "POWER_BOMB",
            "SAND_TORNADO"
        }
    },
    Soccerball = {
        DebugID = "BOSS_SheepBall",
        Level = 1,
        Quantity = 1,
        WildHPMultiplier = 1,
        PassiveSkillList = {
            "Destructive",
        }
    },
    Secret = {
        DebugID = "BlackFurDragon",
        Level = 1,
        Quantity = 1
    },
    Trader = {
        DebugID = "Male_DarkTrader01",
        Level = 50,
        Quantity = 1
    }
}

return self