---@class FCSawParams:FCEventParams
---@field SeerGuid Guid
---@field SeerName string
---@field SeerEntity EntityRef
---@field SpottedGuid Guid
---@field SpottedName string
---@field SpottedEntity EntityRef
---@field SpottedWasSneaking boolean
FCParams.Saw = FCEventParamsBase:Create("FCSawParams")

---@class FCEventSaw: FCOsirisEventBase
---@field Subscribe fun(self:FCEventSaw, callback:fun(e:FCSawParams))
Events.Osiris.Saw = FCOsirisEventBase:CreateEvent("FCEventSaw", {OsirisEvent = "Saw", OsirisArity = 3})

---@param seer Guid
---@param spotted Guid
---@return FCSawParams
function Events.Osiris.Saw:CreateParams(seer, spotted, wasSneaking)
    local params = FCParams.Saw:New{
        SeerGuid = Helpers.Format:Guid(seer),
        SeerName = Osi.ResolveTranslatedString(Osi.GetDisplayName(seer)),
        SeerEntity = Ext.Entity.Get(seer),
        SpottedGuid = Helpers.Format:Guid(spotted),
        SpottedName = Osi.ResolveTranslatedString(Osi.GetDisplayName(spotted)),
        SpottedEntity = Ext.Entity.Get(spotted),
        SpottedWasSneaking = wasSneaking == 1
    }
    return params
end