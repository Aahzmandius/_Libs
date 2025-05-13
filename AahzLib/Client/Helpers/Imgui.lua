Imgui = {}
function Imgui.ScaleFactor()
    -- testing monitor for development is 1440p
    return Ext.IMGUI.GetViewportSize()[2] / 1440
end

-- Destroy imgui children, while allowing a "SafeKeep" method to be called instead if it exists in UserData
-- SafeKeep method is expected to detach and attach child elsewhere so parent is clean
function Imgui.ClearChildren(el)
    if el == nil or not pcall(function() return el.Handle end) then return end
    for _, v in pairs(el.Children) do
        if v.UserData ~= nil and v.UserData.SafeKeep ~= nil then
            v.UserData.SafeKeep()
        else
            v:Destroy()
        end
    end
end

---Creates a layout table and inserts content into the right-aligned cell 
---@param parent ExtuiTreeParent
---@param estimatedWidth number
---@param contentFunc fun(contentCell:ExtuiTableCell):...:any
---@param sameLine boolean? # true = layoutTable.SameLine = true
---@return ... # returns result of contentFunc
function Imgui.CreateRightAlign(parent, estimatedWidth, contentFunc, sameLine)
    -- Right align button :deadge:
    local ltbl = parent:AddTable("", 2)
    if sameLine then ltbl.SameLine = true end
    ltbl:AddColumn("", "WidthStretch")
    ltbl:AddColumn("", "WidthFixed", estimatedWidth)
    local r = ltbl:AddRow()
    r:AddCell() -- empty
    local contentCell = r:AddCell()
    if type(contentFunc) == "function" then
        return contentFunc(contentCell)
    end
end

---Creates a layout table and inserts content into the middle-aligned cell 
---@param parent ExtuiTreeParent
---@param estimatedWidth number
---@param contentFunc fun(contentCell:ExtuiTableCell):...:any
---@param sameLine boolean? # true = layoutTable.SameLine = true
---@return ... # returns result of contentFunc
function Imgui.CreateMiddleAlign(parent, estimatedWidth, contentFunc, sameLine)
    -- Middle align button :deadge:
    local ltbl = parent:AddTable("", 3)
    if sameLine then ltbl.SameLine = true end
    ltbl:AddColumn("", "WidthStretch")
    ltbl:AddColumn("", "WidthFixed", estimatedWidth)
    ltbl:AddColumn("", "WidthStretch")
    local r = ltbl:AddRow()
    r:AddCell() -- empty
    local contentCell = r:AddCell()
    r:AddCell() -- empty
    if type(contentFunc) == "function" then
        return contentFunc(contentCell)
    end
end

---Sets common style vars for popup
---@param popup ExtuiPopup|ExtuiTooltip
---@return ExtuiPopup|ExtuiTooltip
function Imgui.SetPopupStyle(popup)
    popup:SetColor("PopupBg", {0.18, 0.15, 0.15, 1.00})
    popup:SetStyle("PopupBorderSize", 2)
    popup:SetColor("BorderShadow", {0,0,0,0.4})
    popup:SetColor("Border", Imgui.Colors.Tan)
    popup:SetStyle("WindowPadding", 15, 15)
    return popup
end
---Sets common style vars for a chunky separator text
---@generic T 
---@param e `T`|ExtuiStyledRenderable
---@return T
function Imgui.SetChunkySeparator(e)
    e:SetStyle("SeparatorTextBorderSize", 10)
    e:SetStyle("SeparatorTextAlign", 0.5, 0.4)
    e:SetStyle("SeparatorTextPadding", 0, 0)
    return e
end

---@param tooltip ExtuiTooltip
---@param contentFunc? fun(tooltip:ExtuiTooltip):ExtuiTooltip?
---@return ExtuiTooltip?
function Imgui.CreateSimpleTooltip(tooltip, contentFunc)
    Imgui.SetPopupStyle(tooltip)
    if contentFunc then
        contentFunc(tooltip)
    end
    return tooltip
end

---Sets up imgui table with common defaults
---@param t ExtuiTable
---@param borders boolean true|false
---@param rowBg boolean true|false Alternating row colors
---@param sizingString nil|"SizingFixedFit"|"SizingFixedSame"|"SizingStretchProp"|"SizingStretchSame" sizing options
---@param noClip boolean NoClip setting
---@param noHostExtendX boolean Whether or not table behaves, seemingly
---@return ExtuiTable
function Imgui.SetupTable(t, borders, rowBg, sizingString, noClip, noHostExtendX)
    t.Borders = borders or false
    t.RowBg = rowBg or false
    local sizings = {
        ["SizingFixedFit"] = true,
        ["SizingFixedSame"] = true,
        ["SizingStretchProp"] = true,
        ["SizingStretchSame"] = true,
    }
    if sizingString ~= nil and sizings[sizingString] then
        t[sizingString] = true
    end
    t.NoClip = noClip or false
    t.NoHostExtendX = noHostExtendX or false
    return t
