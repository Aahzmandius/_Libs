---@class FCComponentHealth: FCComponent
Components.Health = _Class:Create("FCComponentHealth", FCComponent)

---@param object any
---@param hp integer
---@param addTo? boolean If true, adds hp to currentHP instead of overwriting
function Components.Health:SetHP(object, hp, addTo)
    local entityObj = Helpers.Object:GetEntity(object)
    if entityObj ~= nil then
        local health = entityObj.Health
        local newHp = (addTo and health.Hp + hp) or hp
        newHp = math.min(health.MaxHp, newHp)
        entityObj.Health.Hp = newHp
        entityObj:Replicate("Health")
    end
end

---@param object any
---@param tempHp integer
---@param addTo? boolean If true, adds tempHp to currentHP instead of overwriting
---@param raiseMax? boolean
function Components.Health:SetTemporaryHP(object, tempHp, addTo, raiseMax)
    local entity = Helpers.Object:GetEntity(object)
    if entity ~= nil then
        local health = entity.Health
        local newHp = (addTo and health.TemporaryHp + tempHp) or tempHp
        if raiseMax then
            health.MaxTemporaryHp = math.min(health.MaxHp, newHp)
        else
            newHp = math.min(health.MaxTemporaryHp, newHp)
        end
        entity.Health.TemporaryHp = newHp
        entity:Replicate("Health")
    end
end