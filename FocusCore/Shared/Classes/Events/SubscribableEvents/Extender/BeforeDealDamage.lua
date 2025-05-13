---@type table<integer, {Attacker:EntityHandle, Target:EntityHandle}>
local HitPairs = {}

if Ext.IsServer() then
    ---@param e EsvLuaDealDamageEvent
    Ext.Events.DealDamage:Subscribe(function(e)
        HitPairs[e.StoryActionId] = {
            Attacker = e.Caster,
            Target = e.Target
        }
    end)

    ---@param e EsvLuaBeforeDealDamageEvent
    Ext.Events.BeforeDealDamage:Subscribe(function(e)
        HitPairs[e.Hit.StoryActionId] = nil
    end, {Priority = 99})
end

---@class FCBeforeDealDamageParams:FCEventParams
---@field Event EsvLuaBeforeDealDamageEvent
---@field Attacker EntityHandle
---@field Target EntityHandle
---@field SpellId string
---@field TotalDamage integer
FCParams.BeforeDealDamage = FCEventParamsBase:Create("FCBeforeDealDamageParams")

---@class FCEventBeforeDealDamage: FCExtenderEventBase
---@field Subscribe fun(self:FCEventBeforeDealDamage, callback:fun(e:FCBeforeDealDamageParams))
Events.Extender.BeforeDealDamage = FCExtenderEventBase:CreateEvent("FCEventBeforeDealDamage", {ExtenderEvent = Ext.Events.BeforeDealDamage})

---@param e EsvLuaBeforeDealDamageEvent
---@return FCBeforeDealDamageParams
function Events.Extender.BeforeDealDamage:CreateParams(e)
    return FCParams.BeforeDealDamage:New{
        Event = e,
        Attacker = HitPairs[e.Hit.StoryActionId].Attacker,
        Target = HitPairs[e.Hit.StoryActionId].Target,
        SpellId = e.Hit.SpellId,
        TotalDamage = e.Hit.TotalDamageDone,
    }
end