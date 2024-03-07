local validation = require("libs/Validator")
local Monster = require("scripts/Monster") 
local Pals = require("enums/Pals")
local PassiveSkills = require("enums/PassiveSkills")

local CustomPals = {}

local function validationPalSkill()
    return function(value, key, data)
        local PalSkill = value ---@type string 
        local PalName = data["DebugID"] ---@type string 

        if not PalName then
          return false
        elseif not Monster.IsSkillDebugNameValid(PalSkill) then
            return false, string.format("%s is not a valid skill", PalSkill)
        elseif not Monster.CanLearnWaza(PalName, PalSkill) then
            return false, string.format("%s cannot learn %s", PalName, PalSkill)
        else
            return true
        end
    end
end

CustomPals.validate = validation.is_array(
    validation.is_table {
        DebugID = validation.required(validation.is_string(validation.is_KeyOfList(Pals))),
        Level = validation.required(validation.is_integer(validation.in_range(1,50))),
        Quantity = validation.required(validation.is_integer(validation.in_range(1,10))),
        Stats = validation.optional(validation.is_table {
            NickName = validation.optional(validation.is_string()),
            IsRarePal = validation.optional(validation.is_boolean()),
            Rank = validation.optional(validation.is_integer(validation.in_range(0,5))),
            Rank_HP = validation.optional(validation.is_integer(validation.in_range(0,5))),
            Rank_Attack = validation.optional(validation.is_integer(validation.in_range(0,5))),
            Rank_Defence = validation.optional(validation.is_integer(validation.in_range(0,5))),
            Rank_CraftSpeed = validation.optional(validation.is_integer(validation.in_range(0,5))),
            Talent_HP = validation.optional(validation.is_integer(validation.in_range(0,100))),
            Talent_Melee = validation.optional(validation.is_integer(validation.in_range(0,100))),
            Talent_Shot = validation.optional(validation.is_integer(validation.in_range(0,100))),
            Talent_Defense = validation.optional(validation.is_integer(validation.in_range(0,100))),
        }),
        PassiveSkillList = validation.optional(validation.is_array(validation.array_max(4, validation.is_string(validation.is_KeyOfList(PassiveSkills))))),
        EquipedSkills = validation.optional(validation.is_array(validation.array_max(3, validationPalSkill()))),
        MasteredSkills = validation.optional(validation.is_array(validation.array_max(15, validationPalSkill()))),
    }
)

CustomPals.default = {
    Godnubis = {
        DebugID = "Anubis",
        Level = 35,
        Quantity = 1,
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
        Stats = {
            IsRarePal = true,
        },
        PassiveSkillList = {
            "Destructive"
        }
    },
}

return CustomPals