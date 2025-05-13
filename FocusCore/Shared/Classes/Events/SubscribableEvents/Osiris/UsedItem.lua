---@class FCUsedItemParams:FCEventParams
---@field Character EntityHandle
---@field CharacterGuid Guid
---@field Template Guid
---@field Item EntityHandle
---@field ItemGuid Guid
FCParams.UsedItem = FCEventParamsBase:New()

---@class FCEventUsedItem: FCOsirisEventBase
---@field Subscribe fun(self:FCEventUsedItem, callback:fun(e:FCUsedItemParams))
Events.Osiris.UsedItem = FCOsirisEventBase:CreateEvent("FCEventUsedItem", {OsirisEvent = "TemplateUseStarted", OsirisArity = 3})

---@param character Guid
---@param template Guid
---@param item Guid
---@return FCUsedItemParams
function Events.Osiris.UsedItem:CreateParams(character, template, item)
    return FCParams.UsedItem:New{
        Character = Helpers.Object:GetCharacter(character),
        CharacterGuid = Helpers.Format:Guid(character),
        Template = Helpers.Format:Guid(template),
        Item = Helpers.Object:GetItem(item),
        ItemGuid = Helpers.Format:Guid(item),
    }
end