---@class FCDealDamageParams:FCEventParams
---@field Event EsvLuaDealDamageEvent
FCParams.DealDamage = FCEventParamsBase:Create("FCDealDamageParams")

---@class FCEventDealDamage: FCExtenderEventBase
---@field Subscribe fun(self:FCEventDealDamage, callback:fun(e:FCDealDamageParams))
Events.Extender.DealDamage = FCExtenderEventBase:CreateEvent("FCEventDealDamage", {ExtenderEvent = Ext.Events.DealDamage})

---@param e EsvLuaDealDamageEvent
---@return FCDealDamageParams
function Events.Extender.DealDamage:CreateParams(e)
    return FCParams.DealDamage:New{
        Event = e
    }
end