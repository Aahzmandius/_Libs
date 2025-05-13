---@class FCItemMovedParams:FCEventParams
---@field ItemGuid Guid
---@field Item EntityHandle
---@field Template string
FCParams.ItemMoved = FCEventParamsBase:Create("FCItemMovedParams")

---@class FCEventItemMoved: FCOsirisEventBase
---@field Subscribe fun(self:FCEventItemMoved, callback:fun(e:FCItemMovedParams))
Events.Osiris.ItemMoved = FCOsirisEventBase:CreateEvent("FCEventItemMoved", {OsirisEvent = "Moved", OsirisArity = 1})

---@param item Guid
---@param character Guid
---@return FCItemMovedParams
function Events.Osiris.ItemMoved:CreateParams(item, character)
    local params = FCParams.ItemMoved:New{
        Item = Helpers.Object:GetItem(item),
        ItemGuid = Helpers.Format:Guid(item),
        Template = Helpers.Object:GetTemplate(item)
    }
    return params
end