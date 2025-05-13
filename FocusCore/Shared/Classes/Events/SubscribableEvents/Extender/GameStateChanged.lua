---@class FCGameStateChangedParams:FCEventParams
---@field Event EsvLuaGameStateChangedEvent|EclLuaGameStateChangedEvent
---@field FromState ServerGameState|ClientGameState
---@field ToState ServerGameState|ClientGameState
FCParams.GameStateChanged = FCEventParamsBase:Create("FCGameStateChangedParams")

---@class FCEventGameStateChanged: FCExtenderEventBase
---@field Subscribe fun(self:FCEventGameStateChanged, callback:fun(e:FCGameStateChangedParams))
Events.Extender.GameStateChanged = FCExtenderEventBase:CreateEvent("FCEventGameStateChanged", {ExtenderEvent = Ext.Events.GameStateChanged})

---@param e EsvLuaGameStateChangedEvent|EclLuaGameStateChangedEvent
---@return FCGameStateChangedParams
function Events.Extender.GameStateChanged:CreateParams(e)
    return FCParams.GameStateChanged:New{
        Event = e,
        FromState = e.FromState,
        ToState = e.ToState,
    }
end