end

Imgui.Colors = {
    FailColor       = Helpers.Color.HexToNormalizedRGBA("#FF0000", 1),
    SuccessColor    = Helpers.Color.HexToNormalizedRGBA("#00FF00", 1),
    NeutralColor    = Helpers.Color.HexToNormalizedRGBA("#b2b2b2", 1),
    Red             = Helpers.Color.HexToNormalizedRGBA("#FF0000", 1),
    Green           = Helpers.Color.HexToNormalizedRGBA("#00FF00", 1),
    Neutral         = Helpers.Color.HexToNormalizedRGBA("#b2b2b2", 1),
    Blue            = Helpers.Color.HexToNormalizedRGBA("#1cb2db", 1),
    BG3Green        = Helpers.Color.HexToNormalizedRGBA("#A0B056", 1),
    BG3Blue         = Helpers.Color.HexToNormalizedRGBA("#0c4961", 1),
    BG3Brown        = Helpers.Color.HexToNormalizedRGBA("#523c28", 1),
    Tan             = Helpers.Color.HexToNormalizedRGBA("#99724c", 1),
    SkyBlue         = Helpers.Color.HexToNormalizedRGBA("#1FCCEC", 1),
    RealSkyBlue     = Helpers.Color.HexToNormalizedRGBA("#87CEEB", 1),
    DeepSkyBlue     = Helpers.Color.HexToNormalizedRGBA("#00BFFF", 1),
    Cyan            = Helpers.Color.HexToNormalizedRGBA("#00FFFF", 1),
    Aqua            = Helpers.Color.HexToNormalizedRGBA("#00FFFF", 1),
    DodgerBlue      = Helpers.Color.HexToNormalizedRGBA("#1E90FF", 1),
    Magenta         = Helpers.Color.HexToNormalizedRGBA("#FF00FF", 1),
    Purple          = Helpers.Color.HexToNormalizedRGBA("#800080", 1),
    Lavender        = Helpers.Color.HexToNormalizedRGBA("#E6E6FA", 1),
    SlateBlue       = Helpers.Color.HexToNormalizedRGBA("#6A5ACD", 1),
    MediumPurple    = Helpers.Color.HexToNormalizedRGBA("#9370DB", 1),
    DarkPurple      = Helpers.Color.HexToNormalizedRGBA("#331f3f", 1),
    Yellow          = Helpers.Color.HexToNormalizedRGBA("#FFFF00", 1),
    Gold            = Helpers.Color.HexToNormalizedRGBA("#FFD700", 1),
    Sienna          = Helpers.Color.HexToNormalizedRGBA("#A0522D", 1),
    LightGreen      = Helpers.Color.HexToNormalizedRGBA("#90EE90", 1),
    MediumSeaGreen  = Helpers.Color.HexToNormalizedRGBA("#3CB371", 1),
    Olive           = Helpers.Color.HexToNormalizedRGBA("#6B8E23", 1),
    MediumAquamarine= Helpers.Color.HexToNormalizedRGBA("#66CDAA", 1),
    Aquamarine      = Helpers.Color.HexToNormalizedRGBA("#7FFFD4", 1),
    Orange          = Helpers.Color.HexToNormalizedRGBA("#FFA500", 1),
    DarkOrange      = Helpers.Color.HexToNormalizedRGBA("#FF8C00", 1),
    OrangeRed       = Helpers.Color.HexToNormalizedRGBA("#FF4500", 1),
    Coral           = Helpers.Color.HexToNormalizedRGBA("#FF7F50", 1),
    Pink            = Helpers.Color.HexToNormalizedRGBA("#FFC0CB", 1),
    LightPink       = Helpers.Color.HexToNormalizedRGBA("#FFEDFA", 1),
    HotPink         = Helpers.Color.HexToNormalizedRGBA("#FF69B4", 1),
    DeepPink        = Helpers.Color.HexToNormalizedRGBA("#FF1493", 1),
    PaleVioletRed   = Helpers.Color.HexToNormalizedRGBA("#DB7093", 1),
    Crimson         = Helpers.Color.HexToNormalizedRGBA("#DC143C", 1),
    FireBrick       = Helpers.Color.HexToNormalizedRGBA("#B22222", 1),
    DarkRed         = Helpers.Color.HexToNormalizedRGBA("#8C0000", 1),
    --Lights/Whites
    White           = Helpers.Color.HexToNormalizedRGBA("#FFFFFF", 1),
    Snow            = Helpers.Color.HexToNormalizedRGBA("#FFFAFA", 1),
    HoneyDew        = Helpers.Color.HexToNormalizedRGBA("#F0FFF0", 1),
    Mint            = Helpers.Color.HexToNormalizedRGBA("#F5FFFA", 1),
    Azure           = Helpers.Color.HexToNormalizedRGBA("#F0FFFF", 1),
    AliceBlue       = Helpers.Color.HexToNormalizedRGBA("#F0F8FF", 1),
    LightGray       = Helpers.Color.HexToNormalizedRGBA("#D3D3D3", 1),
    Silver          = Helpers.Color.HexToNormalizedRGBA("#C0C0C0", 1),
    Gray            = Helpers.Color.HexToNormalizedRGBA("#A9A9A9", 1),
    MediumGray      = Helpers.Color.HexToNormalizedRGBA("#808080", 1),
    DarkGray        = Helpers.Color.HexToNormalizedRGBA("#696969", 1),
    Black           = Helpers.Color.HexToNormalizedRGBA("#000000", 1),
}

