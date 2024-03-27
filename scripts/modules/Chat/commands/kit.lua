local self = {}

self.adminOnly = true

---@return string
function self.help()
    local kits = PalLuaApi.Modules.Chat.database.Kits.data
    local kitNames = {}
    
    for kitName, _ in pairs(kits) do
        table.insert(kitNames, kitName)
    end
    
    return "DataKitName: ".. table.concat(kitNames, "; ")    
end

---@param Sender APalPlayerController
---@param Arguments string[]
function self.execute(Sender, Arguments)
    local translation = PalLuaApi.Modules.Chat.database.Translation.data
    local message = translation.KitUsage

    if Arguments[2] then
        local targetPlayer = Sender
        local dataKitName = Arguments[2]
        if Arguments[3] then
            targetPlayer = PalLuaApi.Player.GetControllerById(tonumber(Arguments[2]))
            dataKitName = Arguments[3]
        end
        
        if targetPlayer then
            local dataKit = PalLuaApi.Utilities.GetFirstTableValue(PalLuaApi.Modules.Chat.database.Kits.data, dataKitName)
            if dataKit then
                if dataKit["Items"] then
                    for _, item in ipairs( dataKit["Items"]) do
                        PalLuaApi.Admin.GiveItemToPlayer(targetPlayer, item["ItemID"], item["Quantity"])
                    end
                end
                message = translation.Success
            else
                message = translation.Invalid
            end
        else
            message = translation.TargetNotFound
        end
    end

    PalLuaApi.System.SendSystemToPlayer(Sender, message)
end

return self