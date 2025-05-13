---@class HelperCharacter: Helper
Helpers.Character = Helpers.Character or _Class:Create("HelperCharacter", Helper)

---Full restores an entity that has a Health component
---@param entity EntityHandle|string Entity or entity guid
function Helpers.Character:FullRestoreEntity(entity)
    if type(entity) == "string" then
        entity = Ext.Entity.Get(entity)
    end
    if entity == nil then return SWarn("Not a valid entity, can't full restore.") end
    if entity.Health ~= nil then
        --SWarn("Entity Health vs Max: %d vs %d", entity.Health.Hp, entity.Health.MaxHp)
        entity.Health.Hp = entity.Health.MaxHp
        entity:Replicate("Health")
    else
        SWarn("Entity doesn't have health? %s", entity.Uuid.EntityUuid)
    end
    --Osi.RemoveHarmfulStatuses(entity.Uuid.EntityUuid) -- avoid? can't remember why
    local eu = entity.Uuid.EntityUuid
    Osi.RemoveStatusesWithGroup(eu, "SG_Charmed")
    Osi.RemoveStatusesWithGroup(eu, "SG_Petrified")
    Osi.RemoveStatusesWithGroup(eu, "SG_Cursed")
    Osi.RemoveStatusesWithGroup(eu, "SG_Stunned")
    self:RestoreResources(entity)
    Osi.ResetCooldowns(eu)
