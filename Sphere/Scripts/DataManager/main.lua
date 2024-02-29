local json = require("libs/json")
local Logger = require("Logger/main")
local DataManager = require("DataManager/config")

---@param path string
---@param FileName string
---@return table|nil
local function Read(Path, FileName)
    local realPath = Path .. FileName .. ".json"
    local file = io.open(realPath, "r")
    if file then
        local jsonData = file:read("*a")
        file:close()
        local valid, result = pcall(json.decode, jsonData)
        return valid, result
    end
end

---@param path string
---@param FileName string
---@param Data table
local function Write(Path, FileName, Data)
    local realPath = Path .. FileName .. ".json"
    local success, encodedData = pcall(json.encode, Data)
    if success then
        local beautifiedData = json.beautify(encodedData)
        Logger.print("Creating " .. realPath)
        local FileName = io.open(realPath, "w")
        if FileName then
            FileName:write(beautifiedData)
            FileName:close()
        end
    end
    return success, encodedData
end

---@param FileName string
---@return boolean
local function FileExists(Path, FileName)
    local realPath = Path .. FileName .. ".json"
    local File = io.open(realPath, "r")
    
    if File then
        File:close()
        return true
    end
    return false
end

---@return boolean, boolean
local function FolderExists(Path)
    local _, _, errorCode = os.rename(Path, Path)

    if errorCode then 
        if errorCode == 2  then
            return true, false
        elseif errorCode == 13  then
            Logger.print(string.format("Warning  FolderExists code %i", errorCode))
            return true, true
        else
            return false, string.format("FolderExists Invalid error code, %i", errorCode)
        end
    else
        return true, true
    end
end

---@return boolean, string
local function InitFolders()

    for i = 1, #DataManager.pathOrder do
        local realPath = DataManager.paths[DataManager.pathOrder[i]]
        local FolderExistsValid, FolderExistsResult =  FolderExists(realPath)

        if FolderExistsValid then
            if not FolderExistsResult then
                Logger.print("Creating " .. realPath)
                local command = io.popen(string.format("mkdir %s", realPath))
                local mkdirResult = command:read("*a") 
                command:close()

                if not mkdirResult then
                    return false, "InitFolders mkdirErrors"
                end
            end
        else
            return false, FolderExistsResult
        end
    end
    return true, nil
end

---@return boolean, string
local function InitEntries()

    for fileName, entry in pairs(DataManager.entries) do

        if not FileExists(entry.path, fileName) or entry.overwrite then
            if entry.copyDefault then
                local writeSuccess, writeErrors =  Write(entry.path, fileName,  entry.schema.default)

                if not writeSuccess then
                    return false, writeErrors
                end
            else
                local writeSuccess, writeErrors =  Write(entry.path, fileName,  {})

                if not writeSuccess then
                    return false, writeErrors
                end
            end
        end
        local writeSuccess, writeErrors =  Write(entry.path, "Default" .. fileName, entry.schema.default)

        if not writeSuccess then
            return false, writeErrors
        end
    end
    return true, nil
end

local function GetAllEntries()
    local allEntries = {} 

    for entryKey, entry in pairs(DataManager.entries) do
        if FileExists(entry.path, entryKey) then
            local valid, result = Read(entry.path, entryKey)

            if not valid then
                Logger.print(string.format("Error  DataManager.GetAllEntries read %s%s", entry.path, entryKey))
                return false, result
            end
            local schemaValid, schemaErrors = entry.schema.validate(result)

            if not schemaValid then
                Logger.print(string.format("Error  DataManager.GetAllEntries validate %s%s", entry.path, entryKey))
                return false, schemaErrors
            end
            allEntries[entryKey] = result
        end
    end
    return true, allEntries
end

function DataManager.Refresh()
    Logger.print("Try      DataManager.InitFolders")
    local initFoldersValid, initFoldersErrors = InitFolders()

    if not initFoldersValid then
        return false, initFoldersErrors
    end
    Logger.print("Success  DataManager.InitFolders") 
    Logger.print("Try      DataManager.InitEntries")
    local initEntriesValid, initEntriesResult = InitEntries()

    if not initEntriesValid then
        return false, initEntriesResult
    end
    Logger.print("Success  DataManager.InitEntries") 
    Logger.print("Try      DataManager.GetAllEntries")
    return GetAllEntries()
end

return DataManager