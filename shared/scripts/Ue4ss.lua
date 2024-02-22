local Ue4ss = {}

--The merge function is to exchange information of a instance using a table reference(TArray in most of cases) 
--Should preferably generate with a constructor, as it only changes the union(U) of the keys.

---@param Userdata UObject|TArray
---@param data table<K, V>
function Ue4ss.Merge(Userdata, data)
    for key, value in pairs(data) do
        if type(value) == "table" then
            if Userdata[key] == nil then
                Userdata[key] = {}
            end
            Ue4ss.Merge(Userdata[key], value)
        else
            Userdata[key] = value
        end
    end
end

return Ue4ss