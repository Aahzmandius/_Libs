---@class FCDoConsoleCommandParams:FCEventParams
---@field Event LuaDoConsoleCommandEvent
---@field Command string
FCParams.DoConsoleCommand = FCEventParamsBase:Create("FCDoConsoleCommandParams")

---@class FCEventDoConsoleCommand: FCExtenderEventBase
---@field Subscribe fun(self:FCEventDoConsoleCommand, callback:fun(e:FCDoConsoleCommandParams))
Events.Extender.DoConsoleCommand = FCExtenderEventBase:CreateEvent("FCEventDoConsoleCommand", {ExtenderEvent = Ext.Events.DoConsoleCommand})

---@param e LuaDoConsoleCommandEvent
---@return FCDoConsoleCommandParams
function Events.Extender.DoConsoleCommand:CreateParams(e)
    return FCParams.DoConsoleCommand:New{
        Event = e,
        Command = e.Command
    }
end