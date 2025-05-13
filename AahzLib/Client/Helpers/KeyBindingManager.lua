---@class Keybinding
---@field ScanCode string
---@field Modifiers table<integer,string>|nil
---@field Callback function
---@field Identifier Guid|nil #do not change manually

---@class ALKeybindingManager:MetaClass
---@field Keybindings table<SDLScanCode, table<Guid, Keybinding>>
KeybindingManager = _Class:Create("ALKeybindingManager", nil,{
    Keybindings = {}
})

---@param e EclLuaKeyInputEvent
function KeybindingManager.HandleInput(e)
    if e.Event == "KeyDown" and e.Repeat == false then
        KeybindingManager:CheckBindings(e)
    end
end

---@param keybind Keybinding
---@return Keybinding,Guid #binding id
function KeybindingManager:Bind(keybind)
    local exists = self.Keybindings[keybind.ScanCode]
    if not exists then
        self.Keybindings[keybind.ScanCode] = {}
    end
    local id = Helpers.Format.CreateUUID()
    keybind.Identifier = id
    self.Keybindings[keybind.ScanCode][id] = keybind
    return keybind,id
end

---@param keybind Keybinding
---@return boolean #successfully unbound
function KeybindingManager:Unbind(keybind)
    if keybind == nil then return false end
    local exists = self.Keybindings[keybind.ScanCode]
    if exists then
        if self.Keybindings[keybind.ScanCode][keybind.Identifier] ~= nil then
            self.Keybindings[keybind.ScanCode][keybind.Identifier] = nil
            return true
        else
            return false
        end
    else
        return false
    end
end

---@param e EclLuaKeyInputEvent
function KeybindingManager:CheckBindings(e)
    local bindings = self.Keybindings[e.Key]
    if bindings ~= nil then
        -- We have bindings for this key
        for _, bind in pairs(bindings) do
            local skip = false
            -- Check modifiers if given
            if bind.Modifiers then
                for _,m in ipairs(bind.Modifiers) do
                    if m == "NONE" then
                        -- Make sure modifiers aren't held
                        if e.Modifiers ~= nil and e.Modifiers[1] ~= nil then
                            skip = true
                            break
                        end
                    elseif m == "Alt" then
                        local lalt,ralt = Ext.Enums.SDLKeyModifier.LAlt,Ext.Enums.SDLKeyModifier.RAlt
                        if not (e.Modifiers & lalt == lalt or e.Modifiers & ralt == ralt) then
                            skip = true
                            break
                        end
                    elseif m == "Shift" then
                        local lshift,rshift = Ext.Enums.SDLKeyModifier.LShift,Ext.Enums.SDLKeyModifier.RShift
                        if not (e.Modifiers & lshift == lshift or e.Modifiers & rshift == rshift) then
                            skip = true
                            break
                        end
                    elseif m == "Ctrl" then
                        local lctrl,rctrl = Ext.Enums.SDLKeyModifier.LCtrl,Ext.Enums.SDLKeyModifier.RCtrl
                        if not (e.Modifiers & lctrl == lctrl or e.Modifiers & rctrl == rctrl) then
                            skip = true
                            break
                        end
                    elseif m == "Scroll" then
                        if not e.Modifiers & Ext.Enums.SDLKeyModifier.Scroll == Ext.Enums.SDLKeyModifier.Scroll then
                            skip = true
                            break
                        end
                    elseif m == "Num" then
                        if not e.Modifiers & Ext.Enums.SDLKeyModifier.Num == Ext.Enums.SDLKeyModifier.Num then
                            skip = true
                            break
                        end
                    elseif m == "Caps" then
                        if not e.Modifiers & Ext.Enums.SDLKeyModifier.Caps == Ext.Enums.SDLKeyModifier.Caps then
                            skip = true
                            break
                        end
                    end
                end
            end
            if not skip and bind.Callback then
                bind.Callback(bind.Identifier)
            end
        end
    end
end

Ext.Events.KeyInput:Subscribe(KeybindingManager.HandleInput)

