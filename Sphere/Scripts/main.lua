local Logger = require("libs/Logger")
Logger.Initialize()
local DataManager = require("DataManager/main")

SphereGlobal = {}

local validDataManager, resultDataManager =  DataManager.Refresh()

if validDataManager then

    SphereGlobal.database = resultDataManager
    require("Chat/main")

    Logger.print("DataManager started with Success!")

    if SphereGlobal.database.Configs.CreditMessage then


    end
else
    Logger.print(resultDataManager)
end