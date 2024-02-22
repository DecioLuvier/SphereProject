local FQuat = {}

---@param X number
---@param Y number
---@param Z number
---@param W number
---@return FQuat
function FQuat.new(X,Y,Z,W)
    local self = {}

    self.X = X
    self.Y = Y
    self.Z = Z
    self.W = W

    return self
end

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