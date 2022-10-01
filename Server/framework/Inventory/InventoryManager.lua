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

    jServer.mysql:query([[
        CREATE TABLE IF NOT EXISTS inventories (
            id INT(11) NOT NULL AUTO_INCREMENT,
            name VARCHAR(255) NOT NULL,
            label VARCHAR(255) NOT NULL,
            owner VARCHAR(255) NOT NULL,
            shared INT(11) NOT NULL,
            maxWeight FLOAT NOT NULL,
            slots INT(11) NOT NULL,
            PRIMARY KEY (id)
        ) ENGINE=InnoDB DEFAULT CHARSET=latin1
    ]])

    jServer.mysql:query([[
        CREATE TABLE IF NOT EXISTS inventories_items (
            id INT(11) NOT NULL AUTO_INCREMENT,
            inventoryId INT(11) NOT NULL,
            name VARCHAR(255) NOT NULL,
            durability FLOAT NULL,
            description LONGTEXT NULL,
            level FLOAT NULL,
            amount INT(11) NOT NULL DEFAULT 0,
            slot INT(11) NOT NULL,
            PRIMARY KEY (id)
        ) ENGINE=InnoDB DEFAULT CHARSET=latin1
    ]])

    jShared.log:debug("[ InventoryManager ] initialized.");

    return self;
end

---@param name string
---@param owner string
function InventoryManager:register(name, owner)
    local query = "SELECT * FROM inventories WHERE name = ?";
    if (owner) then
        query = query .. " AND owner = ?"
    end
    jServer.mysql:select(query, { name, owner }, function(result)
        if (result[1]) then
            if (owner) then
                if (not self.owned[result[1].owner]) then
                    self.owned[result[1].owner] = {};
                end
                if (not self.owned[owner][result[1].id]) then
                    self:buildInventory(result[1].id, result[1].name, result[1].label, result[1].owner, result[1].maxWeight, result[1].slots, result[1].shared, true);
                else
                    jShared.log:warn("InventoryManager:register(): inventory [ ".. name .." ] already exists");
                end
            else
                if (not self.inventories[result[1].id]) then
                    self:buildInventory(result[1].id, result[1].name, result[1].label, result[1].owner, result[1].maxWeight, result[1].slots, result[1].shared, false);
                else
                    jShared.log:warn("InventoryManager:register(): inventory [ ".. name .." ] already exists");
                end
            end
        end
    end)
end

---@param owner number
---@param inventoryName? string
---@return Inventory | nil
function InventoryManager:getByOwner(owner, inventoryName)
    local found = false;
    if (self.owned[owner]) then
        if (inventoryName) then
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
            return self.owned[owner];
        end
    else
        jShared.log:warn('InventoryManager:getByOwner(): owner [ '.. owner ..' ] not found');
        return nil;
    end
    if (not found) then
        jShared.log:warn('InventoryManager:getByOwner(): inventory [ Owner: "'.. owner.. '" name: "'.. inventoryName ..'" ] not found');
        return nil;
    end
end

---@param inventory Inventory
---@param owner string
---@return void
function InventoryManager:setOwner(inventory, owner)
    if (inventory) then
        if (self.inventories[inventory:getId()]) then
            self.inventories[inventory:getId()]:setOwner(owner);
            self.owned[inventory:getOwner()][inventory:getId()] = self.inventories[inventory:getId()];
            self.inventories[inventory:getId()] = nil;
        elseif (self.owned[inventory:getOwner()][inventory:getId()]) then
            local lastOwner = inventory:getOwner();
            self.owned[lastOwner][inventory:getId()]:setOwner(owner);
            self.owned[owner][inventory:getId()] = self.owned[inventory:getOwner()][inventory:getId()];
            self.owned[lastOwner][inventory:getId()] = nil;
        else
            jShared.log:warn('InventoryManager:setOwner(): inventory [ '.. inventory ..' ] not found');
        end
    end
end

---@param id string id or name of Inventory
---@return Inventory
function InventoryManager:get(id)
    for inventory, _ in pairs(self.inventories) do
        local inv = self.inventories[inventory]
        if (inv:getId() == id or inv:getName() == tostring(id)) then
            return inv;
        end
    end
end

---@param name string
---@param label string
---@param owner number
---@param maxWeight number
---@param slots number
---@param shared number
function InventoryManager:create(name, label, owner, maxWeight, slots, shared)
    jServer.mysql:query("INSERT INTO inventories (name, label, owner, maxWeight, slots, shared) VALUES (?, ?, ?, ?, ?, ?)", {
        name,
        label,
        owner,
        maxWeight,
        slots,
        shared
    }, function()
        self:register(name, owner);
    end)
end

---@private
---@param id number
---@param name string
---@param label string
---@param owner string
---@param maxWeight number
---@param slots number
---@param shared number
---@param owned boolean
function InventoryManager:buildInventory(id, name, label, owner, maxWeight, slots, shared, owned)
    local inventory = Inventory:new(id, name, label, owner, maxWeight, slots, shared)
    if (owned) then
        self.owned[owner][id] = inventory
    else
        self.inventories[name] = inventory
    end
    Events.Call(SharedEnums.Player.inventoryLoaded, owner, id, name);
end

jServer.inventoryManager = InventoryManager:new();