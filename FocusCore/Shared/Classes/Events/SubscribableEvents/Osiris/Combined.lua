---@class FCCombinedParams:FCEventParams
---@field Item1 EntityHandle|nil
---@field Item1Guid Guid|nil
---@field Item1Template GameObjectTemplate|nil
---@field Item1Stats string|nil
---@field Item2 EntityHandle|nil
---@field Item2Guid Guid|nil
---@field Item2Template GameObjectTemplate|nil
---@field Item2Stats string|nil
---@field Item3 EntityHandle|nil
---@field Item3Guid Guid|nil
---@field Item3Template GameObjectTemplate|nil
---@field Item3Stats string|nil
---@field Item4 EntityHandle|nil
---@field Item4Guid Guid|nil
---@field Item4Template GameObjectTemplate|nil
---@field Item4Stats string|nil
---@field Item5 EntityHandle|nil
---@field Item5Guid Guid|nil
---@field Item5Template GameObjectTemplate|nil
---@field Item5Stats string|nil
---@field CharacterGuid Guid
---@field Character EntityHandle
---@field NewItemGuid Guid
---@field NewItem EntityHandle|nil
---@field NewItemTemplate GameObjectTemplate|nil
---@field NewItemStats string|nil
FCParams.Combined = FCEventParamsBase:New()

---@param ... string
---@return boolean
function FCParams.Combined:HasStatId(...)
    for _, stat in ipairs({...}) do
        for i = 1, 5 do
            if self["Item"..i.."Stats"] == stat then
                return true
            end
        end
    end
    return false
end

---@param ... Guid|string
---@return boolean
function FCParams.Combined:HasTemplate(...)
    for _, template in ipairs({...}) do
        for i = 1, 5 do
            if self["Item"..i.."Template"] == template then
                return true
            end
            local rootTemplate = Ext.Template.GetRootTemplate(template)
            if rootTemplate ~= nil and rootTemplate.Name == template then
                return true
            end
        end
    end
    return false
end

---@param ... string
---@return boolean
function FCParams.Combined:HasGuid(...)
    for _, guid in ipairs({...}) do
        for i = 1, 5 do
            if self["Item"..i.."Guid"] == guid then
                return true
            end
        end
    end
    return false
end

---@param ... string
---@return boolean
function FCParams.Combined:HasEntity(...)
    for _, entity in ipairs({...}) do
        for i = 1, 5 do
            if self["Item"..i] == entity then
                return true
            end
        end
    end
    return false
end

---@class FCEventCombined: FCOsirisEventBase
---@field Subscribe fun(self:FCEventCombined, callback:fun(e:FCCombinedParams))
Events.Osiris.Combined = FCOsirisEventBase:CreateEvent("FCEventCombined", {OsirisEvent = "Combined", OsirisArity = 7})

---@param item1 Guid
---@param item2 Guid
---@param item3 Guid
---@param item4 Guid
---@param item5 Guid
---@param character Guid
---@param newItem Guid
---@return FCCombinedParams
function Events.Osiris.Combined:CreateParams(item1, item2, item3, item4, item5, character, newItem)
    local params = FCParams.Combined:New()

    for i, item in ipairs{item1, item2, item3, item4, item5} do
        if item ~= "NULL_00000000-0000-0000-0000-000000000000" then
            local itemNum = "Item"..i
            params[itemNum.."Guid"] = Helpers.Format:Guid(item)
            local itemObj = Ext.Entity.Get(item)
            if itemObj ~= nil then
                params[itemNum] = itemObj
                params[itemNum.."Template"] = itemObj.ServerItem.Template.Id
                params[itemNum.."Stats"] = itemObj.Data ~= nil and itemObj.Data.StatsId or nil
            end
        end
    end

    params.CharacterGuid = Helpers.Format:Guid(character)
    params.Character = Ext.Entity.Get(character)

    if newItem ~= "NULL_00000000-0000-0000-0000-000000000000" then
        params.NewItemGuid = Helpers.Format:Guid(newItem)
        local itemObj = Ext.Entity.Get(newItem)
        if itemObj ~= nil then
            params.NewItem = itemObj
            params.NewItemTemplate = itemObj.ServerItem.Template.Id
            params.NewItemStats = itemObj.Data ~= nil and itemObj.Data.StatsId or nil
        end
    end

    return params
end