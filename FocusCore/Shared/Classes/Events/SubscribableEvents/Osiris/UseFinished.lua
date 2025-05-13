---@class FCUseFinishedParams:FCEventParams
---@field ItemGuid Guid
---@field ItemEntity EntityHandle
---@field CharacterGuid Guid
---@field CharacterEntity Guid
---@field Success boolean
FCParams.UseFinished = FCEventParamsBase:Create("FCUseFinishedParams")

---@class FCEventUseFinished: FCOsirisEventBase
---@field Subscribe fun(self:FCEventUseFinished, callback:fun(e:FCUseFinishedParams))
Events.Osiris.UseFinished = FCOsirisEventBase:CreateEvent("FCEventUseFinished", {OsirisEvent = "UseFinished", OsirisArity = 3})

---@param item Guid
---@param character Guid
---@return FCUseFinishedParams
function Events.Osiris.UseFinished:CreateParams(character, item, success)
    local params = FCParams.UseFinished:New{
        ItemGuid = Helpers.Format:Guid(item),
        ItemEntity = Ext.Entity.Get(item),
        CharacterGuid = Helpers.Format:Guid(character),
        CharacterEntity = Ext.Entity.Get(character),
        Success = success == 1
    }
    return params
end