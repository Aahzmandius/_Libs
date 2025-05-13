---@class FCEventCallback: MetaClass
---@field Callback function
---@field ExtraParams FCEventExtraParams
---@field HandlerID number
---@field Event FCEvent
---@field Stop boolean
FCEventCallback = _Class:Create("FCEventCallback")

function FCEventCallback:Unsubscribe()
    self.Event:Unsubscribe(self.HandlerID)
end