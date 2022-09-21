--[[
--Created Date: Tuesday September 20th 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Tuesday September 20th 2022 11:24:02 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

---@class InventoryManager
local InventoryManager = {}

---@return InventoryManager
function InventoryManager:new()
    ---@type InventoryManager
    local self = {}
    setmetatable(self, { __index = InventoryManager});

    ---@type Inventory[]
    self.inventories = {};
    ---@type Inventory[][]
    self.owned = {};

    if (Config.debug) then
        Package.Log("Server: [ InventoryManager ] initialized.");
    end

    return self;
end

---@param id string
---@param name string
---@param label string
---@param owner string
---@param items Item[]
---@param maxWeight number
---@param inventoryType number
---@return Inventory | nil
function InventoryManager:register(id, name, label, owner, items, maxWeight, inventoryType)
    if (owner) then
        if (not self.owned[owner]) then
            self.owned[owner] = {};
        end
        if (not self.owned[owner][id]) then
            self.owned[owner][id] = Inventory:new(id, name, label, owner, items, maxWeight, inventoryType);
            return self.owned[owner][id];
        else
            Package.Warn("InventoryManager:register(): inventory [ ".. name .." ] already exists");
            return nil;
        end
    elseif (not self.inventories[id]) then
        self.inventories[id] = Inventory:new(id, name, label, owner, items, maxWeight, inventoryType);
        return self.inventories[id];
    else
        Package.Warn("InventoryManager:register(): inventory [ ".. name .." ] already exists");
        return nil;
    end
end

---@param owner string
---@param inventoryName string
---@return Inventory | nil
function InventoryManager:getByOwner(owner, inventoryName)
    local found = false;
    if (self.owned[owner]) then
        for inventory, _ in pairs(self.owned[owner]) do
            local inv = self.owned[owner][inventory];
            if (inv) then
                if (inv.owner == owner and inv.name == inventoryName) then
                    found = true;
                    return inv;
                end
            end
        end
    else
        Package.Warn('InventoryManager:getByOwner(): owner [ '.. owner ..' ] not found');
        return nil;
    end
    if (not found) then
        Package.Warn('InventoryManager:getByOwner(): inventory [ Owner: "'.. owner.. '" name: "'.. inventoryName ..'" ] not found');
        return nil;
    end
end

---@param inventory Inventory
---@param owner string
---@return void
function InventoryManager:setOwner(inventory, owner)
    if (inventory) then
        if (self.inventories[inventory:getId()]) then
            self.inventories[inventory:getId()].owner = owner;
        else
            Package.Warn('InventoryManager:setOwner(): inventory [ '.. inventory ..' ] not found');
        end
    end
end

---@param id string id or name of Inventory
---@return Inventory
function InventoryManager:get(id)
    for inventory, _ in pairs(self.inventories) do
        local inv = self.inventories[inventory]
        if (inv:getId() == id or inv:getName() == id) then
            return inv;
        end
    end
end

jServer.inventoryManager = InventoryManager:new();