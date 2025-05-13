---@class ImguiHelperStatus: MetaClass
---@field FailColor vec4 floats
---@field SuccessColor vec4 floats
---@field NeutralColor vec4 floats
---@field ImguiTextHandle ExtuiText Text
---@field _Text string Current text
---@field DefaultFadeTime number A easy to reference default for default fade time
---@field FadeTime number|nil If number, countdown to visible = false, then nil
---@field CurrentlyFading boolean whether we're fading or not
---@field _FadeTimer integer|nil internal eventID of the fading tick subscription
ImguiStatus = _Class:Create("ImguiHelperStatus", nil, {
    FailColor = {1.0, 0.0, 0.0, 1.0},
    SuccessColor = {0.0, 1.0, 0.0, 1.0},
    NeutralColor = {0.7, 0.7, 0.7, 1.0},
    ImguiTextHandle = nil,
    _Text = "",
    DefaultFadeTime = 2500,
    FadeTime = nil,
    CurrentlyFading = false,
    _FadeTimer = nil
})

---Changes the text with an optional success/fail/neutral color (pos/neg/0) and optional fadeTime (ms)
---@param text string|nil
---@param colorID number|nil (-1, 0, or 1) for fail, neutral, success
---@param fadeTime number|nil (ms)
function ImguiStatus:NewStatus(text, colorID, fadeTime)
    text = text or ""
    colorID = colorID or 0
    if colorID > 0 then -- success
        self.ImguiTextHandle:SetColor("Text", self.SuccessColor)
    elseif colorID < 0 then -- fail
        self.ImguiTextHandle:SetColor("Text", self.FailColor)
    else -- neutral color
        self.ImguiTextHandle:SetColor("Text", self.NeutralColor)
    end
    self:_SetText(text)
    if fadeTime ~= nil and type(fadeTime) == "number" then
        if self.CurrentlyFading and _FadeTimer ~= nil then
            Ext.Events.Tick:Unsubscribe(_FadeTimer)
            _FadeTimer = nil
        else self.CurrentlyFading = true
        end
        _FadeTimer = Helpers.Timer:OnTime(fadeTime, function()
            self:_SetText("")
            self.CurrentlyFading = false
            _FadeTimer = nil
        end)
    elseif _FadeTimer ~= nil then
        Ext.Events.Tick:Unsubscribe(_FadeTimer)
        _FadeTimer = nil
    end
end
---Set the current text directly
---@param text string
function ImguiStatus:_SetText(text)
    self.ImguiTextHandle.Label = text
    self._Text = text
end