local Json = require("libs/Json")

local self = {}

---@param folderPath string
---@return boolean
local function FolderExists(folderPath)
    PalLuaApi.Logger.Log(string.format("Manager.FolderExists %s", folderPath))
    local _, _, errorCode = os.rename(folderPath, folderPath)

    if errorCode then 
        if errorCode == 2  then
            return false
        elseif errorCode == 13  then
            return true
        else
            PalLuaApi.Logger.Log(string.format("Manager.FolderExists Invalid error code, %i", errorCode))
            return true
        end
    else
        return true
    end
end

---@param filePath string
---@return boolean
local function FileExists(filePath)
    PalLuaApi.Logger.Log(string.format("Manager.FileExists %s", filePath))
    local File = io.open(filePath, "r")
    
    if File then
        File:close()
        return true
    else
        return false
    end
end

---@param folderPath string
---@return boolean
local function CreateFolder(folderPath)
    PalLuaApi.Logger.Log(string.format("Manager.CreateFolder %s", folderPath))
    local FolderExists = FolderExists(folderPath)

    if not FolderExists then
        local command = io.popen(string.format("mkdir %s", folderPath))
        if command then
            PalLuaApi.Logger.Log(string.format("Manager.CreateFolder success, %s", folderPath))
            command:close()
            return true
        else
            PalLuaApi.Logger.Log(string.format("Manager.CreateFolder failed mkdir: %s", folderPath))
            return false
        end
    else
        PalLuaApi.Logger.Log(string.format("Manager.CreateFolder already exists, %s", folderPath))
        return true
    end
end

---@param filePath string
---@return boolean, table|nil
local function ReadJsonFile(filePath)
    PalLuaApi.Logger.Log(string.format("Manager.ReadJsonFile %s", filePath))
    local file = io.open(filePath, "r")

    if file then
        local data = file:read("*a")
        file:close()
        local validDecode, resultDecode = pcall(Json.decode, data)

        if validDecode then
            PalLuaApi.Logger.Log(string.format("Manager.ReadJsonFile success, %s", filePath))
            return true, resultDecode
        else
            PalLuaApi.Logger.Log(string.format("Manager.ReadJsonFile json error, %s", resultDecode))
            return false, nil
        end
    else
        PalLuaApi.Logger.Log(string.format("Manager.ReadJsonFile file not exist, %s", filePath))
        return false, nil
    end
end

---@param filePath string
---@param data table
local function WriteJsonFile(filePath, data)
    PalLuaApi.Logger.Log(string.format("Manager.WriteJsonFile %s", filePath))
    local validEncode, resultEncode = pcall(Json.encode, data)

    if validEncode then
        local file = io.open(filePath, "w")

        if file then
            file:write(Json.beautify(resultEncode)):close()
            PalLuaApi.Logger.Log(string.format("Manager.WriteJsonFile success, %s", filePath))
        else
            PalLuaApi.Logger.Log(string.format("Manager.WriteJsonFile cannot create, %s", filePath))
        end
    else
        PalLuaApi.Logger.Log(string.format("Manager.WriteJsonFile json error, %s %s", filePath, resultEncode))
    end
end

---@param Module table
function self.refreshDatabase(Module)
    for _, entry in pairs(Module.database) do
        PalLuaApi.Logger.Log(string.format("Manager.refreshDatabase %s", entry.fileName))
        local validCreateFolder =  CreateFolder(entry.folderPath)
        local defaultPath = entry.folderPath .. "Default(ResetEveryStart)\\"
        local defaultFilePath = defaultPath .. entry.fileName .. ".json"
        local validCreateDefaultFolder =  CreateFolder(defaultPath)
        if validCreateFolder and validCreateDefaultFolder then
            local filePath = entry.folderPath .. entry.fileName .. ".json"
            PalLuaApi.Logger.Print(string.format("try %s", filePath))
    
            if not FileExists(filePath) or entry.overwrite then
                local defaultData = entry.copyDefault and entry.schema.default or {}
                WriteJsonFile(filePath, defaultData)
            end

            WriteJsonFile(defaultFilePath, entry.schema.default)

            local validReadJsonFile, resultReadJsonFile = ReadJsonFile(filePath)
    
            if validReadJsonFile then
                local schemaValid, schemaErrors = entry.schema.validate(resultReadJsonFile)
        
                if schemaValid then
                    PalLuaApi.Logger.Print(string.format("success %s", filePath))
                    entry.data = resultReadJsonFile
                else
                    PalLuaApi.Logger.Print(schemaErrors) 
                    PalLuaApi.Logger.Print(string.format("failed %s, loading default", filePath))
                    entry.data = entry.schema.default
                end
            else
                entry.data = entry.schema.default
            end
        else
            PalLuaApi.Logger.Print(string.format("failed %s, loading default", entry.folderPath))
            entry.data = entry.schema.default
        end
    end
end

function self.refreshAllDatabases()
     for _, modules in pairs(PalLuaApi.Modules) do
        self.refreshDatabase(modules)
     end
end

return self