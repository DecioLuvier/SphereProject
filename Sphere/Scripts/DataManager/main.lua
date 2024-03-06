local Logger = require("libs/Logger")
local FileManager = require("libs/FileManager")
local ConfigDataManager = require("DataManager/config")

local DataManager = {}

local function InitializeFolders()
    Logger.Log("DataManager.InitializeFolders")

    for _, path in pairs(ConfigDataManager.paths) do
        local validCreateFolder, resultCreateFolder =  FileManager.CreateFolder(path)
        if validCreateFolder then
            Logger.Log(resultCreateFolder)
        else
            return false, resultCreateFolder
        end
    end
    return true, nil
end

local function InitializeEntries()
    Logger.Log("DataManager.InitializeEntries")
    for fileName, entry in pairs(ConfigDataManager.entries) do
        if not FileManager.FileExists(entry.path .. fileName .. ".json") or entry.overwrite then
            local defaultData = entry.copyDefault and entry.schema.default or {}
            local writeSuccess, writeErrors = FileManager.CreateJsonFile(entry.path .. fileName .. ".json", defaultData)
            
            if not writeSuccess then
                return false, writeErrors
            end
        end
        
        local writeSuccess, writeErrors = FileManager.CreateJsonFile(entry.path .. "Default" .. fileName .. ".json", entry.schema.default)

        if not writeSuccess then
            return false, writeErrors
        end
    end
    return true
end

local function GetEntriesData()
    Logger.Log("DataManager.GetAllEntries")
    local allEntries = {}
    for entryKey, entry in pairs(ConfigDataManager.entries) do
        local validReadJsonFile, resultReadJsonFile = FileManager.ReadJsonFile(entry.path .. entryKey .. ".json")

        if not validReadJsonFile then
            Logger.print(string.format("Error  DataManager.GetAllEntries read %s%s", entry.path, entryKey))
            return false, resultReadJsonFile
        end

        local schemaValid, schemaErrors = entry.schema.validate(resultReadJsonFile)

        if not schemaValid then
            Logger.print(string.format("Error  DataManager.GetAllEntries validate %s%s", entry.path, entryKey))
            return false, schemaErrors
        end

        allEntries[entryKey] = resultReadJsonFile

    end
    return true, allEntries
end

function DataManager.Refresh()
    Logger.Log("DataManager.Refresh")

    local InitializeFoldersValid, InitializeFoldersErrors = InitializeFolders()

    if not InitializeFoldersValid then
        return false, InitializeFoldersErrors
    end

    local InitializeEntriesValid, InitializeEntriesResult = InitializeEntries()

    if not InitializeEntriesValid then
        return false, InitializeEntriesResult
    end

    return GetEntriesData()
end

return DataManager