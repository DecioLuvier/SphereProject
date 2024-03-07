local Logger = require("libs/Logger")
local DataManager = require("DataManager/main")
local System = require("scripts/System")

local reloadData = {}

reloadData.permissionLevel = "Admin"

---@param sender APalPlayerController
---@param arguments string[]
function reloadData.execute(sender, arguments)
    local valid, result = DataManager.Refresh()

    if valid then
        SphereGlobal.database = result
        System.SendSystemToPlayer(sender, "Success")
        Logger.print("DataManager.refresh completed successfully!")
    else
        Logger.print(result)
    end

end

return reloadData