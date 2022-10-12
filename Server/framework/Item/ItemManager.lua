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

---@type ItemManager
local ItemManager = Class.new(function(class)

    ---@class ItemManager: BaseObject
    local self = class;

    ---@return ItemManager
    function self:Constructor()
        self.items = {};
        GM.Server.log:debug("[ ItemManager ] initialized.");
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
    function self:AddItem(name, label, description, weight, maxSize, durability, maxDurability, level, maxLevel)
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
    function self:GetItem(name)
        return self.items[name];
    end

    ---@param name string
    ---@return boolean
    function self:Exist(name)
        return self.items[name] ~= nil;
    end

    return self;
end);

---@type ItemManager
GM.Server.itemManager = ItemManager();