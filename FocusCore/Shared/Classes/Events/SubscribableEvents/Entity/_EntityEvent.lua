---@class FCEntityEventBase:FCEvent
---@field private Component string
FCEntityEventBase = FCEvent:Create("FCEntityEventBase")

---@private
---@generic T
---@param class `T`
---@param entityInfo {Component:string}
---@return T
function FCEntityEventBase:CreateEvent(class, entityInfo)
    return FCEvent.Create(self, class, entityInfo)
end

---@param entity EntityHandle
---@param entityComponent string
---@param flags integer
---@return FCEventParams
function FCEntityEventBase:CreateParams(entity, entityComponent, flags)
    FCDebug("Empty Param creation function for %s", _Class:GetClassName(self))
end

---@param e FCEventParams
function FCEntityEventBase:Throw(e, entity)
    self:ResetPropagation()
    local unsubIDs = {}
    for _, callback in ipairs(self.Callbacks) do
        if callback.ExtraParams.Entity == nil or callback.ExtraParams.Entity == entity then
            callback.Callback(e)
            if e.ShouldUnsubscribe then
                table.insert(unsubIDs, callback.HandlerID)
                e.ShouldUnsubscribe = false
            end
            if e.ShouldStopPropagation then
                self.Stop = true
                break
            end
        end
    end
    for _, handlerID in pairs(unsubIDs) do
        self:Unsubscribe(handlerID)
    end
end

---@private
function FCEntityEventBase:RegisterEvent()
    ---@param entity EntityHandle
    ---@param component string
    ---@param flags integer
    Ext.Entity.Subscribe(self.Component, function(entity, component, flags)
        if self:HasCallback() then
            self:Throw(self:CreateParams(entity, component, flags), entity)
        end
    end)
end