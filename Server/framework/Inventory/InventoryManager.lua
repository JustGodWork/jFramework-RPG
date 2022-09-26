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

    self._repository = jServer.repositoryManager:register("inventories", {
        { name = "name", type = "VARCHAR(255) NOT NULL" },
        { name = "label", type = "VARCHAR(50) NOT NULL" },
        { name = "owner", type = "INT(11) NOT NULL" },
        { name = "items", type = "LONGTEXT NOT NULL" },
        { name = "shared", type = "INT(11) NOT NULL" },
        { name = "maxWeight", type = "FLOAT NOT NULL" }
    });

    jShared.log:debug("[ InventoryManager ] initialized.");

    return self;
end

---@return Repository
function InventoryManager:repository()
    return self._repository;
end

---@param name string
---@param owner string
function InventoryManager:register(name, owner)
    if (owner) then
        self:repository():prepare({ "owner", "name" }, { owner = owner, name = name }, function(result, success)
            if (success) then
                if (not self.owned[result[1].owner]) then
                    self.owned[owner] = {};
                end
                if (not self.owned[owner][result[1].id]) then
                    self.owned[owner][result[1].id] = Inventory:new(result[1].id, result[1].name, result[1].label, result[1].owner, {}, result[1].maxWeight, result[1].shared);
                    self:buildInventoryItems(self.inventories[result[1].id], result[1].items);
                else
                    jShared.log:warn("InventoryManager:register(): inventory [ ".. name .." ] already exists");
                end
            end
        end);
    else
        self:repository():prepare("name", name, function(result, success)
            if (success) then
                if (not self.inventories[result[1].id]) then
                    self.inventories[result[1].id] = Inventory:new(result[1].id, result[1].name, result[1].label, result[1].owner, {}, result[1].maxWeight, result[1].shared);
                    self:buildInventoryItems(self.inventories[result[1].id], result[1].items);
                else
                    jShared.log:warn("InventoryManager:register(): inventory [ ".. name .." ] already exists");
                end
            end
        end);
    end
end

---@param owner number
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
        jShared.log:warn('InventoryManager:getByOwner(): owner [ '.. owner ..' ] not found');
        return nil;
    end
    if (not found) then
        jShared.log:warn('InventoryManager:getByOwner(): inventory [ Owner: "'.. owner.. '" name: "'.. inventoryName ..'" ] not found');
        return nil;
    end
end

---@param inventory Inventory
---@param owner number
---@return void
function InventoryManager:setOwner(inventory, owner)
    if (inventory) then
        if (self.inventories[inventory:getId()]) then
            self.inventories[inventory:getId()].owner = owner;
            self:repository():save(self.inventories[inventory:getId()]);
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
---@param callback? function
function InventoryManager:create(name, label, owner, maxWeight, shared, callback)
    self:repository():save({
        name = name,
        label = label,
        owner = owner,
        maxWeight = maxWeight,
        items = {},
        shared = shared
    }, function()
        self:register(name, owner);
        if (callback) then callback(); end
    end);
end

---@param playerInventory Inventory
---@param items table
function InventoryManager:buildInventoryItems(playerInventory, items)
    local playerItems = {};
    if (playerInventory) then
        for _, itemData in pairs(items) do
            if (itemData) then
                local item = jServer.itemManager:getItem(itemData.name);
                if (item) then
                    playerItems[item.name] = item;
                    playerItems[item.name].count = itemData.count;
                else
                    jShared.log:warn("InventoryManager:buildInventoryItems(): [ Inventory: ".. playerInventory:getId() .. " Item: " .. itemData.name .." ] not found");
                end
            end
        end
        playerInventory:setItems(playerItems);
    end
end

jServer.inventoryManager = InventoryManager:new();