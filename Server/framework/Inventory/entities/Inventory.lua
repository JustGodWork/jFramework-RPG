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
---@param owner string
---@param items Item[]
---@param inventoryType number
---@return Inventory
function Inventory:new(id, name, owner, items, inventoryType)
    local self = {}
    setmetatable(self, { __index = Inventory});

    self.id = id;
    self.name = name;
    self.owner = owner;
    ---@type Item[]
    self.items = items;
    self.inventoryType = inventoryType;

    return self;
end

---@return string
function Inventory:getId()
    return self.id;
end

---@return string
function Inventory:getName()
    return self.name;
end

---@return string
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

---@param itemName string
---@param count number
---@return boolean
function Inventory:addItem(itemName, count)
    local item = jServer.itemManager:getItem(itemName)
    if item then
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
            Package.Log("Inventory:addItem(): item [ ".. itemName .." ] is unique but count is not 1")
            return false;
        end
    end
end

---@param itemName string
---@param count number
function Inventory:removeItem(itemName, count)
    local item = jServer.itemManager:getItem(itemName)
    if item then
        if self:hasItem(itemName) then
            if self.items[itemName]:getCount() - count <= 0 then
                self.items[itemName] = nil;
            else
                self.items[itemName]:setCount(self.items[itemName]:getCount() - count)
            end
        end
    end
end

---@param itemName string
---@return Item
function Inventory:getItem(itemName)
    return self.items[itemName];
end