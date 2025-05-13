---@class FCEntityGameObjectVisualParams:FCEventParams
---@field Entity EntityHandle
---@field Visual GameObjectVisualComponent
---@field Flags integer
FCParams.EntityGameObjectVisual = FCEventParamsBase:Create("FCEntityGameObjectVisualParams")

---@class FCEventEntityGameObjectVisual: FCEntityEventBase
---@field Subscribe fun(self:FCEventEntityGameObjectVisual, callback:fun(e:FCEntityGameObjectVisualParams))
Events.Entity.GameObjectVisual = FCEntityEventBase:CreateEvent("FCEventEntityGameObjectVisual", {Component = "GameObjectVisual"})

---@param entity EntityHandle
---@param entityComponent string
---@param flags integer
---@return FCEntityGameObjectVisualParams
function Events.Entity.GameObjectVisual:CreateParams(entity, entityComponent, flags)
    return FCParams.EntityGameObjectVisual:New{
        Entity = entity,
        Visual = entity[entityComponent],
        Flags = flags
    }
end