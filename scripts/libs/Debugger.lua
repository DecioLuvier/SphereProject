local self = {}

---@param array table
---@param depth number
---@return string
function self.arrayToString(array, depth)
    depth = depth or 0
    local logString = "\n" 
    local getMessage = self.getMessage  
    
    for key, value in pairs(array) do
        local depthCharacters = string.rep("-----", depth)
        logString = logString .. depthCharacters .. "- Key: " .. getMessage(key)
        
        if type(value) == "table" then
            logString = logString .. self.arrayToString(value, depth + 1)
        else
            logString = logString .. " | Value: " .. getMessage(value) .. "\n"
        end
    end

    return logString
end

---@param target string|number|boolean|table|UObject|FString|FName|FText
---@return string
function self.getMessage(target)
    if type(target) == "string" then
        return target
    elseif type(target) == "number" or type(target) == "boolean" then
        return tostring(target)
    elseif type(target) == "table" then
        return self.arrayToString(target, 0)
    elseif type(target) == "userdata" then
        local _ue4ssType = target:type()
        if _ue4ssType == "FString" or _ue4ssType == "FName" or _ue4ssType == "FText" then
            return _ue4ssType .. " " .. target:ToString()
        elseif target:IsValid() then
            if _ue4ssType == "TArray" then
                return target:type()
            else
                return target:GetFullName()
            end
        else
            return "nil"
        end
    else
        return "nil"
    end
end

---@param target any
function self.print(target)
    print(self.getMessage(target))
end

return self