local Json = require("libs/Json")
local Logger = require("libs/Logger")

local FileManager = {}

---@param path string
---@return boolean, boolean|string
function FileManager.FolderExists(path)
    Logger.Log(string.format("FileManager.FolderExists %s", path))
    
    local _, _, errorCode = os.rename(path, path)

    if errorCode then 
        if errorCode == 2  then
            return true, false
        elseif errorCode == 13  then
            return true, true
        else
            return false, string.format("FileManager.FolderExists Invalid error code, %i", errorCode)
        end
    else
        return true, true
    end
end

---@param path string
---@return boolean, boolean|string
function FileManager.CreateFolder(path)
    Logger.Log(string.format("FileManager.CreateFolder %s", path))
    local validFolderExists, resultFolderExists = FileManager.FolderExists(path)

    if validFolderExists then
        if not resultFolderExists then
            local command = io.popen(string.format("mkdir %s", path))
            local mkdirResult = command:read("*a")
            command:close()
            if mkdirResult then
                return true, string.format("FileManager.CreateFolder success, %s", path)
            end
        else
            return true, string.format("FileManager.CreateFolder Folder already exists, ignoring, %s", path)
        end
    else    
        return false, resultFolderExists
    end
end

---@param path string
---@return boolean
function FileManager.FileExists(path)
    Logger.Log(string.format("FileManager.FileExists %s", path))
    local File = io.open(path, "r")
    if File then
        File:close()
        return true
    end
    return false
end

---@param path string
---@return boolean, table|string
function FileManager.ReadJsonFile(path)
    Logger.Log(string.format("FileManager.ReadJsonFile %s", path))
    local file = io.open(path, "r")

    if file then
        local data = file:read("*a")
        file:close()
        local validDecode, resultDecode = pcall(Json.decode, data)
        return validDecode, resultDecode
    else
        return false, string.format("FileManager.ReadJsonFile file not exist, %s", path)
    end
end

---@param path string
---@param data table
---@return boolean, string
function FileManager.CreateJsonFile(path, data)
    Logger.Log(string.format("FileManager.CreateJsonFile %s", path))
    local validEncode, resultEncode = pcall(Json.encode, data)

    if validEncode then
        local file = io.open(path, "w")

        if file then
            file:write(Json.beautify(resultEncode))
            file:close()
            return true, string.format("FileManager.CreateJsonFile success, %s", path)
        else
            return false, string.format("FileManager.CreateJsonFile cannot create, %s", path)
        end
    else
        return false, resultEncode
    end
end

return FileManager