---@class FCComponentSpellCastState: FCComponent
Components.SpellCastState = _Class:Create("FCComponentSpellCastState", FCComponent)

---@param caster any
function Components.SpellCastState:Dump(caster)
    local entity = Helpers.Object:GetEntity(caster)
    FCPrint("checking %s %s", caster, entity)
    if entity ~= nil and entity.SpellCastState ~= nil then
        FCDump(caster.SpellCastState.Entity:GetAllComponents())
    end
end

---@param spellcast SpellCastStateComponent
---@return EntityHandle|nil
function Components.SpellCastState:GetTarget(spellcast)
    local entity = Helpers.Object:GetEntity(spellcast)
    if entity ~= nil then
        local scs = entity.SpellCastState
        if scs ~= nil and scs.Repose ~= nil and scs.Repose[1] ~= nil then
            local target = scs.Repose[1].Repose.field_8
            return target
        end
    end
end