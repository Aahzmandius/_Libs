---@class FCVarsLoadedParams:FCEventParams
---@field Levels table<string, boolean>
---@field IsEditorLevel boolean
FCParams.VarsLoaded = FCEventParamsBase:Create("FCVarsLoadedParams")

---@class FCEventVarsLoaded: FCCustomEventBase
---@field Subscribe fun(self:FCEventVarsLoaded, callback:fun(e:FCVarsLoadedParams))
Events.Custom.VarsLoaded = FCCustomEventBase:CreateEvent("FCEventVarsLoaded")

---@return FCVarsLoadedParams
function Events.Custom.VarsLoaded:CreateParams()
    return FCParams.VarsLoaded:New()
end

if Ext.IsServer() then
    function Events.Custom.VarsLoaded:RegisterEvent()
        Ext.Events.SessionLoaded:Subscribe(function()
            Ext.OnNextTick(function()
                if self:HasCallback() then
                    self:Throw(self:CreateParams())
                end
            end)
        end)
    end
else
    function Events.Custom.VarsLoaded:RegisterEvent()
        ---@param e EsvLuaGameStateChangedEvent
        Ext.Events.GameStateChanged:Subscribe(function(e)
            if self:HasCallback() and e.FromState == "PrepareRunning" and e.ToState == "Running" then
                Ext.OnNextTick(function()
                    self:Throw(self:CreateParams())
                end)
            end
        end)
    end
end