end
---Does the equivalent of a short rest for an entity with a Health component
---@param entity EntityHandle|string Entity or entity guid
function Helpers.Character:ShortRestEntity(entity)
    if type(entity) == "string" then
        entity = Ext.Entity.Get(entity)
    end
    if entity == nil then return SWarn("Not a valid entity, can't short rest.") end
    if entity ~= nil and entity.Health ~= nil then
        local currentHp = entity.Health.Hp
        entity.Health.Hp = math.min(entity.Health.MaxHp, currentHp + (entity.Health.MaxHp // 2))
        entity:Replicate("Health")
    end
    self:RestoreResources(entity, Ext.Enums.ResourceReplenishType.ShortRest[1])
end
---Restores an entity's ActionResources to the given max amount
---@param entity EntityHandle|string Entity or entity guid
---@param type ResourceReplenishType|nil Restores only the specific resource type if given
function Helpers.Character:RestoreResources(entity, resttype)
    if type(entity) == "string" then
        entity = Ext.Entity.Get(entity)
    end
    if entity == nil then return SWarn("Not a valid entity, can't restore resources.") end
    if entity.ActionResources ~= nil then
        for i, v in pairs(entity.ActionResources.Resources) do
            for j,w in pairs(v) do
                -- each subresource
                if resttype ~= nil then
                    local staticdata = Ext.StaticData.Get(w.ResourceUUID, "ActionResource")
                    if staticdata.ReplenishType[1] == resttype then
                        w.Amount = w.MaxAmount
                    end
                else
                    w.Amount = w.MaxAmount
                end
            end
        end
        if entity.SpellBookCooldowns ~= nil then
            entity.SpellBookCooldowns.Cooldowns = {}
            entity:Replicate("SpellBookCooldowns")
        end
        entity:Replicate("ActionResources")
    end
end
function Helpers.Character:TeleportToCamp(entity)
    if not Ext.IsServer() then return SWarn("Can only call TeleportToCamp on server.") end
    if type(entity) ~= "string" then
        entity = Helpers.Object:GetGuid(entity)
    end
    if entity == nil then return SWarn("Could not teleport given entity to camp.") end

    local db = Osi.DB_ActiveCamp:Get(nil)
    if db == nil or db[1] == nil then
        return SWarn("No active camp to teleport to.")
    end
    local activecamp = Osi.DB_ActiveCamp:Get(nil)[1][1]
    if activecamp ~= nil then
        local camptrigger = Osi.DB_Camp:Get(activecamp, nil, nil, nil)[1][3]
        Osi.PROC_Camp_TeleportToCamp(entity, camptrigger)
    end
end

-- Database 'DB_Origins' (CHARACTER):
-- 	(S_Player_Karlach_2c76687d-93a2-477b-8b18-8a14b549304c)
-- 	(S_Player_Minsc_0de603c5-42e2-4811-9dad-f652de080eba)
-- 	(S_GOB_DrowCommander_25721313-0c15-4935-8176-9f134385451b)
-- 	(S_GLO_Halsin_7628bc0e-52b8-42a7-856a-13a6fd413323)
-- 	(S_Player_Jaheira_91b6b200-7d00-4d62-8dc9-99e8339dfa1a)
-- 	(S_Player_Gale_ad9af97d-75da-406a-ae13-7071c563f604)
-- 	(S_Player_Astarion_c7c13742-bacd-460a-8f65-f864fe41f255)
-- 	(S_Player_Laezel_58a69333-40bf-8358-1d17-fff240d7fb12)
-- 	(S_Player_Wyll_c774d764-4a17-48dc-b470-32ace9ce447d)
-- 	(S_Player_ShadowHeart_3ed74f06-3c60-42dc-83f6-f034cb47c679)

function Helpers.Character:IsPartyMember(entity)
    if type(entity) == "string" then
        entity = Ext.Entity.Get(entity)
    end
    if entity == nil then return false end
    return entity.PartyMember ~= nil and true or false
end
function Helpers.Character:IsNonGenericOrigin(entity)
    if type(entity) == "string" then
        entity = Ext.Entity.Get(entity)
    end
    if entity == nil or entity.Origin == nil then return false end
    return entity.Origin.Origin ~= "Generic" and true or false
end
function Helpers.Character:IsRecruitedOrigin(entity)
    if type(entity) == "string" then
        entity = Ext.Entity.Get(entity)
    end
    if entity == nil or entity.Uuid == nil then return false end
    -- is it even an origin?
    local found = false
    for i,v in pairs(Data.Origins) do
        if v.Uuid == entity.Uuid.EntityUuid then
            found = true
        end
    end
    if not found then return false end
    -- valid origin, is it recruited?
    return entity.CCState ~= nil and true or false
end
function Helpers.Character:IsInCamp(entity)
    if type(entity) == "string" then
        entity = Ext.Entity.Get(entity)
    end
    if entity == nil then return false end
    return entity.CampPresence ~= nil and true or false
end
function Helpers.Character:IsDead(entity)
    if type(entity) == "string" then
        entity = Ext.Entity.Get(entity)
    end
    if entity == nil then return false end
    return entity.Death ~= nil and true or false
end
function Helpers.Character:IsAvatar(entity)
    if type(entity) == "string" then
        entity = Ext.Entity.Get(entity)
    end
    if entity == nil then return false end
    return entity.Avatar ~= nil and true or false
end
function Helpers.Character:IsUnusedAvatar(entity)
    if type(entity) == "string" then
        entity = Ext.Entity.Get(entity)
    end
    if entity == nil or entity.UserAvatar == nil then return false end
    return entity.UserAvatar.OwnerProfileID == "" and true or false
end
function Helpers.Character:IsControlledCharacter(entity)
    return self:IsLocalControlledCharacter(entity) -- FIXME bleh, correct naming later when updating EC
end

--- Checks if the character is the current locally controlled character
---@param entity EntityHandle
---@return boolean
function Helpers.Character:IsLocalControlledCharacter(entity)
    if type(entity) == "string" then
        entity = Ext.Entity.Get(entity)
    end
    if entity ~= nil and entity.ClientControl ~= nil then
        if entity.UserReservedFor == nil then
            SWarn("Checking client control on entity that has control, but no UserReservedFor component yet.")
            return false
        end
        return entity.UserReservedFor ~= nil and entity.UserReservedFor.UserID == 1
    end
end
---Checks if given entity is a Paperdoll, and if so, returns true and the owner entity
---@param entity string|EntityHandle
---@return boolean
---@return nil|EntityHandle
function Helpers.Character:IsPaperdoll(entity)
    if Ext.IsServer() then SWarn("Cannot check client paperdoll from server") return false end
    
    if type(entity) == "string" then
        entity = Ext.Entity.Get(entity)
    end
    if entity ~= nil and entity.ClientPaperdoll ~= nil then
        return true, entity.ClientPaperdoll.Entity
    else
        return false
    end
end

---Same as GetHostEntity, returns locally controlled character or nil if none found
---@return EntityHandle|nil
function Helpers.Character:GetLocalControlledEntity()
    if Ext.IsServer() then
        return Ext.Entity.Get(Osi.GetHostCharacter())
    else
        for _, entity in pairs(Ext.Entity.GetAllEntitiesWithComponent("ClientControl")) do
            if entity.UserReservedFor.UserID == 1 then
                return entity
            end
        end
    end
end

---Gets a table of entity uuid's for current party
---@return table<string>|nil
function Helpers.Character:GetCurrentParty()
    local party = Ext.Entity.GetAllEntitiesWithComponent("PartyMember")
    local partyMembers = {}
    for _,v in pairs(party) do
        local g = Ext.Entity.HandleToUuid(v)
        if g ~= nil then
            table.insert(partyMembers, g)
        else
            --SWarn("Can't get UUID for party member: %s", v)
        end
    end
    return partyMembers
end

function Helpers.Character:IsAnyPartyMemberInCamp()
    local party = Ext.Entity.GetAllEntitiesWithComponent("PartyMember")
    for _, partyMember in pairs(party) do
        if partyMember.CampPresence then
            return true
        end
    end
    return false
end