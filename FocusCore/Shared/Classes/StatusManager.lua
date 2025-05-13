---@class FCStatusManager:MetaClass
---@field Status string
---@field Duration number
---@field DurationAugments (fun(target:EntityHandle, attacker:EntityHandle|nil, duration:number):number|nil)[]
StatusManager = _Class:Create("FCStatusManager")
function StatusManager:Init()
    self.DurationAugments = self.DurationAugments or {}
end

---@param augment fun(target:EntityHandle, attacker:EntityHandle, duration:number):number|nil
function StatusManager:AddDurationAugment(augment)
    table.insert(self.DurationAugments, augment)
end

---Gets the manager's status on an object
---@param entity any
---@return EsvStatus|nil
function StatusManager:GetStatus(entity)
    return Helpers.Status:GetStatus(entity, self.Status)
end

---Applies the manager's status to an object
---@param target any
---@param duration? number seconds
---@param attacker? any
---@param force? boolean
function StatusManager:ApplyStatus(target, duration, attacker, force)
    local targetEntity = Helpers.Object:GetEntity(target)
    if targetEntity ~= nil then
        local attackerEntity = Helpers.Object:GetEntity(attacker)
        local finalDuration = duration or self.Duration

        for _, augment in ipairs(self.DurationAugments) do
            finalDuration = finalDuration + (augment(targetEntity, attackerEntity, finalDuration) or 0)
        end

        if attackerEntity ~= nil then
            Osi.ApplyStatus(targetEntity.Uuid.EntityUuid, self.Status, finalDuration, force and 1 or 0, attackerEntity.Uuid.EntityUuid)
        else
            Osi.ApplyStatus(targetEntity.Uuid.EntityUuid, self.Status, finalDuration, force and 1 or 0)
        end
    end
end

---Removes the manager's status from an object.
---@param target any
---@param onlyFirstInstance? boolean
function StatusManager:RemoveStatus(target, onlyFirstInstance)
    Helpers.Status:RemoveStatus(target, self.Status, onlyFirstInstance)
end