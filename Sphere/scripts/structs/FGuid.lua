local FGuid = {}

---@param Userdata FGuid
---@return FGuid
function FGuid.translate(Userdata)
    local self = {}

    self.A = Userdata.A
    self.B = Userdata.B
    self.C = Userdata.C
    self.D = Userdata.D

    return self
end

return FGuid