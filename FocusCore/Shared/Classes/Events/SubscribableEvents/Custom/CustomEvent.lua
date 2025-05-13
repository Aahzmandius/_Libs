---@class FCCustomEventBase:FCEvent
FCCustomEventBase = FCEvent:Create("FCCustomEventBase")

---@private
---@generic T
---@param class `T`
---@return T
function FCCustomEventBase:CreateEvent(class)
    return FCEvent.Create(self, class)
end

---@param e LuaEventBase
---@return FCEventParams
function FCCustomEventBase:CreateParams(e)
    FCDebug("Empty Param creation function for %s", _Class:GetClassName(self))
end

---@private
function FCCustomEventBase:RegisterEvent()
    FCDebug("Empty event registration function for %s", _Class:GetClassName(self))
end