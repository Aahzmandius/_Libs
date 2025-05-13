---@class FocusCorePrinter: MetaClass
---@field Prefix string
---@field Machine "S"|"C"
---@field Beautify boolean
---@field StringifyInternalTypes boolean
---@field IterateUserdata boolean
---@field AvoidRecursion boolean
---@field LimitArrayElements integer
---@field LimitDepth integer
---@field FontColor vec3
---@field BackgroundColor vec3
---@field ApplyColor boolean
FocusCorePrinter = _Class:Create("FocusCorePrinter", nil, {
    Prefix = "FocusCorePrinter",
    Machine = Ext.IsServer() and "S" or "C",
    Beautify = true,
    StringifyInternalTypes = true,
    IterateUserdata = true,
    AvoidRecursion = true,
    LimitArrayElements = 3,
    LimitDepth = 1,
    FontColor = {192, 192, 192},
    BackgroundColor = {12, 12, 12},
    ApplyColor = false
})

---@param r integer 0-255
---@param g integer 0-255
---@param b integer 0-255
function FocusCorePrinter:SetFontColor(r, g, b)
    self.FontColor = {r or 0, g or 0, b or 0}
    --self:Print("Changed Font Color to %s %s %s", r, g, b)
end

---@param r integer 0-255
---@param g integer 0-255
---@param b integer 0-255
function FocusCorePrinter:SetBackgroundColor(r, g, b)
    self.BackgroundColor = {r or 0, g or 0, b or 0}
    --self:Print("Changed Background Color to %s %s %s", r, g, b)
end

---@param text string
---@param fontColor? vec3 Override the current font color
---@param backgroundColor? vec3 Override the current background color
---@return string
function FocusCorePrinter:Colorize(text, fontColor, backgroundColor)
    local fr, fg, fb = table.unpack(fontColor or self.FontColor)
    local br, bg, bb = table.unpack(backgroundColor or self.BackgroundColor)
    return string.format("\x1b[38;2;%s;%s;%s;48;2;%s;%s;%sm%s", fr, fg, fb, br, bg, bb, text)
end

function FocusCorePrinter:ToggleApplyColor()
    self.ApplyColor = not self.ApplyColor
    self:Print("Applying Color: %s", self.ApplyColor)
end

---@vararg any
function FocusCorePrinter:Print(...)
    local s = string.format("[%s %s] ", self.Machine, self.Prefix)
    if self.ApplyColor then
        s = self:Colorize(s)
    end

    local f
    if #{...} <= 1 then
        f = tostring(...)
    else
        f = string.format(...)
    end

    Ext.Utils.Print(s..f)
end

---@vararg any
function FocusCorePrinter:PrintTest(...)
    local s = string.format("[%s %s][%s][%s] ", self.Machine,  self.Prefix, "TEST", Ext.Utils.MonotonicTime())
    if self.ApplyColor then
        s = self:Colorize(s)
    end

    local f
    if #{...} <= 1 then
        f = tostring(...)
    else
        f = string.format(...)
    end

    Ext.Utils.Print(s..f)
end

function FocusCorePrinter:PrintWarning(...)
    local s = string.format("[%s %s][%s] ", self.Machine, self.Prefix, "WARN")
    if self.ApplyColor then
        s = self:Colorize(s)
    end

    local f
    if #{...} <= 1 then
        f = tostring(...)
    else
        f = string.format(...)
    end

    Ext.Utils.PrintWarning(s..f)
end

function FocusCorePrinter:PrintDebug(...)
    local s = string.format("[%s %s][%s][%s] ", self.Machine, self.Prefix, "DEBUG", Ext.Utils.MonotonicTime())
    if self.ApplyColor then
        s = self:Colorize(s)
    end

    local f
    if #{...} <= 1 then
        f = tostring(...)
    else
        f = string.format(...)
    end

    Ext.Utils.Print(s..f)
end

---@param info any
---@param useOptions? boolean
---@param includeTime? boolean
function FocusCorePrinter:Dump(info, useOptions, includeTime)
    local s = string.format("[%s %s][%s]", self.Machine, self.Prefix, "DUMP")
    if self.ApplyColor then
        s = self:Colorize(s)
    end

    if includeTime == true then
        s = string.format("%s[%s]", s, Ext.Utils.MonotonicTime())
    end

    s = s.." "

    local infoString
    if useOptions == true then
        infoString = Ext.Json.Stringify(info, {
            Beautify = self.Beautify,
            StringifyInternalTypes = self.StringifyInternalTypes,
            IterateUserdata = self.IterateUserdata,
            AvoidRecursion = self.AvoidRecursion,
            LimitArrayElements = self.LimitArrayElements,
            LimitDepth = self.LimitDepth
        })
    else
        infoString = Ext.DumpExport(info)
    end
    Ext.Utils.Print(s, infoString)
end

---@param array FlashArray
---@param arrayName? string
function FocusCorePrinter:DumpArray(array, arrayName)
    local name = arrayName or "array"
    for i = 1, #array do
        self:Print("%s[%s]: %s", name, i, array[i])
    end
end

function FocusCorePrinter:PrintNXM()
    local text = "\n"..[[
        __/\\\\\_____/\\\__/\\\_______/\\\__/\\\\____________/\\\\_______________        
         _\/\\\\\\___\/\\\_\///\\\___/\\\/__\/\\\\\\________/\\\\\\_______________       
          _\/\\\/\\\__\/\\\___\///\\\\\\/____\/\\\//\\\____/\\\//\\\______/\\\_____      
           _\/\\\//\\\_\/\\\_____\//\\\\______\/\\\\///\\\/\\\/_\/\\\_____\/\\\_____     
            _\/\\\\//\\\\/\\\______\/\\\\______\/\\\__\///\\\/___\/\\\__/\\\\\\\\\\\_    
             _\/\\\_\//\\\/\\\______/\\\\\\_____\/\\\____\///_____\/\\\_\/////\\\///__   
              _\/\\\__\//\\\\\\____/\\\////\\\___\/\\\_____________\/\\\_____\/\\\_____  
               _\/\\\___\//\\\\\__/\\\/___\///\\\_\/\\\_____________\/\\\_____\///______ 
                _\///_____\/////__\///_______\///__\///______________\///________________
    ]]
    text = text:gsub(".", {
        ["_"] = self:Colorize("_", {0, 50, 125}, {12, 12, 12}),
        ["/"] = self:Colorize("/", {255, 255, 0}, {12, 12, 12}),
        ["\\"] = self:Colorize("\\", {255, 255, 0}, {12, 12, 12})
    })
    self:Print(text)
end

FCPrinter = FocusCorePrinter:New{Prefix = "FocusCore", ApplyColor = true}
function FCPrint(...) FCPrinter:SetFontColor(0, 255, 255) FCPrinter:Print(...) end
function FCTest(...) FCPrinter:SetFontColor(100, 200, 150) FCPrinter:PrintTest(...) end
function FCDebug(...) FCPrinter:SetFontColor(200, 100, 50) FCPrinter:PrintDebug(...) end
function FCWarn(...) FCPrinter:SetFontColor(200, 200, 0) FCPrinter:PrintWarning(...) end
function FCDump(...) FCPrinter:SetFontColor(190, 150, 225) FCPrinter:Dump(...) end
function FCDumpArray(...) FCPrinter:DumpArray(...) end