
local Static = require("scripts/Static")

--Need rework WTF
local Pals = require("enums/Pals")
local PalsFruitsSkills = require("enums/PalsFruitsSkills")
local PalsLevelSkills = require("enums/PalsLevelSkills")
local Skills = require("enums/Skills")


local Monster = {}

---@param Monster AActor
function Monster.GetDebugName(Monster)
    local palUtility = Static.GetPalUtility()

    local saveParameter = palUtility.GetIndividualCharacterParameterByActor(Static.GetWorld(),Monster).SaveParameter

    local PalDebugName = saveParameter.CharacterID:ToString()
    local NPCDebugName = saveParameter.UniqueNPCID:ToString()

    if PalDebugName ~= "" then
        return PalDebugName
    elseif NPCDebugName ~= "" then
        return NPCDebugName
    else
        return nil
    end
end

--Need rework WTF
---@param PalName string
---@param SkillName string
---@return boolean
function Monster.CanLearnWaza(PalName,SkillName)

    if Monster.IsMonsterDebugNameValid(PalName) and Monster.IsSkillDebugNameValid(SkillName) then
        if PalsFruitsSkills[SkillName] then
            return true
        elseif PalsLevelSkills[PalName] then
            if PalsLevelSkills[PalName][SkillName] then
                return true
            else
                return false
            end
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