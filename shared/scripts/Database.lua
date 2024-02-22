local Json = require("libs/Json")

local Database = {}

Database.Path = ".\\Mods\\shared\\data\\"

---@param File string
---@return table
function Database.read(File)
    local realPath = Database.Path..File..".json"
    local file = io.open(realPath, "r")
    local data = file:read("a")
    file:close()
    return Json.decode(data)
end

return Database