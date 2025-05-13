---@class LocalSettings: MetaClass
---@field FileName string
---@field Data table<any> associative table
---@field SaveImmediately boolean # save immediately after changes
---@field FolderName string|nil #defaults to mod.Info.Name
---@field Ready boolean
LocalSettings = _Class:Create("LocalSettings", nil, {
    SaveImmediately = true,
    FileName = "LocalSettings",
})

function LocalSettings:__tostring() return string.format("%s Data, %d entries", self.FileName, self:Count()) end

-- Manager class, no init
-- function LocalSettings:Init()
--     self.FileName = self.FileName or "LocalSettings"
--     self.Data = self.Data or {}
--     self.SaveImmediately = (self.SaveImmediately == nil) or self.SaveImmediately
-- end

---Saves the LocalSettings data to a given fileName within a subfolder of
--- %localappdata%/Larian Studios/Baldur's Gate 3/Script Extender
--- Resulting file is "<folder>/<fileName>.json"
function LocalSettings:SaveToFile()
    local modinfo = Ext.Mod.GetMod(ModuleUUID).Info
    local save = Ext.DumpExport(self.Data)
    self.FolderName = self.FolderName or modinfo.Name
    local path = self.FolderName.."/"..self.FileName..".json"
    if save ~= nil then
        Ext.IO.SaveFile(path, save)
        --ECDebug("Saved LocalSettings to: %s", fileName)
    else
        SWarn("LocalSettings have invalid data, failed to save: %s", self.Data)
    end
end
function LocalSettings:_readyCheck()
    if not self.Ready then self:_getReady() end
end
function LocalSettings:_getReady()
    local modinfo = Ext.Mod.GetMod(ModuleUUID).Info
    self.FolderName = self.FolderName or modinfo.Name
    local path = self.FolderName.."/"..self.FileName..".json"
    local contents = Ext.IO.LoadFile(path)
    if contents ~= nil then
        -- Has contents, try to read
        local success, data = pcall(Ext.Json.Parse, contents)
        if success then
            -- Valid file contents, read those in and ready up
            self.Data = data
            self.Ready = true
            return
        end
    end
    -- If we're here, no valid data found, initialize new
    self.Data = {}
    self.Ready = true
end

function LocalSettings:Count()
    self:_readyCheck()
    local count = 0
    for _ in pairs(self.Data) do count = count + 1 end
    return count
end
function LocalSettings:Get(key)
    self:_readyCheck()
    return self.Data[key]
end
function LocalSettings:GetOr(default, key)
    self:_readyCheck()
    if self.Data[key] == nil then
        self.Data[key] = default
        if self.SaveImmediately then self:SaveToFile() end
    end
    return self.Data[key]
end
function LocalSettings:AddOrChange(key, data)
    self:_readyCheck()
    if self.Data[key] == nil then
        self.Data[key] = data
    else
        -- already exists
        self.Data[key] = data
    end
    if self.SaveImmediately then self:SaveToFile() end
end
function LocalSettings:Remove(key)
    self:_readyCheck()
    self.Data[key] = nil
    if self.SaveImmediately then self:SaveToFile() end
end

--- For caching things at runtime
---@class Cache :LocalSettings
Cache = _Class:Create("Cache", "LocalSettings", {
    SaveImmediately = true,
    FileName = "ScribeCache",
    Data = {},
})

---@enum CacheData
CacheData = {
    RuntimeComponentNames = "RuntimeComponentNames",
    UnmappedComponentNames = "UnmappedComponentNames",
    LastIgnoredComponents = "LastIgnoredComponents",
    LastWatchedComponents = "LastWatchedComponents",
}

local function GenerateCache()
    local allTypes = Ext.Types.GetAllTypes()
    local componentNames = {}
    for _,tn in ipairs(allTypes) do
        local t = Ext.Types.GetTypeInfo(tn)
        if t.ParentType and t.ParentType.TypeName == "BaseComponent" then
            componentNames[t.TypeName] = t.ComponentName
        end
    end
    Cache:AddOrChange(CacheData.RuntimeComponentNames, componentNames)
end
GenerateCache()