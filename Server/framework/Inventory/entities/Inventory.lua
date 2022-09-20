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
---@param items Map
---@param inventoryType number
---@return Inventory
function Inventory:new(id, name, owner, items, inventoryType)
    local class = {};
    setmetatable(class, {__index = Inventory});

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

---@return Map
function Inventory:getItems()
    return self.items;
end

function Inventory:getInventoryType()
    return self.inventoryType;
end