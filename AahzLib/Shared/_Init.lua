
function ModVersion(moduuid)
    return string.format("%s v%s", Ext.Mod.GetMod(moduuid).Info.Name, table.concat(Ext.Mod.GetMod(moduuid).Info.ModVersion, "."))
end

RequireFiles(LibPathRoots.AahzLib.."Shared/", {
    -- "MetaClass", -- required from FocusCore
    "_StaticDefines",
    "Extensions",
    "Printer",
    "LocalSettings",
    "Data/_Init",
    "Helpers/_Init",
    "Classes/_Init"
})

-- ALPrinter:SetFontColor(70, 120, 0)
--ALPrinter:PrintAahzLib(ModVersion(ModuleUUID))