---@class FCUnequippedParams:FCEventParams
---@field ItemGuid Guid
---@field ItemEntity EntityHandle
---@field CharacterGuid Guid
---@field CharacterEntity Guid
FCParams.Unequipped = FCEventParamsBase:Create("FCUnequippedParams")

---@class FCEventUnequipped: FCOsirisEventBase
---@field Subscribe fun(self:FCEventUnequipped, callback:fun(e:FCUnequippedParams))
Events.Osiris.Unequipped = FCOsirisEventBase:CreateEvent("FCEventUnequipped", {OsirisEvent = "Unequipped", OsirisArity = 2})

---@param item Guid
---@param character Guid
---@return FCUnequippedParams
function Events.Osiris.Unequipped:CreateParams(item, character)
    local params = FCParams.Unequipped:New{
        ItemGuid = Helpers.Format:Guid(item),
        ItemEntity = Ext.Entity.Get(item),
        CharacterGuid = Helpers.Format:Guid(character),
        CharacterEntity = Ext.Entity.Get(character),
    }
    return params
end