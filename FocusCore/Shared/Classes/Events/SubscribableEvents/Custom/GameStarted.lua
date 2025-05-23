---@class FCGameStartedParams:FCEventParams
---@field Levels table<string, boolean>
---@field IsEditorLevel boolean
FCParams.GameStarted = FCEventParamsBase:Create("FCGameStartedParams")

---@class FCEventGameStarted: FCCustomEventBase
---@field Subscribe fun(self:FCEventGameStarted, callback:fun(e:FCGameStartedParams))
Events.Custom.GameStarted = FCCustomEventBase:CreateEvent("FCEventGameStarted")

---@return FCGameStartedParams
function Events.Custom.GameStarted:CreateParams()

    -- No access to level manager :(
    local levels = {}
    for _, entity in pairs(Ext.Entity.GetAllEntitiesWithComponent("Level")) do
        if entity.Level ~= nil and entity.Level.LevelName ~= nil then -- fix for problems that aren't my fault :peepoclap:
            levels[entity.Level.LevelName] = true
        end
    end

    local CCLevels = {}
    for _, modGuid in pairs(Ext.Mod.GetLoadOrder()) do
        if Ext.Mod.IsModLoaded(modGuid) then
            CCLevels[Ext.Mod.GetMod(modGuid).Info.CharacterCreationLevelName] = true
        end
    end

    local isEditorLevel = false
    for level in pairs(levels) do
        if CCLevels[level] then
            isEditorLevel = true
            break
        end
    end

    return FCParams.GameStarted:New{
        Levels = levels,
        IsEditorLevel = isEditorLevel
    }
end

if Ext.IsServer() then
    function Events.Custom.GameStarted:RegisterEvent()
        Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "before", function()
            if self:HasCallback() then
                self:Throw(self:CreateParams())
            end
        end)
    end
else
    function Events.Custom.GameStarted:RegisterEvent()
        ---@param e EsvLuaGameStateChangedEvent
        Ext.Events.GameStateChanged:Subscribe(function(e)
            if self:HasCallback() and e.FromState == "PrepareRunning" and e.ToState == "Running" then
                self:Throw(self:CreateParams())
            end
        end)
    end
end