---@class FCStatusRemovedParams:FCEventParams
---@field Attacker EntityHandle
---@field AttackerGuid Guid
---@field Target EntityHandle
---@field TargetGuid Guid
---@field StatusId string
---@field StoryID integer
---@field HasAttackerAndTarget boolean
FCParams.StatusRemoved = FCEventParamsBase:Create("FCStatusRemovedParams")

---@class FCEventStatusRemoved: FCOsirisEventBase
---@field Subscribe fun(self:FCEventStatusRemoved, callback:fun(e:FCStatusRemovedParams))
Events.Osiris.StatusRemoved = FCOsirisEventBase:CreateEvent("FCEventStatusRemoved", {OsirisEvent = "StatusRemoved", OsirisArity = 4})

---Accepts any amount of statusIds as params and returns if the current status matches a statusId and the status target still exists.
---@vararg string
---@return boolean
function FCParams.StatusRemoved:IsStatus(...)
    if self.Target ~= nil then
        for _, s in ipairs({...}) do
            if s == self.StatusId then
                return true
            end
        end
    end
    return false
end

---@param target Guid
---@param status string
---@param causee Guid
---@param storyActionID integer
---@return FCStatusRemovedParams
function Events.Osiris.StatusRemoved:CreateParams(target, status, causee, storyActionID)
    local params = FCParams.StatusRemoved:New{
        Target = Ext.Entity.Get(target),
        TargetGuid = Helpers.Format:Guid(target),
        Attacker = Ext.Entity.Get(causee),
        AttackerGuid = Helpers.Format:Guid(causee),
        StatusId = status,
        StoryID = storyActionID,
    }
    params.HasAttackerAndTarget = params.Target ~= nil and params.Attacker ~= nil
    return params
end