local self = {}

---@param Userdata UObject|TArray
---@param data table
function self.MergeTables(Userdata, data)
    for key, value in pairs(data) do
        if type(value) == "table" then
            if Userdata[key] == nil then
                Userdata[key] = {}
            end
            self.MergeTables(Userdata[key], value)
        else
            Userdata[key] = value
        end
    end
end

---@param table1 table
---@param table2 table
---@return boolean
function self.CompareTables(table1, table2)
    if type(table1) ~= type(table2) then
        return false
    end
    if #table1 ~= #table2 then
        return false
    end
    for key, value in pairs(table1) do
        if type(value) == "table" then
            if not self.CompareTables(value, table2[key]) then
                return false
            end
        elseif value ~= table2[key] then
            return false
        end
    end
    return true
end

---@param array V[]
---@param valueToCheck any
---@return boolean
function self.ArrayContainValue(array, valueToCheck)
    for _, value in ipairs(array) do
        if value == valueToCheck then
            return true
        end
    end
    return false
end

---@param table V[]
---@param NonCaseSensitiveKey string
---@return boolean
function self.GetFirstTableValue(table, NonCaseSensitiveKey)
    for key, value in pairs(table) do
        if string.lower(key) == string.lower(NonCaseSensitiveKey) then
            return value
        end
    end
    
    return nil
end

return self