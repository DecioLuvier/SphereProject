local json = require("libs/json")

local Database = {}

Database.Path = ".\\Mods\\Sphere\\Data\\"

---@param File string
---@return table|nil
function Database.read(File)
    local realPath = Database.Path..File..".json"
    local file = io.open(realPath, "r")
    if not file then
        print("Error opening file: " .. realPath)
        return nil
    end
    local data = file:read("*all")
    file:close()
    local success, decodedData = pcall(json.decode, data)
    return decodedData
end

---@param File string
---@param data table
function Database.write(File, data)
    local realPath = Database.Path .. File .. ".json"
    local success, encodedData = pcall(json.encode, data)

    if success then
        local beautifiedData = json.beautify(encodedData)
        local file = io.open(realPath, "w")

        if file then
            file:write(beautifiedData)
            file:close()
            print("Data successfully written to file: " .. realPath)
        else
            print("Error: Unable to open file for writing: " .. realPath)
        end
    else
        print("Error encoding data to JSON: " .. encodedData)
    end
end

return Database