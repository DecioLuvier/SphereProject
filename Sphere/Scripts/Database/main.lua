local json = require("libs/json")
local Debugger = require("scripts/Debugger")

local Database = {}

Database.paths = {}

Database.paths.root = "Sphere\\"
Database.paths.data =  Database.paths.root .. "Data\\"

Database.entries = {
    Pals = {
        path = Database.paths.data,
        schema =  require("./Database/schemas/CustomPals"),
    }
}

---@return boolean, string
function Database.InitFolders()
    local order = { 
        Database.paths.root,  
        Database.paths.data
    }

    for i = 1, #order do
        local path = order[i]
        local folderExistsValid, folderExistsResult = Database.FolderExists(path)

        if not folderExistsValid then
            return false, folderExistsResult
        end

        if not folderExistsResult then
            local mkdirValid, mkdirResult = pcall(function()
                os.execute("mkdir " .. path)
            end)

            if not mkdirValid then
                return false, mkdirResult
            end
        end
    end
    return true, "Success Database.InitFolders"
end

---@return boolean, string
function Database.InitEntries()

    for fileName, entry in pairs(Database.entries) do

        if not Database.FileExists(entry.path, fileName) then
            Database.write(entry.path, fileName, {})
        end
        Database.write(entry.path, "Default" .. fileName, entry.schema.default)
    end
    return true,"Success Database.InitEntries"
end

---@return boolean, string
function Database.ValidateEntries()

    for fileName, entry in pairs(Database.entries) do

        if Database.FileExists(entry.path, fileName) then
            local valid, result = Database.read(entry.path, fileName)

            if not valid then
                return false, string.format("Error Database.read %s", result)
            end
            local valid, result = entry.schema.validate(result)

            if not valid then
                return valid, result
            end
        end
    end
    return true,"Success Database.ValidateEntries"
end

--Private

---@param path string
---@param FileName string
---@param Data table
function Database.write(Path, FileName, Data)
    local realPath = Path .. FileName .. ".json"
    local success, encodedData = pcall(json.encode, Data)
    if success then
        local beautifiedData = json.beautify(encodedData)
        local FileName = io.open(realPath, "w")
        if FileName then
            FileName:write(beautifiedData)
            FileName:close()
        end
    end
end

---@param path string
---@param FileName string
---@return table|nil
function Database.read(Path, FileName)
    local realPath = Path .. FileName .. ".json"
    local file = io.open(realPath, "r")
    if file then
        local jsonData = file:read("*a")
        file:close()
        local valid, result = pcall(json.decode, jsonData)
        return valid, result
    end
end

---@return boolean, string|boolean
function Database.FolderExists(Path)
    local valid, result = pcall(function()
        local f = io.open(Path, "r")
        if f then
            f:close()
            return true, true
        else
            return true, false
        end
    end)
    return valid, result
end

---@param FileName string
---@return boolean
function  Database.FileExists(Path, FileName)
    local realPath = Path .. FileName .. ".json"
    local File = io.open(realPath, "r")
    if File then
        File:close()
        return true
    end
    return false
end

return Database