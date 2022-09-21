--[[
--Created Date: Tuesday September 20th 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Tuesday September 20th 2022 9:53:23 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

---@class Storage
Storage = {}

---@param id string
---@param name string
---@param label string
---@param owner string
---@param data table
---@param storageType number
---@return Storage
function Storage:new(id, name, label, owner, data, storageType)
    ---@type Storage
    local self = {}
    setmetatable(self, { __index = Storage});

    self.id = id;
    self.name = name;
    self.label = label
    self.owner = owner;
    self.data = data or {};
    self.type = storageType or 0;

    return self;
end

---@return string
function Storage:getId()
    return self.id;
end

---@return string
function Storage:getName()
    return self.name;
end

---@return string
function Storage:getLabel()
    return self.label;
end

---@param label string
function Storage:setLabel(label)
    self.label = label;
end

---@return string
function Storage:getOwner()
    return self.owner;
end

---@return table
function Storage:getData()
    return self.data;
end

---@param key string
---@param value any
---@return void
function Storage:get(key, value)
    return self.data[key];
end

---@param key string
---@param value any
---@return void
function Storage:set(key, value)
    self.data[key] = value;
end

---@return number
function Storage:getType()
    return self.type;
end

---@param type number
---@return void
function Storage:setType(type)
    self.type = type;
end