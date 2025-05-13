---@class FCObjectTimerFinishedParams:FCEventParams
---@field Object EntityHandle
---@field ObjectGuid Guid
---@field Timer string
FCParams.ObjectTimerFinished = FCEventParamsBase:Create("FCObjectTimerFinishedParams")

---@class FCEventObjectTimerFinished: FCOsirisEventBase
---@field Subscribe fun(self:FCEventObjectTimerFinished, callback:fun(e:FCObjectTimerFinishedParams))
Events.Osiris.ObjectTimerFinished = FCOsirisEventBase:CreateEvent("FCEventObjectTimerFinished", {OsirisEvent = "ObjectTimerFinished", OsirisArity = 2})

---@param object Guid
---@param timer string
---@return FCObjectTimerFinishedParams
function Events.Osiris.ObjectTimerFinished:CreateParams(object, timer)
    local params = FCParams.ObjectTimerFinished:New{
        Object = Ext.Entity.Get(object),
        ObjectGuid = Helpers.Format:Guid(object),
        Timer = timer
    }
    return params
end