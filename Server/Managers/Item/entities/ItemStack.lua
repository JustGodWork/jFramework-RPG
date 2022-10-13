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

---@type ItemStack
ItemStack = Class.extends(Item, function(class)

    ---@class ItemStack: Item
    local self = class;

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
    function self:Constructor(
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
        self:super(itemName, label, description, amount, weight, durability, maxDurability, level, maxLevel);

        self.maxSize = (not self:HasMeta() and maxSize and maxSize) or 1;
    end

    ---@return number
    function self:GetMaxSize()
        return self.maxSize;
    end

    ---@param maxSize number
    function self:SetMaxSize(maxSize)
        self.maxSize = maxSize;
    end

    ---@return boolean
    function self:IsFull()
        return self.amount >= self.maxSize;
    end

    ---@return number
    function self:GetAmount()
        return self.amount;
    end

    ---@param amount number
    ---@return boolean
    function self:SetAmount(amount)
        if (amount > 0 and amount <= self:GetMaxSize()) then
            self.amount = amount;
            self:UpdateWeight();
            return true;
        end
        return false;
    end

    ---Return free space in ItemStack
    ---@return number
    function self:GetFreeSpace()
        return self:GetMaxSize() - self:GetAmount();
    end

    ---@param amount number
    ---@return boolean
    function self:CanCarryItem(amount)
        return self:GetAmount() + amount <= self:GetMaxSize();
    end

    ---@param amount number
    ---@return boolean
    function self:Add(amount)
        if (self:GetAmount() + amount <= self:GetMaxSize()) then
            self.amount = self:GetAmount() + amount;
            self:UpdateWeight();
            return true;
        end
        return false;
    end

    ---@param amount number
    ---@return boolean
    function self:Remove(amount)
        if (self.amount - amount >= 0) then
            self.amount = self.amount - amount;
            self:UpdateWeight();
            return true;
        end
        return false;
    end

    return self;
end);
    
