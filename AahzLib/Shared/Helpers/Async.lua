---@class HelperAsync: Helper
Helpers.Async = Helpers.Async or _Class:Create("Async", Helper, {})

---Debounces a given function
---@param delay number ms delay
---@param func fun(...)
---@return fun(...)
function Helpers.Async:Debounce(delay, func)
    local sec = delay / 1000
    local handlerId

    return function(...)
        if handlerId then
            Ext.Events.Tick:Unsubscribe(handlerId)
            handlerId = nil
        end

        local args = { ... }
        local last = 0
        handlerId = Ext.Events.Tick:Subscribe(function(e)
            last = last + e.Time.DeltaTime
            if last < sec then
                return
            end

            Ext.Events.Tick:Unsubscribe(handlerId)
            handlerId = nil

            func(table.unpack(args))
        end)
    end
end