---
---Created Date: 16:39 28/09/2022
---Author: JustGod
---Made with ❤

---File: [ItemManager]

---Copyright (c) 2022 JustGodWork, All Rights Reserved.
---This file is part of JustGodWork project.
---Unauthorized using, copying, modifying and/or distributing of this file
---via any medium is strictly prohibited. This code is confidential.
---

---@class ItemManager
local ItemManager = {}

---@return ItemManager
function ItemManager:new()
    ---@type ItemManager
    local self = {}
    setmetatable(self, { __index = ItemManager});

    self.items = {};

    jShared.log:debug("[ ItemManager ] initialized.");

    return self
end

---@param name string
---@param label string
---@param description string
---@param weight number
---@param maxSize number
---@param durability number
---@param maxDurability number
---@param level number
---@param maxLevel number
function ItemManager:addItem(name, label, description, weight, maxSize, durability, maxDurability, level, maxLevel)
    self.items[name] = {
        name = name,
        label = label,
        description = description, --metadata
        weight = weight,
        durability = durability, --metadata
        maxDurability = maxDurability, --metadata
        maxSize = maxSize,
        level = level, --metadata
        maxLevel = maxLevel --metadata
    };
end

---@param name string
---@return table
function ItemManager:getItem(name)
    return self.items[name];
end

---@param name string
---@return boolean
function ItemManager:exist(name)
    return self.items[name] ~= nil;
end

jServer.itemManager = ItemManager:new();