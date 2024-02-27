local Debugger = require("scripts/Debugger")
local Database = require("scripts/Database")

local customPals = require("schemas/customPals")



Database.write("customPals",customPals.default)
local valid, err = customPals.validate(Database.read("customPals"))

Debugger.print(valid)
Debugger.print(err)

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