---TODO not fully tested, left off here
---@param group ExtuiGroup
---@param settingName string # key used for persistence through LocalSettings
---@param defaultKey SDLScanCode?
---@param defaultModifiers table<integer,SDLKeyModifier>?
---@param callback function # Called when the hotkey is used
---@param onChangeCallback function?
---@return Keybinding
function KeybindingManager:CreateAndDisplayKeybind(group, settingName, defaultKey, defaultModifiers, callback, onChangeCallback)
    -- ECDebug("CreateAndDisplayKeybind: %s, %s, callback? %s", defaultKey, defaultModifier ~= nil and type(defaultModifier) == "table" and defaultModifier[1] or nil, callback ~= nil)
    -- Check if keybind already exists in LocalSettings
    local newKeybind
    local existingKeybind = LocalSettings:Get(settingName) --[[@as Keybinding]]
    if existingKeybind ~= nil then
        defaultKey = existingKeybind.ScanCode
        defaultModifiers = existingKeybind.Modifiers
        newKeybind = existingKeybind
        KeybindingManager:Unbind(newKeybind) -- unbind if exists
        newKeybind.Callback = callback
    else
        ---@type Keybinding
        newKeybind = {
            ScanCode = defaultKey or SDLScanCodes.NONE,
            Modifiers = defaultModifiers,
            Callback = callback,
        }
    end
    KeybindingManager:Bind(newKeybind) -- bind

    local keybindTable = group:AddTable(group.IDContext..settingName.."Table", 2)
    keybindTable.SizingFixedFit = true
    local keybindRow = keybindTable:AddRow()
    local c1 = keybindRow:AddCell()
    c1:AddText(Ext.Loca.GetTranslatedString("hb44f8d592289494d84bf051cfd4dba6ccd5g", "Key:")) -- TODO localization
    local scancodeDropdown = c1:AddCombo("")
    scancodeDropdown.IDContext = keybindTable.IDContext.."Key"
    scancodeDropdown.Options = SDLScanCodes
    local defaultKeyIndex = table.indexOf(SDLScanCodes, defaultKey) and table.indexOf(SDLScanCodes, defaultKey) - 1 or 0
    scancodeDropdown.SelectedIndex = defaultKeyIndex
    scancodeDropdown.ItemWidth = 100
    scancodeDropdown.SameLine = true
    -- scancodeDropdown.WidthFitPreview = true
    
    local c2 = keybindRow:AddCell()
    c2:AddText(Ext.Loca.GetTranslatedString("h422e7873e97147f48d340151168d1e20e111", "Modifier:")).SameLine = true
    local modifierDropdown = c2:AddCombo("")
    modifierDropdown.IDContext = keybindTable.IDContext.."Modifier"
    modifierDropdown.Options = SDLModifiers
    local firstModifier = defaultModifiers ~= nil and defaultModifiers[1] ~= nil and table.contains(SDLModifiers, defaultModifiers[1]) and defaultModifiers[1] or "NONE"
    local defaultModifierIndex = table.indexOf(SDLModifiers, firstModifier) and table.indexOf(SDLModifiers, firstModifier) - 1 or 0
    modifierDropdown.SelectedIndex = defaultModifierIndex
    modifierDropdown.ItemWidth = 100
    modifierDropdown.SameLine = true
    -- modifierDropdown.WidthFitPreview = true
    modifierDropdown.UserData = {
        MainKeyDropdown = scancodeDropdown,
    }
    scancodeDropdown.UserData = {
        ModifierDropdown = modifierDropdown,
        LocalSettingName = settingName,
        OnChangeCallback = onChangeCallback,
        RefreshKeybind = function(c)
            local md = c.UserData.ModifierDropdown
            if md ~= nil then
                local modifier = Imgui.Combo.GetSelected(md)
                local scancode = Imgui.Combo.GetSelected(c)
                ---@type Keybinding
                local newBind = {
                    ScanCode = scancode,
                    Modifiers = { modifier },
                    Callback = callback,
                }
                KeybindingManager:Unbind(newKeybind)
                newKeybind = KeybindingManager:Bind(newBind)
                LocalSettings:AddOrChange(c.UserData.LocalSettingName, newKeybind)
                if c.UserData.OnChangeCallback ~= nil then
                    c.UserData.OnChangeCallback()
                end
            end
            
        end,
    }
    modifierDropdown.OnChange = function(c)
        if c.UserData and c.UserData.MainKeyDropdown then
            local mainDrop = c.UserData.MainKeyDropdown
            if mainDrop.UserData and mainDrop.UserData.RefreshKeybind then
                mainDrop.UserData.RefreshKeybind(mainDrop)
            end
        end
    end
    scancodeDropdown.OnChange = function(c)
        if c.UserData and c.UserData.RefreshKeybind then
            c.UserData.RefreshKeybind(c)
        end
    end

    -- save to LocalSettings
    LocalSettings:AddOrChange(settingName, newKeybind)
    return newKeybind
end

-- KeybindingManager:Bind({
--     ScanCode = "F",
--     Callback = function() ECDebug("rip?") end,
-- })
-- KeybindingManager:Bind({
--     ScanCode = "F",
--     Callback = function() ECDebug("multiple") end,
-- })
-- KeybindingManager:Bind({
--     ScanCode = "F",
--     Callback = function(i) ECDebug("buttery %s", i) end,
-- })