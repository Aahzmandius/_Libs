-- Expects location <ModName>/Mods/<ModName>/ScriptExtender/Lua/_Libs/AahzLib/_Init.lua
assert(LibPathRoots and LibPathRoots.AahzLib == "_Libs/AahzLib", "AahzLib path is not set correctly. Please check the LibPathRoots table in _InitLibs.lua.")

if Ext.IsServer() then
    -- Server
    RequireFiles(LibPathRoots.AahzLib, {
        "Shared/_Init",
        "Server/_Init",
    })
else
    -- Client
    RequireFiles(LibPathRoots.AahzLib, {
        "Shared/_Init",
        "Client/_Init",
    })
end