local self = {}

---@param PalStatus FPalIndividualCharacterSaveParameter
function self.GetDebugName(PalStatus)

    local palDebugName = PalStatus.CharacterID:ToString()
    if palDebugName then
        return palDebugName
    end

    local npcDebugName = PalStatus.UniqueNPCID:ToString()
    if npcDebugName then
        return npcDebugName
    end

    return "Undefined"
end

---@param Monster AActor
function self.GetDebugNameByAActor(Monster)
    return self.GetDebugName(Monster.CharacterParameterComponent.IndividualParameter.SaveParameter)
end

---@param DebugName string
---@return string
function self.TranslateDebugName(DebugName)
    local palDebugName = PalLuaApi.Enums.Pals[DebugName]
    
    if palDebugName then
        return palDebugName
    end

    local npcDebugName = PalLuaApi.Enums.Npcs[DebugName]
    if npcDebugName then
        return npcDebugName
    end

    return "Undefined"
end

---@param PalName string
---@param SkillName string
---@return boolean
function self.CanLearnSkill(PalName, SkillName)
    if PalLuaApi.Enums.Npcs[PalName] or PalLuaApi.Enums.Pals[SkillName] then
        if PalLuaApi.Enums.PalsLevelSkills[PalName] then
            if PalLuaApi.Enums.PalsFruitsSkills[SkillName] then
                return true
            elseif PalLuaApi.Enums.PalsLevelSkills[PalName][SkillName] then
                return true
            end
        end
    end

    return false
end

return self