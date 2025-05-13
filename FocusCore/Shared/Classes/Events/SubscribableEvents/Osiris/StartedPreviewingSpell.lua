---@class FCPreviewingSpellParams:FCEventParams
---@field Attacker EsvCharacter|EsvItem|nil
---@field Spell string
---@field IsMostPowerful boolean
---@field HasMultipleLevels boolean
FCParams.PreviewingSpell = FCEventParamsBase:Create("FCPreviewingSpellParams")

---@class FCEventPreviewingSpell: FCOsirisEventBase
---@field Subscribe fun(self:FCEventPreviewingSpell, callback:fun(e:FCPreviewingSpellParams))
Events.Osiris.PreviewingSpell = FCOsirisEventBase:CreateEvent("FCEventPreviewingSpell", {OsirisEvent = "StartedPreviewingSpell", OsirisArity = 4})

---@param attacker Guid
---@param spell string
---@param isMostPowerful integer
---@param hasMultipleLevels integer
---@return FCPreviewingSpellParams
function Events.Osiris.PreviewingSpell:CreateParams(attacker, spell, isMostPowerful, hasMultipleLevels)
    local params = FCParams.PreviewingSpell:New{
        Attacker = Ext.Entity.Get(attacker),
        Spell = spell,
        IsMostPowerful = isMostPowerful == 1,
        HasMultipleLevels = hasMultipleLevels == 1,
    }
    return params
end