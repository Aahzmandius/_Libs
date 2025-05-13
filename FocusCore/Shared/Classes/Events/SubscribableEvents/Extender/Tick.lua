---@class FCTickParams:FCEventParams
---@field Time GameTime
FCParams.Tick = FCEventParamsBase:Create("FCTickParams")

---@class FCEventTick: FCExtenderEventBase
---@field Subscribe fun(self:FCEventTick, callback:fun(e:FCTickParams))
Events.Extender.Tick = FCExtenderEventBase:CreateEvent("FCEventTick", {ExtenderEvent = Ext.Events.Tick})

---@param e LuaTickEvent
---@return FCTickParams
function Events.Extender.Tick:CreateParams(e)
    return FCParams.Tick:New{
        Time = e.Time
    }
end