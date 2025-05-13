---@class FCExtenderEventBase:FCEvent
---@field private ExtenderEvent SubscribableEvent
FCExtenderEventBase = FCEvent:Create("FCExtenderEventBase")

---@private
---@generic T
---@param class `T`
---@param extenderInfo {ExtenderEvent:SubscribableEvent}
---@return T
function FCExtenderEventBase:CreateEvent(class, extenderInfo)
    return FCEvent.Create(self, class, extenderInfo)
end

---@param e LuaEventBase
---@return FCEventParams
function FCExtenderEventBase:CreateParams(e)
    FCDebug("Empty Param creation function for %s", _Class:GetClassName(self))
end

---@private
function FCExtenderEventBase:RegisterEvent()
    self.ExtenderEvent:Subscribe(function(e)
        if self:HasCallback() then
            self:Throw(self:CreateParams(e))
            if self.Stop then
                e:StopPropagation()
            end
        end
    end)
end