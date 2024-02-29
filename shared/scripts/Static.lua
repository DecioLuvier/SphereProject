local Static = {}

---@return UPalUtility
function Static.GetPalUtility()
    return StaticFindObject("/Script/Pal.Default__PalUtility")
end

---@return UPalExpDatabase
function Static.GetPalExpDatabase()
    return FindFirstOf("PalExpDatabase")
end

---@return APL_MainWorld5_C
function Static.GetWorld()
    return FindFirstOf("World")
end

---@return UPalTimeManager
function Static.GetTimeManager()
    return FindFirstOf("PalTimeManager")
end

return Static