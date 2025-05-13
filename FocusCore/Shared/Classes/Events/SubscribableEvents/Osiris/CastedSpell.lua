---@class FCCastedSpellParams:FCEventParams
---@field CasterGuid Guid
---@field Caster EntityHandle
---@field Spell string
---@field SpellType SpellType
---@field SpellElement DamageType
---@field StoryActionID integer
FCParams.CastedSpell = FCEventParamsBase:Create("FCCastedSpellParams")


---@vararg string
---@return boolean
function FCParams.CastedSpell:IsSpell(...)
    for _, id in pairs({...}) do
        if id == self.Spell then
            return true
        end
    end
    return false
end

---@class FCEventCastedSpell: FCOsirisEventBase
---@field Subscribe fun(self:FCEventCastedSpell, callback:fun(e:FCCastedSpellParams))
Events.Osiris.CastedSpell = FCOsirisEventBase:CreateEvent("FCEventCastedSpell", {OsirisEvent = "CastedSpell", OsirisArity = 5})

---@param caster Guid
---@param spell string
---@param spellType SpellType
---@param spellElement DamageType
---@param storyActionID integer
---@return FCCastedSpellParams
function Events.Osiris.CastedSpell:CreateParams(caster, spell, spellType, spellElement, storyActionID)
    local params = FCParams.CastedSpell:New{
        Caster = Ext.Entity.Get(caster),
        CasterGuid = Helpers.Format:Guid(caster),
        Spell = spell,
        SpellType = spellType,
        SpellElement = spellElement,
        StoryActionID = storyActionID,
    }
    return params
end