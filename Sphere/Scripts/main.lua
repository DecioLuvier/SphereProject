local Logger = require("Logger/Main")
local DataManager = require("DataManager/main")

Logger.start()

SphereGlobal = {}

local valid, result = DataManager.Refresh()

if valid then
    SphereGlobal.database = result
    require("Chat/main")
    Logger.print("DataManager.refresh completed successfully!")

    if SphereGlobal.database.Configs.CreditMessage then
        Logger.credit()
    end
else
    Logger.print(result)
end