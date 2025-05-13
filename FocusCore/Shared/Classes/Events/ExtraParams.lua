---@class FCEventExtraParams:MetaClass
---@field Priority number
---@field Entity EntityHandle
FCEventExtraParams = _Class:Create("FCEventExtraParams")

---@param o any
---@return FCEventExtraParams
function FCEventExtraParams:New(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    o.Priority = o.Priority or 100
    return o
end