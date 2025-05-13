---@class FCTemplateAddedToParams:FCEventParams
---@field AddType string
---@field Entity EntityHandle
---@field EntityGuid Guid
---@field Holder EntityHandle
---@field HolderGuid Guid
---@field RealHolder EntityHandle
---@field Template Guid
FCParams.TemplateAddedTo = FCEventParamsBase:Create("FCTemplateAddedToParams")

---@class FCEventTemplateAddedTo: FCOsirisEventBase
---@field Subscribe fun(self:FCEventTemplateAddedTo, callback:fun(e:FCTemplateAddedToParams))
Events.Osiris.TemplateAddedTo = FCOsirisEventBase:CreateEvent("FCEventTemplateAddedTo", {OsirisEvent = "TemplateAddedTo", OsirisArity = 4})

---@param template Guid
---@param object Guid
---@param holder Guid
---@param addType string
---@return FCTemplateAddedToParams
function Events.Osiris.TemplateAddedTo:CreateParams(template, object, holder, addType)
    local params = FCParams.TemplateAddedTo:New{
        Template = Helpers.Format:Guid(template),
        EntityGuid = Helpers.Format:Guid(object),
        Entity = Helpers.Object:GetEntity(object),
        RealHolder = Helpers.Inventory:GetHolder(object),
        HolderGuid = Helpers.Format:Guid(holder),
        Holder = Helpers.Object:GetEntity(holder),
        AddType = addType,
    }
    return params
end