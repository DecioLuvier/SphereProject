
local Debugger = require("scripts/Debugger")
local Database = require("Database/main")

Debugger.log("Version: V2.0 02/28/2024")
Debugger.log("Creator: #pw_another")
Debugger.log("Patreon Supporters:")
Debugger.log("minhon.")
Debugger.log("https://discord.gg/cS62fmW6TF")

local valid, result = Database.InitFolders()
Debugger.log(result)
local valid, result = Database.InitEntries()
Debugger.log(result)
local valid, result = Database.ValidateEntries()
Debugger.log(result)



--Database.write("customPals",customPals.default)
--local valid, err = customPals.validate(Database.read("customPals"))
--
--Debugger.print(valid)
--Debugger.print(err)

--local file = io.open(realPath, "r")
--local data = json.decode(file:read("a"))
--file:close()
--local valid, err = schemMonsters.validate(data)
--Debugger.print(valid)
--Debugger.print(err)


--local encoded_data = json.encode(Monsters.default)
--local file = io.open(realPath, "w")
--file:write(json.Beautify(encoded_data))
--file:close()
