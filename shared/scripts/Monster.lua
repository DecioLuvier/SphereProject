local Pals = require("enums/Pals")
local PalsFruitsSkills = require("enums/PalsFruitsSkills")
local PalsLevelSkills = require("enums/PalsLevelSkills")
local Skills = require("enums/Skills")

local Monster = {}

---@param PalName string
---@param SkillName string
---@return boolean
function Monster.CanLearnWaza(PalName,SkillName)
    if Monster.IsMonsterDebugNameValid(PalName) and Monster.IsSkillDebugNameValid(SkillName) then
        if PalsLevelSkills[PalName][SkillName] or PalsFruitsSkills[SkillName] then
            return true
        else
            return false
        end
    else
        return false
    end
end

---@param monsterName string
---@return string|boolean
function Monster.IsMonsterDebugNameValid(monsterName)
    if Pals[monsterName] then 
        return monsterName
    else
        return false
    end
end

---@param skillName string
---@return string|boolean
function Monster.IsSkillDebugNameValid(skillName)
    if Skills[skillName] then 
        return skillName
    else
        return false
    end
end

return Monster