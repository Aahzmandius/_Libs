---@class StatsAggregator: MetaClass
---@field Entries StatsAggregatorEntry[]
---@field Files table<string, string[]>
StatsAggregator = _Class:Create("StatsAggregator")
StatsAggregator.Entries = {}
StatsAggregator.Mods = {
    "Shared",
    "SharedDev",
    "Gustav",
    "GustavDev",
    --"Honour"
}
StatsAggregator.Files = {
    Armor = {
        "Armor",
    },
    Character = {
        "Character",
    },
    CriticalHitTypeData = {
        "CriticalHitTypes",
    },
    InterruptData = {
        "Interrupt",
    },
    Object = {
        "Object",
    },
    PassiveData = {
        "Passive",
    },
    SpellData = {
        "Spell_Projectile",
        "Spell_ProjectileStrike",
        "Spell_Rush",
        "Spell_Shout",
        "Spell_Target",
        "Spell_Teleportation",
        "Spell_Throw",
        "Spell_Wall",
        "Spell_Zone",
    },
    StatusData = {
        "Status_BOOST",
        "Status_DEACTIVATED",
        "Status_DOWNED",
        "Status_EFFECT",
        "Status_FEAR",
        "Status_HEAL",
        "Status_INCAPACITATED",
        "Status_INVISIBLE",
        "Status_KNOCKED_DOWN",
        "Status_POLYMORPHED",
        "Status_SNEAKING",
    },
    Weapon = {
        "Weapon",
    },
}

function StatsAggregator:SortEntries()
    table.sort(self.Entries, function(a, b) return a.Name.Value < b.Name.Value end)
end

---@param entryName string
---@return StatsAggregatorEntry|nil
function StatsAggregator:GetEntry(entryName)
    for _, entry in ipairs(self.Entries) do
        if entry.Name.Value == entryName then
            return entry
        end
    end
end

