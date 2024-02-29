local Utilities = {}

--The merge function is to exchange information of a instance using a table reference(TArray in most of cases) 
--Should preferably generate with a constructor, as it only changes the union(U) of the keys.

---@param Userdata UObject|TArray
---@param data table
function Utilities.MergeTables(Userdata, data)

    for key, value in pairs(data) do

        if type(value) == "table" then

            if Userdata[key] == nil then
                Userdata[key] = {}
            end
            Utilities.MergeTables(Userdata[key], value)
        else
            Userdata[key] = value
        end
    end
end

function Utilities.CompareTables(table1, table2)

    if type(table1) ~= type(table2) then
        return false
    end

    if #table1 ~= #table2 then
        return false
    end
    for key, value in pairs(table1) do
        
        if type(value) == "table" then

            if not Utilities.CompareTables(value, table2[key]) then
                return false
            end
        elseif value ~= table2[key] then
            return false
        end
    end
    return true
end

return Utilities