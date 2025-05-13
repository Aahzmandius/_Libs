---@class Events
Events = {
    Entity = {},
    Extender = {},
    Osiris = {},
    Custom = {}
}

---@class FCEvent: MetaClass
---@field private Callbacks FCEventCallback[]
---@field private Stop boolean
---@field private IsRegistered boolean
FCEvent = _Class:Create("FCEvent")

---@private
---Creates a new event class with a given name
---@generic T
---@param class `T` Name of new class
---@param initial? table Initializing table for the class
---@return T
function FCEvent.Create(parentclass, class, initial)
    initial = initial or {}
    initial.Callbacks = {}
    return _Class:Create(class, parentclass, initial)
end

---@private
function FCEvent:SortCallbacks()
    table.sort(self.Callbacks, function(a, b) return a.ExtraParams.Priority > b.ExtraParams.Priority end)
end

---@private
---@return number
function FCEvent:GetNewHandlerID()
    local handlerID = 1
    if #self.Callbacks > 0 then
        handlerID = self.Callbacks[#self.Callbacks].HandlerID + 1
    end
    return handlerID
end

function FCEvent:RegisterEvent()
    FCWarn("Unset event registration function!")
end

---@param fn fun(e:FCEventParams)
---@param extraParams? FCEventExtraParams
---@return number
function FCEvent:Subscribe(fn, extraParams)
    if not self.IsRegistered then
        self:RegisterEvent()
        self.IsRegistered = true
    end

    local callback = FCEventCallback:New{
        Callback = fn,
        HandlerID = self:GetNewHandlerID(),
        ExtraParams = FCEventExtraParams:New(extraParams),
    }
    callback.Event = self
    table.insert(self.Callbacks, callback)
    self:SortCallbacks()
    return callback.HandlerID
end

---@param handlerID number
function FCEvent:Unsubscribe(handlerID)
    for i, callback in ipairs(self.Callbacks) do
        if callback.HandlerID == handlerID then
            table.remove(self.Callbacks, i)
            break
        end
    end
end

---@protected
---@return boolean
function FCEvent:HasCallback()
    return next(self.Callbacks) ~= nil
end

---@protected
function FCEvent:ResetPropagation()
    self.Stop = false
end


---@protected
---@param e FCEventParams
function FCEvent:Throw(e)
    self:ResetPropagation()
    local unsubIDs = {}
    for _, callback in ipairs(self.Callbacks) do
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
    for _, handlerID in pairs(unsubIDs) do
        self:Unsubscribe(handlerID)
    end
end

---@protected
---@param e FCEventParams
---@return any|nil
function FCEvent:ThrowReturn(e)
    self:ResetPropagation()
    local unsubIDs = {}
    local value
    for _, callback in ipairs(self.Callbacks) do
        value = callback.Callback(e) or value
        if e.ShouldUnsubscribe then
            table.insert(unsubIDs, callback.HandlerID)
            e.ShouldUnsubscribe = false
        end
        if e.ShouldStopPropagation then
            self.Stop = true
            break
        end
    end
    for _, handlerID in pairs(unsubIDs) do
        self:Unsubscribe(handlerID)
    end
    return value
end