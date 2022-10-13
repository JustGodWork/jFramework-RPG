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

---@type Entity
Entity = Class.new(function(class)

    ---@class Entity: BaseObject
    local self = class;
    
    ---@param entity Actor
    ---@return void
    function self:IsEntityValid(entity)
        return entity ~= nil and entity:IsValid();
    end

    ---@param entity Actor
    ---@param type Any
    ---@return string | nil
    function self:IsOfType(entity, type)
        if (entity and entity:IsValid()) then
            return NanosUtils.IsA(entity, type);
        end
        return nil;
    end

    ---@param entity Actor
    ---@return Player | nil
    function self:IsPlayerAndOfType(entity, type)
        if (self:isOfType(entity, type)) then 
            local player = self:IsPlayer(entity);
            if (player) then
                return player;
            end
        end
        return nil;
    end

    ---@param entity Actor
    ---@return Player | nil
    function self:IsPlayer(entity)
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
    function self:IsVehicle(entity)
        if (entity and entity:IsValid()) then
            return NanosUtils.IsA(entity, Vehicle);
        end
        return false;
    end

    ---@param entity Actor
    ---@return boolean
    function self:IsCharacter(entity)
        if (entity and entity:IsValid()) then
            return NanosUtils.IsA(entity, Character);
        end
        return false;
    end

    ---@param entity Actor
    ---@return boolean
    function self:IsWeapon(entity)
        if (entity and entity:IsValid()) then
            return NanosUtils.IsA(entity, Weapon);
        end
        return false;
    end

    return self;
end);