---@param entryAsString string
---@param mod string
---@return StatsAggregatorEntry
function StatsAggregator:ParseEntry(entryAsString, mod)
    local entry = StatsAggregatorEntry:New()
    for line in entryAsString:gmatch("(.-)%\r%\n") do
        if line:sub(1,2) ~= [[//]] then
            local prefix, info = line:match("([%w%s]+)%s(\".+\")")
            if prefix == "new entry" then
                entry:SetName(info:match("\"(.+)\""), mod)
            elseif prefix == "type" then
                entry:SetType(info:match("\"(.+)\""), mod)
            elseif prefix == "using" then
                entry:SetUsing(info:match("\"(.+)\""), mod)
            elseif prefix == "data" then
                local dataType, dataValue = info:match("\"(.-)\"%s\"(.*)\"")
                entry:AddData(dataType, dataValue, mod)
            else
                FCDump(entryAsString)
                FCWarn("Unhandled line %s", line)
            end
        end
    end
    return entry
end

---@param currentEntry StatsAggregatorEntry
---@param newEntry StatsAggregatorEntry
function StatsAggregator:UpdateEntry(currentEntry, newEntry)
    if newEntry.Using ~= nil and (newEntry.Using.Value == newEntry.Name.Value) then
        currentEntry:IntegrateData(newEntry)
    else
        currentEntry:OverwriteData(newEntry)
    end
end

---@param entry StatsAggregatorEntry
---@return StatsAggregatorEntry
function StatsAggregator:GetEntryWithInheritance(entry, inheritance)
    inheritance = inheritance or entry --[[@as StatsAggregatorEntry]]
    local parent = entry.Using ~= nil and self:GetEntry(entry.Using.Value)
    if parent then
        if parent.Using ~= nil then
            if entry.Using.Value ~= parent.Using.Value then
                parent = self:GetEntryWithInheritance(parent)
            else
                entry:IntegrateData(parent)
                return entry
            end
        end
        entry:InheritData(parent)
    end
    return entry
end

---@param property table
---@param str string
---@return string
function StatsAggregator:AddModToEntryString(property, str)
    local length = str.len(property.Mod)
    local tabsAmount =  3 - math.floor((length + 2) / 4)
    local tabs = ""
    for i = 1, tabsAmount do
        tabs = tabs.."\t"
    end
    return string.format("[%s]%s%s", property.Mod, tabs, str)
end

local Duplicates = 0
---@param directories string[]
---@param filesNames string[]
---@param populateInheritedProperties boolean
---@param addTranslatedStrings boolean
function StatsAggregator:LoadStatsFiles(directories, filesNames, populateInheritedProperties, addTranslatedStrings)
    self.Entries = {}

    for _, dir in ipairs(directories) do
        for _, file in ipairs(filesNames) do
            local fileName = string.format("Public/%s/Stats/Generated/Data/%s.txt", dir, file)
            local contents = Ext.IO.LoadFile(fileName, "data")
            if contents ~= nil then
                Ext.IO.SaveFile(dir..file..".txt", contents)
                for entry in string.gmatch(contents, "(new entry.-%\r%\n)%\r%\n") do
                    local newEntry = self:ParseEntry(entry, dir)
                    local currentEntry = self:GetEntry(newEntry.Name.Value)
                    if currentEntry ~= nil then
                        Duplicates = Duplicates + 1
                        self:UpdateEntry(currentEntry, newEntry)
                    else
                        table.insert(self.Entries, newEntry)
                    end
                end
            end
        end
    end

    if populateInheritedProperties then
        local newEntries = {}
        for _, entry in ipairs(self.Entries) do
            if entry.Using ~= nil then
                entry = self:GetEntryWithInheritance(entry)
            end
            table.insert(newEntries, entry)
        end
        self.Entries = newEntries
    end

    if addTranslatedStrings then
        for i, entry in ipairs(self.Entries) do
            local descriptionData = entry:GetData("Description")
            if descriptionData ~= nil then
                local handle = descriptionData.Value:match("(.+);%d?")
                if handle ~= nil and handle ~= "" then
                    entry:AddData("DescriptionTranslated", Ext.Loca.GetTranslatedString(handle) ,"Focus")
                end
            end
            
            local displayNameData = entry:GetData("DisplayName")
            if displayNameData ~= nil then
                local handle = displayNameData.Value:match("(.+);%d?")
                if handle ~= nil and handle ~= "" then
                    entry:AddData("DisplayNameTranslated", Ext.Loca.GetTranslatedString(handle), "Focus")
                end
            end

            local extraDescriptionData = entry:GetData("ExtraDescription")
            if extraDescriptionData ~= nil then
                local handle = extraDescriptionData.Value:match("(.+);%d?")
                if handle ~= nil and handle ~= "" then
                    entry:AddData("ExtraDescriptionTranslated", Ext.Loca.GetTranslatedString(handle), "Focus")
                end
            end

            --TooltipUpCastDescription

            --TooltipPermanentWarning
        end
    end
end

---@param fileName string
---@param sortLarian boolean if true then sort entries data properties in Larian style, otherwise alphabetical
---@param modOnNewEntry boolean
---@param modOnProperties boolean
function StatsAggregator:WriteEntriesFile(fileName, sortLarian, modOnNewEntry, modOnProperties)
    local newLine = "\r\n"
    local fileContents = ""
    for i, entry in pairs(self.Entries) do
        local newEntryStr = string.format("new entry \"%s\"%s", entry.Name.Value, newLine)
        if modOnNewEntry then
            newEntryStr = self:AddModToEntryString(entry.Name, newEntryStr)
        end

        local typeStr = string.format("type \"%s\"%s", entry.Type.Value, newLine)
        if modOnProperties then
            typeStr = self:AddModToEntryString(entry.Type, typeStr)
        end

        local usingStr = ""
        if entry.Using ~= nil then
            usingStr = string.format("using \"%s\"%s", entry.Using.Value, newLine)
            if modOnProperties then
                usingStr = self:AddModToEntryString(entry.Using, usingStr)
            end
        end

        if sortLarian then
            entry:SortDataLarian()
        else
            entry:SortDataAlphabetical()
        end

        local allPropsStr = ""
        for _, data in ipairs(entry.Data) do
            local propStr = string.format("data \"%s\" \"%s\"%s", data.DataType, data.Value, newLine)
            if modOnProperties then
                propStr = self:AddModToEntryString(data, propStr)
            end
            allPropsStr = allPropsStr..propStr
        end

        local entryAsString = string.format("%s%s%s%s", newEntryStr, typeStr, usingStr, allPropsStr)
        --Add entry
        fileContents = fileContents..entryAsString..newLine
    end

    Ext.IO.SaveFile(fileName, fileContents)
end

---@param statsDataType "Armor"|"Character"|"CriticalHitTypeData"|"InterruptData"|"Object"|"PassiveData"|"SpellData"|"StatusData"|"Weapon"
---@param populateInheritedProperties boolean
---@param addTranslatedStrings boolean
---@param sortLarian boolean
---@param modNameOnEntry boolean
---@param modNameOnProperties boolean
function StatsAggregator:GenerateStatsFile(statsDataType, populateInheritedProperties, addTranslatedStrings, sortLarian, modNameOnEntry, modNameOnProperties)
    local fileName = string.format("%s%s%s.txt", statsDataType, populateInheritedProperties and "Inherited" or "", sortLarian and "" or "Sorted")
    self:LoadStatsFiles(self.Mods, self.Files[statsDataType], populateInheritedProperties, addTranslatedStrings)
    self:SortEntries()
    self:WriteEntriesFile(fileName, sortLarian, modNameOnEntry, modNameOnProperties)
end

function StatsAggregator:GenerateAllStatsFiles()
    for dataType in pairs(self.Files) do
        self:GenerateStatsFile(dataType, true, true, true, true, true)
        self:GenerateStatsFile(dataType, true, true, false, true, true)
        self:GenerateStatsFile(dataType, false, true, true, true, true)
        self:GenerateStatsFile(dataType, false, true, false, true, true)
    end
end

function StatsAggregator:GenerateAllStatsFilesWithMods()
    for dataType in pairs(self.Files) do
        self:GenerateStatsFile(dataType, true, true, true, false, false)
        self:GenerateStatsFile(dataType, true, true, false, false, false)
        self:GenerateStatsFile(dataType, false, true, true, false, false)
        self:GenerateStatsFile(dataType, false, true, false, false, false)
    end
end