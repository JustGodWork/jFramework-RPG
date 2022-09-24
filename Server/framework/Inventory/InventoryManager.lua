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

    jShared.log:debug("[ InventoryManager ] initialized.");

    return self;
end

---@param id string
---@param name string
---@param label string
---@param owner number
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
            jShared.log:warn("InventoryManager:register(): inventory [ ".. name .." ] already exists");
            return nil;
        end
    elseif (not self.inventories[id]) then
        self.inventories[id] = Inventory:new(id, name, label, owner, items, maxWeight, inventoryType);
        return self.inventories[id];
    else
        jShared.log:warn("InventoryManager:register(): inventory [ ".. name .." ] already exists");
        return nil;
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
---@param inventoryType number
---@param callback fun(success: boolean)
function InventoryManager:create(name, label, owner, maxWeight, inventoryType, callback)
    jServer.mysql:query("INSERT INTO inventories (name, label, owner, maxWeight, items, shared) VALUES (?, ?, ?, ?, ?, ?)", {
        name, 
        label, 
        owner, 
        maxWeight,
        JSON.stringify({}),
        inventoryType
    }, function(success)
        if (success) then
            jServer.mysql:select("SELECT * FROM inventories WHERE owner = ? AND name = ?", { owner, name }, function(result)
                if (result) then
                    local inv = self:register(
                        result[1].id, 
                        result[1].name, 
                        result[1].label, 
                        result[1].owner, 
                        {}, 
                        result[1].maxWeight,
                        result[1].shared
                    );
                    self:buildInventoryItems(result[1].id, result[1].name, result[1].items and JSON.parse(result[1].items) or {});
                    if (owner) then
                        if (inv) then
                            jShared.log:info("InventoryManager:create(): inventory [ Id: ".. inv:getId() .." Owner: ".. inv:getOwner() .." Name: ".. inv:getName() .." ] created");
                        else
                            jShared.log:warn("InventoryManager:create(): inventory [ Owner: ".. owner .." Name: ".. name .." ] not created");
                        end
                    else
                        if (inv) then
                            jShared.log:info("InventoryManager:create(): inventory [ Id: ".. inv:getId() .." Name: ".. inv:getName() .." ] created");
                        else
                            jShared.log:warn("InventoryManager:create(): inventory [ Name: ".. name .." ] not created");
                        end
                    end
                    if (callback) then callback(inv ~= nil); end
                else
                    jShared.log:warn("InventoryManager:create(): inventory [ ".. name .." ] not created");
                end
            end, name);
        else
            if (owner) then
                jShared.log:warn("InventoryManager:create(): inventory [ Owner: ".. owner .." Name: ".. name .." ] not created");
            else
                jShared.log:warn("InventoryManager:create(): inventory [ ".. name .." ] not created");
            end
            if (callback) then callback(false); end
        end
    end)
end

---@param id Player.character_id
---@param callback fun(success: boolean)
function InventoryManager:initPlayer(id, callback)
    jServer.mysql:select("SELECT * FROM inventories WHERE owner = ?", { id }, function (result)
        if (#result > 0) then
            for i = 1, #result do
                self:register(
                    result[i].id,
                    result[i].name,
                    result[i].label, 
                    id,
                    {},
                    result[i].maxWeight,
                    result[i].shared
                );
                self:buildInventoryItems(id, result[i].name, JSON.parse(result[i].items));
            end
            jShared.log:success("[ InventoryManager ] => player [".. id .."] inventories initialized");
            if (callback) then callback(true); end
        else
            for i = 1, #Config.player.inventories do 
                local inv = Config.player.inventories[i];
                self:create(
                    inv.name,
                    inv.label,
                    id,
                    inv.maxWeight,
                    inv.shared,
                    callback
                );
            end
        end
    end);
end

---@param owner number
---@param name string
---@param items table
function InventoryManager:buildInventoryItems(owner, inventoryName, items)
    local inventory = self:getByOwner(owner, inventoryName);
    local playerItems = {};
    if (inventory) then
        for _, itemData in pairs(items) do
            if (itemData) then
                local item = ItemManager:get(itemData.name);
                if (item) then
                    playerItems[item.name] = item;
                    playerItems[item.name].count = itemData.count;
                else
                    jShared.log:warn("InventoryManager:buildInventoryItems(): [ Inventory: ".. inventory:getId() .. " Item: " .. itemData.name .." ] not found");
                end
            end
        end
        inventory:setItems(playerItems);
    end
end

jServer.inventoryManager = InventoryManager:new();