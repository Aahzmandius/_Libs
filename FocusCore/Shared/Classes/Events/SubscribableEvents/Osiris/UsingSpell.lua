---@class FCUsingSpellParams:FCEventParams
---@field AttackerEntity EntityHandle
---@field AttackerObject EsvCharacter|EsvItem
---@field AttackerGuid Guid
---@field Spell string
---@field SpellType string
---@field SpellElement string
---@field StoryID integer
FCParams.UsingSpell = FCEventParamsBase:Create("FCUsingSpellParams")

---@class FCEventUsingSpell: FCOsirisEventBase
---@field Subscribe fun(self:FCEventUsingSpell, callback:fun(e:FCUsingSpellParams))
Events.Osiris.UsingSpell = FCOsirisEventBase:CreateEvent("FCEventUsingSpell", {OsirisEvent = "UsingSpell", OsirisArity = 5})

---@param attacker Guid
---@param spell string
---@param spellType string
---@param spellElement string
---@param storyActionID integer
---@return FCUsingSpellParams
function Events.Osiris.UsingSpell:CreateParams(attacker, spell, spellType, spellElement, storyActionID)
    local params = FCParams.UsingSpell:New{
        AttackerEntity = Helpers.Object:GetEntity(attacker),
        AttackerObject = Helpers.Object:GetObject(attacker),
        AttackerGuid = Helpers.Format:Guid(attacker),
        Spell = spell,
        SpelType = spellType,
        SpellElement = spellElement,
        StoryID = storyActionID,
    }
    return params
end