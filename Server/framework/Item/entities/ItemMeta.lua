---
---Created Date: 16:26 27/09/2022
---Author: JustGod
---Made with ❤

---File: [ItemMeta]

---Copyright (c) 2022 JustGodWork, All Rights Reserved.
---This file is part of JustGodWork project.
---Unauthorized using, copying, modifying and/or distributing of this file
---via any medium is strictly prohibited. This code is confidential.
---

---@class ItemMeta
ItemMeta = {}

---@param meta table
---<description: string | function, durability: number, hunger: number, thirst: number>
---@param extras table
---@return ItemMeta
function ItemMeta:new(meta, extras)
    print(JSON.stringify(meta))
    ---@type ItemMeta
    local self = {}
    setmetatable(self, { __index = ItemMeta});

    self.description = meta.description;
    self.durability = meta.durability;
    self.hunger = meta.hunger;
    self.thirst = meta.thirst;

    if (self.durability or self.hunger or self.thirst) then
        self.unique = true;
    end

    self.extras = extras or {};

    return self;
end

---@return string
function ItemMeta:getDescription()
    return self.description;
end

---@param description string
function ItemMeta:setDescription(description)
    self.description = description;
end

---@return number
function ItemMeta:getUses()
    return self.uses;
end

---@param uses number
function ItemMeta:setUses(uses)
    self.uses = uses;
end

---@param durability number
function ItemMeta:setDurability(durability)
    self.durability = durability;
end

---@return number
function ItemMeta:getDurability()
    return self.durability;
end

---@param hunger number
function ItemMeta:setHunger(hunger)
    self.hunger = hunger;
end

---@return number
function ItemMeta:getHunger()
    return self.hunger;
end

---@param thirst number
function ItemMeta:setThirst(thirst)
    self.thirst = thirst;
end

---@return number
function ItemMeta:getThirst()
    return self.thirst;
end

---@return boolean
function ItemMeta:isUnique()
    return self.unique;
end


    
