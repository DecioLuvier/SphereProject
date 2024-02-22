local FVector = {}

---@param Userdata FVector
---@return FVector
function FVector.translate(Userdata)
    local self = {}

    self.X = Userdata.X
    self.Y = Userdata.Y
    self.Z = Userdata.Z

    return self
end

return FVector