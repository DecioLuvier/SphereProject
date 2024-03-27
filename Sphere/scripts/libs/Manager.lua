local Json = require("libs/Json")

local self = {}

---@param folderPath string
---@return boolean
local function FolderExists(folderPath)
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
        return true
    end
end

---@param filePath string
---@return boolean, table|nil
local function ReadJsonFile(filePath)
    local file = io.open(filePath, "r")

    if file then
        local data = file:read("*a")
        file:close()
        local validDecode, resultDecode = pcall(Json.decode, data)
        return validDecode, resultDecode
    else
        PalLuaApi.Logger.Log(string.format("Manager.ReadJsonFile file not exist, %s", filePath))
        return false, nil
    end
end

---@param filePath string
---@param data table
local function WriteJsonFile(filePath, data)
    local validEncode, resultEncode = pcall(Json.encode, data)

    if validEncode then
        local file = io.open(filePath, "w")

        if file then
            file:write(Json.beautify(resultEncode)):close()
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
        local validCreateFolder =  CreateFolder(entry.folderPath)
        local defaultPath = entry.folderPath .. "Default(ResetEveryStart)\\"
        local defaultFilePath = defaultPath .. entry.fileName .. ".json"
        local validCreateDefaultFolder =  CreateFolder(defaultPath)
        local filePath = entry.folderPath .. entry.fileName .. ".json"
        if validCreateFolder and validCreateDefaultFolder then
            if not FileExists(filePath) or entry.overwrite then
                local defaultData = entry.copyDefault and entry.schema.default or {}
                WriteJsonFile(filePath, defaultData)
            end

            WriteJsonFile(defaultFilePath, entry.schema.default)

            local validReadJsonFile, resultReadJsonFile = ReadJsonFile(filePath)
    
            if validReadJsonFile then
                local schemaValid, schemaErrors = entry.schema.validate(resultReadJsonFile)
        
                if schemaValid then
                    PalLuaApi.Logger.Print("-----SUCCESS-----")
                    PalLuaApi.Logger.Print(filePath)
                    entry.data = resultReadJsonFile
                else
                    PalLuaApi.Logger.Print("------FAILED------")
                    PalLuaApi.Logger.Print(filePath)
                    PalLuaApi.Logger.Print(schemaErrors)
                    PalLuaApi.Logger.Print(string.format("Loading %s instead", defaultFilePath))
                    entry.data = entry.schema.default
                end
            else
                PalLuaApi.Logger.Print("------FAILED------")
                PalLuaApi.Logger.Print(filePath)
                PalLuaApi.Logger.Print(resultReadJsonFile)
                PalLuaApi.Logger.Print(string.format("Loading %s instead", defaultFilePath))
                entry.data = entry.schema.default
            end
        else
            PalLuaApi.Logger.Print("------FAILED------")
            PalLuaApi.Logger.Print(filePath)
            PalLuaApi.Logger.Print("You should contact the sphere discord.")
            PalLuaApi.Logger.Print(string.format("Loading default instead"))
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