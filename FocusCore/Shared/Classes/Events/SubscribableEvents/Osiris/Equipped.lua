---@class FCEquippedParams:FCEventParams
---@field CharacterGuid Guid
---@field Character EntityHandle
---@field ItemGuid Guid
---@field Item EntityHandle
FCParams.Equipped = FCEventParamsBase:Create("FCEquippedParams")

---@class FCEventEquipped: FCOsirisEventBase
---@field Subscribe fun(self:FCEventEquipped, callback:fun(e:FCEquippedParams))
Events.Osiris.Equipped = FCOsirisEventBase:CreateEvent("FCEventEquipped", {OsirisEvent = "Equipped", OsirisArity = 2})

---@param item Guid
---@param character Guid
---@return FCEquippedParams
function Events.Osiris.Equipped:CreateParams(item, character)
    local params = FCParams.Equipped:New{
        CharacterGuid = Helpers.Format:Guid(character),
        Character = Ext.Entity.Get(character),
        ItemGuid = Helpers.Format:Guid(item),
        Item = Ext.Entity.Get(item),
    }
    return params
end