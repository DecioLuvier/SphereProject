local self = {}

self.PalUtility = StaticFindObject("/Script/Pal.Default__PalUtility") ---@type UPalUtility

self.PalExpDatabase = FindFirstOf("PalExpDatabase") ---@type UPalExpDatabase

self.World = FindFirstOf("World") ---@type APL_MainWorld5_C

self.PalTimeManager = FindFirstOf("PalTimeManager")---@type UPalTimeManager

self.PalMapObjectManager = FindFirstOf("PalMapObjectManager") ---@type UPalMapObjectManager

return self