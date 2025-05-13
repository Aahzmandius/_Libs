
function Helpers.SpellBook:ChangeSpellModifier(object, spellID, sourceType, modifier)
    local entity = Helpers.Object:GetEntity(object)
    if entity == nil or spellID == nil or sourceType == nil or modifier == nil or Ext.Enums.AbilityId[modifier] == nil then return end
    local newModifier = Ext.Enums.AbilityId[modifier]

    if entity.SpellContainer ~= nil then
        local spellContainer = Ext.Types.Serialize(entity.SpellContainer)
        local editedSpellContainer = false
        for i, spell in ipairs(spellContainer.Spells) do
            if spell.SpellId.OriginatorPrototype == spellID and spell.SpellId.SourceType == sourceType then
                spell.SpellCastingAbility = newModifier
                editedSpellContainer = true
                break
            end
        end
        
        if editedSpellContainer then
            Ext.Types.Unserialize(entity.SpellContainer, spellContainer)
            entity:Replicate("SpellContainer")
        end
    end
    if entity.SpellBook ~= nil then
        local spellBook = Ext.Types.Serialize(entity.SpellBook)
        local editedSpellBook = false
        for i, spell in ipairs(spellBook.Spells) do
            if spell.Id.OriginatorPrototype == spellID and spell.Id.SourceType == sourceType then
                spell.SpellCastingAbility = newModifier
                editedSpellBook = true
                break
            end
        end
        if editedSpellBook then
            Ext.Types.Unserialize(entity.SpellBook, spellBook)
            entity:Replicate("SpellBook")
        end
    end
end