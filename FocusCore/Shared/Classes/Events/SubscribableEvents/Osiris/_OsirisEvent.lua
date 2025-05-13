---@class FCOsirisEventBase:FCEvent
---@field private OsirisEvent string
---@field private OsirisArity integer
FCOsirisEventBase = FCEvent:Create("FCOsirisEventBase")

---@private
---@generic T
---@param class `T`
---@param OsirisInfo {OsirisEvent:string, OsirisArity:integer}
---@return T
function FCOsirisEventBase:CreateEvent(class, OsirisInfo)
    return FCEvent.Create(self, class, OsirisInfo)
end

---@vararg string|integer
---@return FCEventParams
function FCOsirisEventBase:CreateParams(...)
    FCDebug("Empty Param creation function for %s", _Class:GetClassName(self))
end

---@private
function FCOsirisEventBase:RegisterEvent()
    if Ext.IsServer() then
        Ext.Osiris.RegisterListener(self.OsirisEvent, self.OsirisArity, "before", function(...)
            if self:HasCallback() then
                self:Throw(self:CreateParams(...))
            end
        end)
    end
end