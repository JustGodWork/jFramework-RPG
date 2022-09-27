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
            PRIMARY KEY (id)
        ) ENGINE=InnoDB DEFAULT CHARSET=latin1
    ]])

    jServer.mysql:query([[
        CREATE TABLE IF NOT EXISTS inventories_items (
            id INT(11) NOT NULL AUTO_INCREMENT,
            inventoryId INT(11) NOT NULL,
            name VARCHAR(255) NOT NULL,
            durability FLOAT NULL,
            hunger FLOAT NULL,
            thirst FLOAT NULL,
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
                    self.owned[owner][result[1].id] = Inventory:new(result[1].id, result[1].name, result[1].label, result[1].owner, {}, result[1].maxWeight, result[1].shared);
                    self:buildInventoryItems(self.inventories[result[1].id]);
                else
                    jShared.log:warn("InventoryManager:register(): inventory [ ".. name .." ] already exists");
                end
            else
                if (not self.inventories[result[1].id]) then
                    self.inventories[result[1].id] = Inventory:new(result[1].id, result[1].name, result[1].label, result[1].owner, {}, result[1].maxWeight, result[1].shared);
                    self:buildInventoryItems(self.inventories[result[1].id]);
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
---@param shared number
function InventoryManager:create(name, label, owner, maxWeight, shared)
    jServer.mysql:query("INSERT INTO inventories (name, label, owner, shared, maxWeight) VALUES (?, ?, ?, ?, ?)", {
        name,
        label,
        owner,
        shared,
        maxWeight
    }, function()
        self:register(name, owner);
    end)
end

---@param Inventory Inventory
function InventoryManager:buildInventoryItems(Inventory)
    local items = {};
    if (Inventory) then
        jServer.mysql:select("SELECT * FROM inventories_items WHERE inventoryId = ?", { Inventory:getId() }, function(result)
            for _, itemData in pairs(result) do
                if (itemData) then
                    local item = jServer.itemManager:getItem(itemData.name);
                    if (jServer.itemManager:isValid(item.name)) then
                        local metadata = {
                            uses = itemData.uses,
                            durability = itemData.durability,
                            hunger = itemData.hunger,
                            thirst = itemData.thirst
                        };
                        items[#items + 1] = {
                            item.name,
                            item.label,
                            item.type,
                            item.weight,
                            metadata,
                            item.maxStack
                        };
                    else
                        jShared.log:warn("InventoryManager:buildInventoryItems(): [ Inventory: ".. Inventory:getId() .. " Item: " .. itemData.name .." ] not found");
                    end
                end
            end
            Inventory:setItems(items);
        end)
    end
end

jServer.inventoryManager = InventoryManager:new();