---@class ColorText : {Text:string, Color:vec4}

--- Creates a new text group from a split text array
---@param group ExtuiTreeParent # Group ideally with an element for the new colored text to be same-lined onto, but one will also be provided if none exists
---@param charSplit ColorText[]
---@return ExtuiTreeParent
function Imgui.BuildColorText(group, charSplit)
    if #group.Children == 0 then
        group:AddText("") -- placeholder to sameline
    end

    local function newText(g, splitText, splitColor)
        local t = g:AddText(splitText)
        t:SetStyle("ItemSpacing", 0)
        t:SetColor("Text", splitColor)
        t.SameLine = true
        return t
    end

    for _, ct in ipairs(charSplit) do
        newText(group, ct.Text, ct.Color)
    end

    return group
end

--- Splits a string into ColorText array, highlighting illegal characters
--- Example usage: sanitizing filename and displaying in Imgui
-- local dumbPath = "Scribe/_Dumps/[C]Boлo.json"
-- RPrint(dumbPath)
-- local charSplit = Imgui.SanitizeStringColorTextSplit(dumbPath, Imgui.Colors.White, Imgui.Colors.Red)
-- RPrint(charSplit)
-- local testWin = Ext.IMGUI.NewWindow("TestWin")
-- local newTextGroup = Imgui.BuildColorText(testWin, charSplit)
-- testWin:AddText(dumbPath)
---@param str string
---@param normalColor vec4
---@param highlightColor vec4
---@return ColorText[]
function Imgui.SanitizeStringColorTextSplit(str, normalColor, highlightColor)
    local result = {}
    local charMap = {
        ["<"] = true, [">"] = true, [":"] = true, ['"'] = true, --["/"] = true, --subfolder is fine-ish
        ["\\"] = true, ["|"] = true, ["?"] = true, ["*"] = true
    }

    local currentColor = normalColor
    local currentText = ""

    local function addCurrentText()
        if #currentText > 0 then
            table.insert(result, { Text = currentText, Color = currentColor })
            currentText = ""
        end
    end

    local i = 1
    while i <= #str do
        -- Annoying processing for UTF8 jank
        local c = string.sub(str, i, i)
        local byte = string.byte(c, 1)
        local charLength = 1
        if byte >= 192 and byte <= 223 then
            charLength = 2
        elseif byte >= 224 and byte <= 239 then
            charLength = 3
        elseif byte >= 240 and byte <= 247 then
            charLength = 4
        end

        local char = string.sub(str, i, i + charLength - 1)
        local color = (charMap[char] or Helpers.Format.NonEnglishCharMap[char]) and highlightColor or normalColor

        if color ~= currentColor then
            addCurrentText()
            currentColor = color
        end
        currentText = currentText .. char
        i = i + charLength
    end
    addCurrentText()

    return result
end

---@class ImguiCombo
---@field Parent ExtuiCombo
Imgui.Combo = {}
---Gets the selected option
---@param combo ExtuiCombo
---@return string
function Imgui.Combo.GetSelected(combo)
    return combo.Options[combo.SelectedIndex+1]
end