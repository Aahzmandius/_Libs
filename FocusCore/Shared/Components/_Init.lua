---@class FCComponent: MetaClass
FCComponent = _Class:Create("FCComponent")
FCComponent.IsServer = Ext.IsServer()
FCComponent.IsClient = Ext.IsClient()

Components = {}
RequireFiles(LibPathRoots.FocusCore.."Shared/Components/", {
    "Health",
    "SpellCastState",
})