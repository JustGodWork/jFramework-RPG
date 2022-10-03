--[[
----
----Created Date: 11:35 Friday September 30th 2022
----Author: JustGod
----Made with ❤
----
----File: [Entity]
----
----Copyright (c) 2022 JustGodWork, All Rights Reserved.
----This file is part of JustGodWork project.
----Unauthorized using, copying, modifying and/or distributing of this file
----via any medium is strictly prohibited. This code is confidential.
----
--]]

---@class Entity
local Entity = {};

---@return Entity
function Entity:new()
    ---@type Entity
    local self = {};
    setmetatable(self, { __index = Entity });

    return self
end

---@param entity Actor
---@return void
function Entity:isEntityValid(entity)
    return entity ~= nil and entity:IsValid();
end

---@param entity Actor
---@param type Any
---@return string | nil
function Entity:isOfType(entity, type)
    if (entity and entity:IsValid()) then
        return NanosUtils.IsA(entity, type);
    end
    return nil;
end

---@param entity Actor
---@return Player | nil
function Entity:isPlayerAndOfType(entity, type)
    if (self:isOfType(entity, type)) then 
        local player = self:isPlayer(entity);
        if (player) then
            return player;
        end
    end
    return nil;
end

---@param entity Actor
---@return Player | nil
function Entity:isPlayer(entity)
    if (entity and entity:IsValid()) then
        local player = entity:GetPlayer();
        if (player) then
            return player;
        end
    end
    return nil;
end

---@param entity Actor
---@return boolean
function Entity:isVehicle(entity)
    if (entity and entity:IsValid()) then
        return NanosUtils.IsA(entity, Vehicle);
    end
    return false;
end

---@param entity Actor
---@return boolean
function Entity:isCharacter(entity)
    if (entity and entity:IsValid()) then
        return NanosUtils.IsA(entity, Character);
    end
    return false;
end

---@param entity Actor
---@return boolean
function Entity:isWeapon(entity)
    if (entity and entity:IsValid()) then
        return NanosUtils.IsA(entity, Weapon);
    end
    return false;
end

jServer.utils.entity = Entity:new();