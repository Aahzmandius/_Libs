-- extensions of basic things, lua stdlib smh

---Quick split
---@param self string
---@param delimiter string
---@return table<string>
function string:split(delimiter)
    local result = {}
    local from  = 1
    local delim_from, delim_to = string.find(self, delimiter, from)
    while delim_from do
        table.insert( result, string.sub(self, from , delim_from-1))
        from  = delim_to + 1
        delim_from, delim_to = string.find(self, delimiter, from)
    end
    table.insert( result, string.sub(self, from))
    return result
end

--- Trims leading and trailing whitespace
---@return string
function string:trim()
    --jankawhat?
    local trimmed = tostring(self):gsub("^%s*(.-)%s*$", "%1")
    return trimmed
end

---@param tbl table
---@param element any
---@return boolean
function table.contains(tbl, element)
    if type(tbl) ~= "table" then
        return false
    end

    if tbl == nil or element == nil then
        return false
    end

    for _, value in pairs(tbl) do
        if value == element then
            return true
        end
    end
    return false
end

---@param tbl table
---@param element any
---@return integer|nil index
function table.indexOf(tbl, element)
    for index, value in ipairs(tbl) do
        if value == element then
            return index
        end
    end
    return nil
end

---Checks if table is empty (using next())
---@param tbl table
---@return boolean
function table.isEmpty(tbl)
    if not tbl then return true end
    return next(tbl) == nil
end

---Returns count of associative table's kv pairs
---@param tbl table
---@return integer
function table.count(tbl)
    if not tbl then return 0 end
    local count = 0
    for _ in pairs(tbl) do count = count + 1 end
    return count
end

---Shallow copy of table, optionally copies metatable
---@param t table
---@param copyMetatable boolean?
---@return table
function table.shallowCopy(t, copyMetatable)
    local tbl = {}
    for k, v in pairs(t) do
        tbl[k] = v
    end
    if copyMetatable then
        setmetatable(tbl, getmetatable(t))
    end
    return tbl
end

---Deep copy, recursive and updates new metatable to original metatable
---@param t table
---@return table
function table.deepCopy(t)
    if type(t) ~= "table" then return t end

    local mt = getmetatable(t)
    local tbl = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            v = table.deepCopy(v)
        end
        tbl[k] = v
    end

    setmetatable(tbl, mt)
    return tbl
end

---Associative table pairs iterator, returns values sorted based on keys; optional boolean to specify descending order
---Eg. for key, v in table.pairsByKeys(someTable) do
---@param t table
---@param f boolean|function|nil optional descendingOrder boolean OR sorting function
---@return function iterator 
function table.pairsByKeys(t, f)
    local a = {}
    for n in pairs(t) do table.insert(a, n) end
    if type(f) == "boolean" then
        if f then
            table.sort(a, function(b,c) return b > c end)
        else
            table.sort(a)
        end
    else
        table.sort(a, f)
    end
    local i = 0      -- iterator variable
    local iter = function ()   -- iterator function
        i = i + 1
        if a[i] == nil then return nil
        else return a[i], t[a[i]]
        end
    end
    return iter
end