--[[
--Created Date: Wednesday September 21st 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Wednesday September 21st 2022 12:23:40 am
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

---@class ItemManager
local ItemManager = {}

---@return ItemManager
function ItemManager:new()
    ---@type ItemManager
    local self = {}
    setmetatable(self, { __index = ItemManager});

    self.items = {};

    return self;
end

---@param name string
---@param label string
---@param type string
---@param weight number
---@param maxStack boolean
---@param metadata table
---@extras table
---@return void
function ItemManager:addItem(name, label, type, weight, maxStack, metadata, extras)
    self.items[name] = {
        name = name,
        label = label,
        type = type,
        weight = weight,
        maxStack = maxStack,
        metadata = metadata,
        extras = extras
    };
end

---@param name string
---@return boolean
function ItemManager:isValid(name)
    return self.items[name] ~= nil;
end

---@param name string
---@return boolean
function ItemManager:isStackable(name)
    return self.items[name].stackable;
end

---@param itemName string
---@return table
function ItemManager:getItem(itemName)
    for name, _ in pairs(self.items) do
        local item = self.items[name]
        if (item ~= nil and item.name == itemName) then
            return item;
        end
    end
end

---@param name string
---@return void
function ItemManager:removeItem(name)
    self.items[name] = nil;
end

---@param itemName string
---@return table
function ItemManager:getItemByName(itemName)
    for name, item in pairs(self.items) do
        if (item ~= nil and item.name == itemName) then
            return self.items[name];
        end
    end
end

---@param name string
---@return string
function ItemManager:getItemType(name)
    return self.items[name]:getType();
end

jServer.itemManager = ItemManager:new();