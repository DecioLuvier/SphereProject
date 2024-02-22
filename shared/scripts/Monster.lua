local PalWazaData = require("enums/PalWaza")
local PalData = require("enums/Pal")
local NpcData = require("enums/Npc")
local WazaData = require("enums/Waza")

local Monster = {}

---@param palDebugName string
---@param wazaDebugName string
---@return boolean
function Monster.CanLearnWaza(palDebugName,wazaDebugName)
    if not PalData[palDebugName] then --Check if is a valid pal, since NPC cannot learn Waza.
        return false
    elseif WazaData[wazaDebugName] then --Check if the waza is a fruit skill.
        return WazaData[wazaDebugName]
    elseif PalWazaData[palDebugName][wazaDebugName] then --Check if a pal learn the Waza by level up.
        return PalWazaData[palDebugName][wazaDebugName]
    else
        return false  
    end
end

---@param monsterName string
---@return string
function Monster.IsMonsterDebugNameValid(monsterName)
    if PalData[monsterName] or NpcData[monsterName] then 
        return monsterName
    else
        return false
    end
end

return Monster