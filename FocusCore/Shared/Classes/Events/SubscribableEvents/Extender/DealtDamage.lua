---@class FCDealtDamageParams:FCEventParams
---@field Event EsvLuaDealtDamageEvent
---@field Attacker EntityHandle|nil
---@field AttackerGuid Guid|nil
---@field Target EntityHandle
---@field TargetGuid Guid
---@field SpellId string
---@field TotalDamage integer
FCParams.DealtDamage = FCEventParamsBase:Create("FCDealtDamageParams")

--- Checks if the damage was dealt from a spell. Accepts any number of string params.
---@vararg string
---@return boolean
function FCParams.DealtDamage:FromSpell(...)
    for _, id in pairs({...}) do
        if self.SpellId == id then
            return true
        end
    end
    return false
end

--- Checks if the damage was dealt from a spell that contains the given name. Accepts any number of string params.
function FCParams.DealtDamage:FromSpellPrototype(...)
    for _, id in pairs({...}) do
        if string.find(self.SpellId, id) then
            return true
        end
    end
    return false
end

---@class FCEventDealtDamage: FCExtenderEventBase
---@field Subscribe fun(self:FCEventDealtDamage, callback:fun(e:FCDealtDamageParams))
Events.Extender.DealtDamage = FCExtenderEventBase:CreateEvent("FCEventDealtDamage", {ExtenderEvent = Ext.Events.DealtDamage})

---@param e EsvLuaDealtDamageEvent
---@return FCDealtDamageParams
function Events.Extender.DealtDamage:CreateParams(e)
    local params = FCParams.DealtDamage:New{
        Event = e,
        Attacker = e.Caster,
        Target = e.Target,
        SpellId = e.SpellId.Prototype,
        TotalDamage = e.Result.DamageSums.TotalDamageDone
    }

    if e.Caster ~= nil then
        params.AttackerGuid = e.Caster.Uuid.EntityUuid
    end

    params.TargetGuid = e.Target.Uuid.EntityUuid

    return params
end