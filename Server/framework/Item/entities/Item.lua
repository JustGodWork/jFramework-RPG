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

---@param id string
---@param name string
---@param label string
---@param data table
---@param type string
---@param weight number
---@param unique boolean
---@return Item
function Item:new(id, name, label, data, type, weight, unique)
    ---@type Item
    local self = {}
    setmetatable(self, { __index = Item});

    self.id = id;
    self.name = name;
    self.label = label;
    self.data = data or {};
    self.type = type;
    self.unique = unique or false;
    self.weight = weight or 0;
    self.count = 0;

    return self;
end

---@return string
function Item:getId()
    return self.id;
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

---@return table
function Item:getData()
    return self.data;
end

---@param key string
---@param value any
---@return void
function Item:setData(key, value)
    self.data[key] = value;
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
function Item:isUnique()
    return self.unique;
end

---@param bool boolean
function Item:setUnique(bool)
    self.unique = bool;
end

---@return number
function Item:getCount()
    return self.count;
end

---@param count number
function Item:setCount(count)
    self.count = count;
end

---@param player Player
function Item:use(player)
    if self.callback then
        self.callback(player);
    end
end