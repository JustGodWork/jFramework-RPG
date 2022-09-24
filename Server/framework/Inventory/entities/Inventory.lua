--[[
--Created Date: Tuesday September 20th 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Tuesday September 20th 2022 11:28:01 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

---@class Inventory
Inventory = {}

---@param id string
---@param name string
---@param label string
---@param owner number
---@param items Item[]
---@param maxWeight number
---@param inventoryType number
---@return Inventory
function Inventory:new(id, name, label, owner, items, maxWeight, inventoryType)
    ---@type Inventory
    local self = {}
    setmetatable(self, { __index = Inventory});

    self.id = id;
    self.name = name;
    self.label = label;
    self.owner = owner;
    ---@type Item[]
    self.items = items or {};
    self.maxWeight = maxWeight or 0;
    self.inventoryType = inventoryType or 0;

    return self;
end

---@return number
function Inventory:getId()
    return self.id;
end

---@return string
function Inventory:getName()
    return self.name;
end

---@return string
function Inventory:getLabel()
    return self.label;
end

---@param label string
function Inventory:setLabel(label)
    self.label = label;
end

---@return number
function Inventory:getOwner()
    return self.owner;
end

---@return Item[]
function Inventory:getItems()
    return self.items;
end

---@return number
function Inventory:getType()
    return self.inventoryType;
end

---@param itemName string
function Inventory:hasItem(itemName)
    return self.items[itemName] ~= nil
end

---@return number
function Inventory:getWeight()
    local weight = 0;
    for _, item in pairs(self.items) do
        weight = weight + (item:getWeight() * item:getCount())
    end
    return weight;
end

---@param itemName string
---@param count number
---@return boolean
function Inventory:canCarryItem(itemName, count)
    local item = jServer.itemManager:getItem(itemName)
    if (item) then
        if (self:getWeight() + (item:getWeight() * count)) <= self.maxWeight then
            return true;
        end
        return false;
    else
        jShared.log:warn("Inventory:canCarryItem(): Inventory: [%s] item [%s] item not found", self.id, itemName)
        return false;
    end
    return false;
end

---@param itemName string
---@param count number
---@return boolean
function Inventory:addItem(itemName, count)
    local item = jServer.itemManager:getItem(itemName)
    if (item) then
        if (self:canCarryItem(itemName, count)) then
            if (item:isUnique() and count == 1) then
                self.items[itemName] = item
                self.items[itemName].count = 1
                return true;
            elseif (not item:isUnique() and self:hasItem(itemName)) then
                self.items[itemName].count = self.items[itemName].count + count
                return true;
            elseif (not item:isUnique()) then
                self.items[itemName] = item
                self.items[itemName].count = count
                return true;
            elseif (item:isUnique()) then
                jShared.log:warn(string.format("Inventory:addItem(): Inventory: [%s] item [%s] is unique but count is not 1", self.id, itemName))
                return false;
            end
        else
            jShared.log:warn(string.format("Inventory:addItem(): Inventory: [%s] item [%s] can't be carried", self.id, itemName))
            return false;
        end
    else
        jShared.log:warn(string.format("Inventory:addItem(): Inventory: [%s] item [%s] item not found", self.id, itemName))
        return false;
    end
end

---@param itemName string
---@param count number
---@return boolean
function Inventory:removeItem(itemName, count)
    local item = jServer.itemManager:getItem(itemName);
    if (item) then
        if self:hasItem(itemName) then
            local invItem = self.items[itemName]
            if invItem:getCount() - count == 0 then
                self.items[itemName] = nil;
                return true;
            elseif invItem:getCount() - count < 0 then
                jShared.log:warn("Inventory:removeItem(): Inventory: [%s] item [%s] count is less than 0", self.id, itemName);
                return false;
            else
                invItem:setCount(invItem:getCount() - count);
                return true;
            end
        end
    else
        jShared.log:warn(string.format("Inventory:removeItem(): Inventory: [%s] item [%s] item not found", self.id, itemName));
    end
end

---@param itemName string
---@return Item
function Inventory:getItem(itemName)
    return self.items[itemName];
end

---@param items Items[]
function Inventory:setItems(items)
    self.items = items;
end

---Clear inventory Items
function Inventory:clearItems()
    self.items = {};
end