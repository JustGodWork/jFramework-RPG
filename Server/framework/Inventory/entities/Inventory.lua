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
    self.items = items;
    self.inventoryType = inventoryType;
    self.items = items;

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

function Inventory:getType()
    return self.inventoryType;
end

---@param itemName string
function Inventory:hasItem(itemName)
    return self.items[itemName] ~= nil
end

---@param itemName string
---@param count number
function Inventory:addItem(itemName, count)
    local item = jServer.itemManager:getItem(itemName)
    if item then
        if self:hasItem(itemName) then
            self.items:get(itemName).count = self.items:get(itemName).count + count
        else
            self.items:set(itemName, {
                id = item:getId(),
                name = item:getName(),
                data = item:getData(),
                type = item:getType(),
                count = count
            })
        end
    end
end

---@param itemName string
---@param count number
function Inventory:removeItem(itemName, count)
    local item = ItemManager:getItem(itemName)
    if item then
        if self:hasItem(itemName) then
            if self.items:get(itemName).count - count <= 0 then
                self.items:set(itemName, nil)
            else
                self.items:get(itemName).count = self.items:get(itemName).count - count
            end
        end
    end
end

---@param itemName string
---@return Item
function Inventory:getItem(itemName)
    return self.items:get(itemName)
end