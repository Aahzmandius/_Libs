--- A Norb original:tm:, handles the bulk of walking through a given path and resolve to a subobject value 
--- @class ObjectPath
--- @field Root EntityHandle|string
--- @field Path any[]
ObjectPath = ObjectPath or {}

---@return ObjectPath
function ObjectPath:New(root, path)
    local pathClone = {}
    for _,key in ipairs(path or {}) do
        table.insert(pathClone, key)
    end

	local o = {
		Root = root,
        Path = pathClone,
	}
	setmetatable(o, self)
    self.__index = self
    return o
end

--- Resolves the path to the object it points to, optionally stopping recursion
--- @param stopAtRecursion boolean?
--- @return any, boolean
function ObjectPath:Resolve(stopAtRecursion)
    local obj = self.Root
    local seen = {}

    for _, name in ipairs(self.Path) do
        if stopAtRecursion and seen[obj] then
            return "**RECURSION**", true
        end

        seen[obj] = true

        -- Jank workaround for accessing elements in a set
        local vt = Ext.Types.GetValueType(obj)
        if type(obj) == "userdata" and (vt == "Set" or string.sub(vt or "", 1, 3) == "Set") then
            obj = Ext.Types.GetHashSetValueAt(obj, name)
        else
            obj = obj[name]
        end

        if obj == nil then return nil,false end
    end

    return obj,false
end

---@return boolean
function ObjectPath:IsRecursive()
    local _, isRecursive = self:Resolve(true)
    return isRecursive
end

function ObjectPath:HasProperties()
    local resolved = self:Resolve()
    if resolved then
        -- local count = table.count(resolved)
        -- SDebug("ObjectPath %s: %s properties", self.Path[#self.Path], count)
        return table.count(resolved) > 0
    else
        return false
    end
end

function ObjectPath:GetLast()
    return self.Path[#self.Path]
end

function ObjectPath:__tostring()
    local pathStr = ""
    for _, key in ipairs(self.Path) do
        if type(key) == "number" or Helpers.Format.IsValidUUID(tostring(key)) then
            pathStr = ("%s[%s]"):format(pathStr, tostring(key))
        else
            pathStr = ("%s.%s"):format(pathStr, tostring(key))
        end
    end
    pathStr = pathStr:sub(2) -- Remove the leading dot
    return "entity." .. pathStr
end

function ObjectPath:Clone()
    return ObjectPath:New(self.Root, self.Path)
end

function ObjectPath:CreateChild(child)
    local path = self:Clone()
    table.insert(path.Path, child)
    return path
end

function ObjectPath:Contains(otherPath)
    if #self.Path < #otherPath.Path then
        return false
    end

    for i = 1, #self.Path do
        if self.Path[i] ~= otherPath.Path[i] then
            return false
        end
    end

    return true
end