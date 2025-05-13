
-- TODO move to Helpers.Net?
---NetMessage user is actually peerid, convert using this
---@param p integer peerid
---@return integer userid
function Helpers.Format.PeerToUserID(p)
    -- all this for userid+1 usually smh
    return (p & 0xffff0000) | 0x0001
end

---Probably unreliable/unnecessary
---@param u integer userid
---@return integer peerid
function Helpers.Format.UserToPeerID(u)
    return (u & 0xffff0000)
end

---Copies an object and sets the copy's metatable as the original's.
---@param orig any
---@return any
function Helpers.Format:DeepCopy2(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[Table.DeepCopy(orig_key)] = Table.DeepCopy(orig_value)
        end
        setmetatable(copy, Table.DeepCopy(getmetatable(orig)))
    else
        copy = orig
    end

    return copy
end

-- string.find but not case sensitive
--@param str1 string       - string 1 to compare
--@param str2 string       - string 2 to compare
function Helpers.Format.CaseInsensitiveSearch(str1, str2)
    str1 = string.lower(str1)
    str2 = string.lower(str2)
    local result = string.find(str1, str2, 1, true)
    return result ~= nil
end

--- Retrieves the value of a specified property from an object or returns a default value if the property doesn't exist.
-- @param obj           The object from which to retrieve the property value.
-- @param propertyName  The name of the property to retrieve.
-- @param defaultValue  The default value to return if the property is not found.
-- @return              The value of the property if found; otherwise, the default value.
function Helpers.Format.GetPropertyOrDefault(obj, propertyName, defaultValue)
    local success, value = pcall(function() return obj[propertyName] end)
    if success then
        return value or defaultValue
    else
        return defaultValue
    end
end

-- Mapping table for common non-English characters to English equivalents
Helpers.Format.NonEnglishCharMap = {
    ["á"] = "a", ["é"] = "e", ["í"] = "i", ["ó"] = "o", ["ú"] = "u",
    ["Á"] = "A", ["É"] = "E", ["Í"] = "I", ["Ó"] = "O", ["Ú"] = "U",
    ["ä"] = "a", ["ë"] = "e", ["ï"] = "i", ["ö"] = "o", ["ü"] = "u",
    ["Ä"] = "A", ["Ë"] = "E", ["Ï"] = "I", ["Ö"] = "O", ["Ü"] = "U",
    ["à"] = "a", ["è"] = "e", ["ì"] = "i", ["ò"] = "o", ["ù"] = "u",
    ["À"] = "A", ["È"] = "E", ["Ì"] = "I", ["Ò"] = "O", ["Ù"] = "U",
    ["â"] = "a", ["ê"] = "e", ["î"] = "i", ["ô"] = "o", ["û"] = "u",
    ["Â"] = "A", ["Ê"] = "E", ["Î"] = "I", ["Ô"] = "O", ["Û"] = "U",
    ["ã"] = "a", ["õ"] = "o", ["ñ"] = "n",
    ["Ã"] = "A", ["Õ"] = "O", ["Ñ"] = "N",
    ["ç"] = "c", ["Ç"] = "C",
    ["ß"] = "ss",
    ["ø"] = "o", ["Ø"] = "O",
    ["å"] = "a", ["Å"] = "A",
    ["æ"] = "ae", ["Æ"] = "AE",
    ["œ"] = "oe", ["Œ"] = "OE",
    -- Cyrillic characters
    ["А"] = "A", ["Б"] = "B", ["В"] = "V", ["Г"] = "G", ["Д"] = "D",
    ["Е"] = "E", ["Ё"] = "E", ["Ж"] = "Zh", ["З"] = "Z", ["И"] = "I",
    ["Й"] = "I", ["К"] = "K", ["Л"] = "L", ["М"] = "M", ["Н"] = "N",
    ["О"] = "O", ["П"] = "P", ["Р"] = "R", ["С"] = "S", ["Т"] = "T",
    ["У"] = "U", ["Ф"] = "F", ["Х"] = "Kh", ["Ц"] = "Ts", ["Ч"] = "Ch",
    ["Ш"] = "Sh", ["Щ"] = "Shch", ["Ъ"] = "", ["Ы"] = "Y", ["Ь"] = "",
    ["Э"] = "E", ["Ю"] = "Yu", ["Я"] = "Ya",
    ["а"] = "a", ["б"] = "b", ["в"] = "v", ["г"] = "g", ["д"] = "d",
    ["е"] = "e", ["ё"] = "e", ["ж"] = "zh", ["з"] = "z", ["и"] = "i",
    ["й"] = "i", ["к"] = "k", ["л"] = "l", ["м"] = "m", ["н"] = "n",
    ["о"] = "o", ["п"] = "p", ["р"] = "r", ["с"] = "s", ["т"] = "t",
    ["у"] = "u", ["ф"] = "f", ["х"] = "kh", ["ц"] = "ts", ["ч"] = "ch",
    ["ш"] = "sh", ["щ"] = "shch", ["ъ"] = "", ["ы"] = "y", ["ь"] = "",
    ["э"] = "e", ["ю"] = "yu", ["я"] = "ya",
    -- Misc others
    ["ą"] = "a", ["ć"] = "c", ["ę"] = "e", ["ł"] = "l", ["ń"] = "n",
    ["ś"] = "s", ["ź"] = "z", ["ż"] = "z",
    ["Ą"] = "A", ["Ć"] = "C", ["Ę"] = "E", ["Ł"] = "L", ["Ń"] = "N",
    ["Ś"] = "S", ["Ź"] = "Z", ["Ż"] = "Z",
    ["ő"] = "o", ["ű"] = "u", ["Ő"] = "O", ["Ű"] = "U",
    ["ă"] = "a", ["ș"] = "s", ["ț"] = "t",
    ["Ă"] = "A", ["Ș"] = "S", ["Ț"] = "T",
}

-- Removes illegal characters from a filename, and replaces common non-English characters with English equivalents.
-- @param str Filename string to be sanitized.
-- @return Sanitized filename string.
function Helpers.Format.SanitizeFileName(str)
    
    -- Replace non-English characters with their English equivalents
    str = string.gsub(str, ".", function(c)
        return Helpers.Format.NonEnglishCharMap[c] or c
    end)
    
    -- Remove control characters and basic illegal characters
    str = string.gsub(str, "[%c<>:\"/\\|%?%*]", "") -- Removes:     < > : " / \ | ? *

    -- Trim whitespace from the beginning and end of the string
---@diagnostic disable-next-line: param-type-mismatch
    str = str:trim()

    return str
end

--- @param e EntityHandle
--- @return string? -- nil for errors or if entity wasn't passed
function Helpers.Format.GetEntityName(e)
    if e == nil then return nil end
    if Ext.Types.GetValueType(e) ~= "Entity" then return nil end

    if e.CustomName ~= nil then
        return e.CustomName.Name
    elseif e.DisplayName ~= nil then
        return Ext.Loca.GetTranslatedString(e.DisplayName.NameKey.Handle.Handle)
    elseif e:HasRawComponent("ls::TerrainObject") then
        return "Terrain"
    elseif e.GameObjectVisual ~= nil then
        return Ext.Template.GetTemplate(e.GameObjectVisual.RootTemplateId).Name
    elseif e.TLPreviewDummy ~= nil then
        return ("TLPreviewDummy:%s"):format(e.TLPreviewDummy.Name == "DUM_" and e.Uuid and e.TLPreviewDummy.Name..e.Uuid.EntityUuid or e.TLPreviewDummy.Name)
    elseif e.Visual ~= nil and e.Visual.Visual ~= nil and e.Visual.Visual.VisualResource ~= nil then
        local name = ""
        if e:HasRawComponent("ecl::Scenery") then
            name = name .. "(Scenery)"
        end
        local visName = "Unknown"
        -- Jank to get last part
        for part in string.gmatch(e.Visual.Visual.VisualResource.Template, "[a-zA-Z0-9_.]+") do
            visName = part
        end
        return name..visName
    elseif e.SpellCastState ~= nil then
        return "Spell Cast " .. e.SpellCastState.SpellId.Prototype
    elseif e.ProgressionMeta ~= nil then
        --- @type ResourceProgression
        local progression = Ext.StaticData.Get(e.ProgressionMeta.Progression, "Progression")
        return "Progression " .. progression.Name
    elseif e.BoostInfo ~= nil then
        return "Boost " .. e.BoostInfo.Params.Boost
    elseif e.StatusID ~= nil then
        return "Status " .. e.StatusID.ID
    elseif e.Passive ~= nil then
        return "Passive " .. e.Passive.PassiveId
    elseif e.InterruptData ~= nil then
        return "Interrupt " .. e.InterruptData.Interrupt
    elseif e.InventoryIsOwned ~= nil then
        return "Inventory of " ..(Helpers.Format.GetEntityName(e.InventoryIsOwned.Owner) or "Unknown")
    elseif e.Uuid ~= nil then
        return e.Uuid.EntityUuid
    else
        return NameGen:GenerateOrGet(e)
    end
end

function Helpers.Format.Dump(obj, requestedName)
    local data = ""
    local path = ""
    local context = Ext.IsServer() and "S" or "C"
    local objType = Ext.Types.GetObjectType(obj)
    if objType then
        local typeInfo = Ext.Types.GetTypeInfo(objType)
        if objType == "Entity" then
            data = Ext.DumpExport(obj:GetAllComponents())
            local name = Helpers.Format.GetEntityName(obj)
            if not name then
                name = string.format("UnknownEntity%s", Ext.Utils.HandleToInteger(obj))
            end
            path = path..(requestedName or name)
        else
            data = Ext.DumpExport(obj)
            local name = typeInfo and typeInfo.TypeName or "UnknownObj"
            path = path..(requestedName or name)
        end
    else
        if type(obj) == "table" then
            path = path..(requestedName or "Table")
        else path = path..(requestedName or "Unknown")
        end
        data = Ext.DumpExport(obj)
    end
    path = string.format("_Dumps/[%s]%s", context, Helpers.Format.SanitizeFileName(path))

    -- Path and data finalized, handle filename taken and overwriting
    local warn = false
    if Ext.IO.LoadFile(path.."_0.json") ~= nil then -- already have file named this
        for i = 1, 9, 1 do
            local test = string.format("%s_%d", path, i)
            if Ext.IO.LoadFile(test..".json") == nil then -- good to go
                RPrint(string.format("Dumping: %s.json", test))
                return Ext.IO.SaveFile(test..".json", data or "No dumpable data available.")
            end
        end
        warn = true
    end
    if warn then
        SWarn(string.format("Overwriting previous dump: %s_0.json (10 same-name dumps max)", path))
    end
    RPrint(string.format("Dumping: %s_0.json", path))
    return Ext.IO.SaveFile(path.."_0.json", data or "No dumpable data available.")
end

-- For allowing client to request a server dump of an object
local RequestServerDump = Ext.Net.CreateChannel(ModuleUUID, "AahzLib.RequestServerDump")
if Ext.IsClient() then
    --- Client only --TODO probably IsHost() also...? hmm
    ---@param path ObjectPath
    ---@param requestedName string?
    function Helpers.Format.RequestServerDump(path, requestedName)
        if path then
            local root = path.Root
            if type(root) ~= "string" then
                local uuid = Ext.Entity.HandleToUuid(root)
                if not uuid then
                    return SWarn("Cannot request a server dump of entities that don't have UUID's (%s)", tostring(root))
                else
                    root = uuid
                end
            end
            RequestServerDump:SendToServer({
                Root = root,
                Path = path.Path,
                RequestedName = requestedName,
            })
        else
            SWarn("Requested server dump without providing object path.")
        end
    end
else
    -- Server only
    RequestServerDump:SetHandler(function(args)
        local entity
        if type(args.Root) == "string" then
            entity = Ext.Entity.Get(args.Root)
            if entity then
                local path = ObjectPath:New(entity, args.Path)
                local obj = path:Resolve()
                if obj ~= nil then
                    Helpers.Dump(obj, args.RequestedName)
                end
            else
                SWarn("Couldn't resolve entity when requesting server dump: %s", tostring(args.Root))
            end
        else
            SWarn("Invalid root type: %s (%s)", tostring(args.Root), type(args.Root))
        end
    end)
end