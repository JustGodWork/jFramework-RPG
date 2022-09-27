--[[
--Created Date: Wednesday September 21st 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Wednesday September 21st 2022 12:23:53 am
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

---@class Item
Item = {}

-- todo Make items work with the new inventory and ItemStack system
---@param name string
---@param label string
---@param type string
---@param weight number
---@param metadata table
---@param maxStack boolean
---@param extras table
---@param stackId number
---@return Item
function Item:new(name, label, type, weight, metadata, maxStack, extras, stackId)
    ---@type Item
    local self = {}
    setmetatable(self, { __index = Item});

    self.name = name;
    self.label = label;
    self.data = ItemMeta:new(metadata, extras);
    self.type = type;
    self.weight = weight or 0;
    self.stackId = stackId;

    if (self.data:isUnique()) then
        print("Item is unique");
        self.maxStack = 1;
    else
        self.maxStack = maxStack or 1;
    end

    return self;
end

---@return string
function Item:getName()
    return self.name;
end

---@return string
function Item:getLabel()
    return self.label;
end

---@param label string
function Item:setLabel(label)
    self.label = label;
end

---@return ItemMeta
function Item:getMeta()
    return self.data;
end

---@return string
function Item:getType()
    return self.type;
end

---@param type string
---@return void
function Item:setType(type)
    self.type = type;
end

function Item:setCallback(callback)
    self.callback = callback;
end

---@return number
function Item:getWeight()
    return self.weight;
end

---@return boolean
function Item:getMaxStack()
    return self.maxStack;
end

---@param maxStack number
function Item:setMaxStack(maxStack)
    self.maxStack = maxStack;
end

---@param key string
---@return any
function Item:getExtra(key)
    return self.extras[key];
end

---@param key string
---@param value any
---@return void
function Item:setExtra(key, value)
    self.extras[key] = value;
end

---@return table
function Item:getExtras()
    return self.extras;
end

---@param player Player
function Item:use(player)
    if self.callback then
        self.callback(player);
    end
end

---@return number
function Item:getStackId()
    return self.stackId;
end