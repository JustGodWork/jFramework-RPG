---
---Created Date: 19:09 28/09/2022
---Author: JustGod
---Made with ❤

---File: [ItemStack]

---Copyright (c) 2022 JustGodWork, All Rights Reserved.
---This file is part of JustGodWork project.
---Unauthorized using, copying, modifying and/or distributing of this file
---via any medium is strictly prohibited. This code is confidential.
---

---@class ItemStack
ItemStack = {}

---@param itemName string
---@param label string
---@param description string
---@param amount number
---@param weight number
---@param maxSize number
---@param durability number
---@param maxDurability number
---@param level number
---@param maxLevel number
---@return ItemStack
function ItemStack:new(
        itemName,
        label,
        description,
        amount,
        weight,
        maxSize,
        durability,
        maxDurability,
        level,
        maxLevel
)
    ---@type ItemStack
    local self = {}
    setmetatable(self, { __index = ItemStack});

    self.name = itemName;
    self.label = label;
    self.description = description or -1; --metadata
    self.durability = durability or -1; --metadata
    self.maxDurability = ( (durability and maxDurability) and maxDurability ) or -1; --metadata
    self.level = level or -1; --metadata
    self.maxLevel = (self.level > -1 and maxLevel) or -1; --metadata
    self.amount = (amount and amount) or 0;
    self.defaultWeight = weight or 0;
    self.weight = weight * self.amount;
    self.meta = false;

    if (description and jShared.utils:isString(description) and description ~= "-1") then self.meta = false; end
    if (durability and jShared.utils:isNumber(durability) and durability > -1) then self.meta = false; end
    if (maxDurability and jShared.utils:isNumber(maxDurability) and maxDurability > -1) then self.meta = false;; end
    if (level and jShared.utils:isNumber(level) and level > -1) then self.meta = false; end

    self.maxSize = (not self.meta and maxSize and maxSize) or 1;

    return self
end

---@return string
function ItemStack:getName()
    return self.name;
end

---@return string
function ItemStack:getLabel()
    return self.label;
end

---@return boolean
function ItemStack:hasDescription()
    return self.description ~= nil;
end

---@return string
function ItemStack:getDescription()
    return self.description;
end

---@param description string
function ItemStack:setDescription(description)
    self.description = description;
end

---@return number
function ItemStack:getWeight()
    return self.weight;
end

---@param weight number
function ItemStack:setWeight(weight)
    self.weight = weight;
end

---Update ItemStack weight
function ItemStack:updateWeight()
    self.weight = self.defaultWeight * self.amount;
end

---@return number
function ItemStack:getMaxSize()
    return self.maxSize;
end

---@param maxSize number
function ItemStack:setMaxSize(maxSize)
    self.maxSize = maxSize;
end

---@return boolean
function ItemStack:isFull()
    return self.amount >= self.maxSize;
end

---@return boolean
function ItemStack:hasDurability()
    return self.durability > -1;
end

---@return number
function ItemStack:getDurability()
    return self.durability;
end

---@param durability number
function ItemStack:setDurability(durability)
    self.durability = durability;
end

---@return number
function ItemStack:getMaxDurability()
    return self.maxDurability;
end

---Repair item
function ItemStack:repair()
    self.durability = self.maxDurability;
end

---@return boolean
function ItemStack:isBroken()
    return self.durability == 0;
end

---@return boolean
function ItemStack:isFullDurability()
    return self.durability == self.maxDurability;
end

---@return boolean
function ItemStack:hasLevel()
    return self.level > -1;
end

---@return number
function ItemStack:getLevel()
    return self.level;
end

---@param level number
function ItemStack:setLevel(level)
    self.level = level;
end

---@return number
function ItemStack:getMaxLevel()
    return self.maxLevel;
end

---Upgrade item to max level
function ItemStack:upgrade()
    self.level = self.maxLevel;
end

---@return boolean
function ItemStack:isMaxLevel()
    return self.level == self.maxLevel;
end

---@return boolean
function ItemStack:hasMeta()
    return self.meta;
end

---@return number
function ItemStack:getAmount()
    return self.amount;
end

---@param amount number
---@return boolean
function ItemStack:setAmount(amount)
    if (amount > 0 and amount <= self:getMaxSize()) then
        self.amount = amount;
        self:updateWeight();
        return true;
    end
    return false;
end

---Return free space in ItemStack
---@return number
function ItemStack:getFreeSpace()
    return self:getMaxSize() - self:getAmount();
end

---@param amount number
---@return boolean
function ItemStack:canCarryItem(amount)
    return self:getAmount() + amount <= self:getMaxSize();
end

---@param amount number
---@return boolean
function ItemStack:add(amount)
    if (self:getAmount() + amount <= self:getMaxSize()) then
        self.amount = self:getAmount() + amount;
        self:updateWeight();
        return true;
    end
    return false;
end

---@param amount number
---@return boolean
function ItemStack:remove(amount)
    if (self.amount - amount >= 0) then
        self.amount = self.amount - amount;
        self:updateWeight();
        return true;
    end
    return false;
end
    
