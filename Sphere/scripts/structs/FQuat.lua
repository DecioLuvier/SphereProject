local FQuat = {}

---@param Userdata FQuat
---@return FQuat
function FQuat.translate(Userdata)
    local self = {}

    self.X = Userdata.X
    self.Y = Userdata.Y
    self.Z = Userdata.Z
    self.W = Userdata.W

    return self
end

return FQuat