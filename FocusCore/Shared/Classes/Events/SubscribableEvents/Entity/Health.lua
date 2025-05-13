---@class FCEntityHealthParams:FCEventParams
---@field Entity EntityHandle
---@field Health HealthComponent
---@field Flags integer
FCParams.EntityHealth = FCEventParamsBase:Create("FCEntityHealthParams")

---@class FCEventEntityHealth: FCEntityEventBase
---@field Subscribe fun(self:FCEventEntityHealth, callback:fun(e:FCEntityHealthParams))
Events.Entity.Health = FCEntityEventBase:CreateEvent("FCEventEntityHealth", {Component = "Health"})

---@param entity EntityHandle
---@param entityComponent string
---@param flags integer
---@return FCEntityHealthParams
function Events.Entity.Health:CreateParams(entity, entityComponent, flags)
    return FCParams.EntityHealth:New{
        Entity = entity,
        Health = entity[entityComponent],
        Flags = flags
    }
end