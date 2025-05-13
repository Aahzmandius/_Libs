-- Initialization order
-- 1. _Libs/ReactiveX
-- 2. _Libs/FocusCore
-- 3. _Libs/AahzLib

LibPathRoots = {
    ReactiveX   = "_Libs/ReactiveX/reactivex/", -- Loads directly into RX
    FocusCore   = "_Libs/FocusCore/", -- Metaclass available and main Helpers
    AahzLib     = "_Libs/AahzLib/",
}

---Ext.Require files at the path
---@param path string
---@param files string[]
function RequireFiles(path, files)
    for _, file in pairs(files) do
        Ext.Require(string.format("%s%s.lua", path, file))
    end
end

---@module "_Libs.ReactiveX.reactivex._init"
RX = RX or Ext.Require("_Libs/ReactiveX/reactivex/_init.lua")

Ext.Require("_Libs/FocusCore/_Init.lua")
Ext.Require("_Libs/AahzLib/_Init.lua")