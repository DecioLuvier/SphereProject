local Logger = require("libs/Logger")
Logger.Initialize()
local DataManager = require("DataManager/main")

Logger.print("Version: V2.5 03/11/2024")
Logger.print("Starting...")

SphereGlobal = {}

local validDataManager, resultDataManager =  DataManager.Refresh()

if validDataManager then

    SphereGlobal.database = resultDataManager
    require("Chat/main")

    Logger.print("DataManager started with Success!")

    if SphereGlobal.database.Configs.CreditMessage then
        Logger.print("--------")
        Logger.print("Our plugin will always be free!")
        Logger.print("Creator: Decio Luvier (#pw_another)")
        Logger.print("Special thanks to Patreon supporters:")
        Logger.print("#minhon.")
        Logger.print("#proj1w420")
        Logger.print("#.mathayus")
        Logger.print("https://discord.gg/cS62fmW6TF")
        Logger.print("--------")
    end
else
    Logger.print(resultDataManager)
end