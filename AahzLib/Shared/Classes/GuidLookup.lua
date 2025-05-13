---@alias ResourceLocation
---| "StaticData" # Ext.StaticData
---| "Resource" # Ext.Resource

---@alias GuidResourceType ExtResourceManagerType|ResourceBankType

---@class ResourceLookupTuple
---@field Location ResourceLocation
---@field ResourceType GuidResourceType

---@class GuidLookup
---@field LookupMap table<Guid, ResourceLookupTuple>
local GuidLookup = {
    Ready = false,
    LookupMap = {},
}

---Retrieves a known resource based on Guid
---@param guid Guid
---@return ResourceGuidResource|ResourceResource|nil
function GuidLookup:Lookup(guid)
    if not self.Ready or not guid then return end
    local lookup = self.LookupMap[guid]
    if lookup then
        return Ext[lookup.Location].Get(guid, lookup.ResourceType)
    end
end
function GuidLookup._Initialize()
    ---@param rmt GuidResourceType
    for _,rmt in ipairs(Ext.Enums.ExtResourceManagerType) do
        if rmt == "Max" then break end
        for _,guid in ipairs(Ext.StaticData.GetAll(rmt)) do
            if guid ~= NULLUUID then
                GuidLookup.LookupMap[guid] = {
                    Location = "StaticData",
                    ResourceType = rmt,
                }
            end
        end
    end
    for _,rbt in ipairs(Ext.Enums.ResourceBankType) do
        if rbt == "Sentinel" then break end
        for _,guid in ipairs(Ext.Resource.GetAll(rbt)) do
            if guid ~= NULLUUID then
                GuidLookup.LookupMap[guid] = {
                    Location = "Resource",
                    ResourceType = rbt,
                }
            end
        end
    end
    GuidLookup.Ready = true
end
GuidLookup._Initialize()

return GuidLookup