---@class FCNetMessageParams:FCEventParams
---@field Event LuaNetMessageEvent
---@field Channel string
---@field Message any
FCParams.NetMessage = FCEventParamsBase:Create("FCNetMessageParams")

---@class FCEventNetMessage: FCExtenderEventBase
---@field Subscribe fun(self:FCEventNetMessage, callback:fun(e:FCNetMessageParams))
Events.Extender.NetMessage = FCExtenderEventBase:CreateEvent("FCEventNetMessage", {ExtenderEvent = Ext.Events.NetMessage})

---@param e LuaNetMessageEvent
---@return FCNetMessageParams
function Events.Extender.NetMessage:CreateParams(e)
    return FCParams.NetMessage:New{
        Event = e,
        Channel = e.Channel,
        Message = e.Payload ~= "" and Helpers.Format:Parse(e.Payload) or ""
    }
end