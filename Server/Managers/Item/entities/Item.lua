--[[
----
----Created Date: 12:00 Thursday October 13th 2022
----Author: JustGod
----Made with ❤
----
----File: [Item]
----
----Copyright (c) 2022 JustGodWork, All Rights Reserved.
----This file is part of JustGodWork project.
----Unauthorized using, copying, modifying and/or distributing of this file
----via any medium is strictly prohibited. This code is confidential.
----
--]]

---@type Item
Item = Class.new(function(class)

    ---@class Item: BaseObject
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
    function self:Constructor(itemName, label, description, amount, weight, durability, maxDurability, level, maxLevel)
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

        if (description and GM.Utils:isString(description) and description ~= "-1") then self.meta = false; end
        if (durability and GM.Utils:isNumber(durability) and durability > -1) then self.meta = false; end
        if (maxDurability and GM.Utils:isNumber(maxDurability) and maxDurability > -1) then self.meta = false;; end
        if (level and GM.Utils:isNumber(level) and level > -1) then self.meta = false; end
    end

    ---@return string
    function self:GetName()
        return self.name;
    end

    ---@return string
    function self:GetLabel()
        return self.label;
    end

    ---@return boolean
    function self:HasDescription()
        return self.description ~= nil;
    end

    ---@return string
    function self:GetDescription()
        return self.description;
    end

    ---@param description string
    function self:SetDescription(description)
        self.description = description;
    end

    ---@return number
    function self:GetWeight()
        return self.weight;
    end

    ---@param weight number
    function self:SetWeight(weight)
        self.weight = weight;
    end

    ---Update ItemStack weight
    function self:UpdateWeight()
        self.weight = self.defaultWeight * self.amount;
    end

    ---@return boolean
    function self:HasMeta()
        return self.meta;
    end

    ---@return boolean
    function self:HasDurability()
        return self.durability > -1;
    end

    ---@return number
    function self:GetDurability()
        return self.durability;
    end

    ---@param durability number
    function self:SetDurability(durability)
        self.durability = durability;
    end

    ---@return number
    function self:GetMaxDurability()
        return self.maxDurability;
    end

    ---Repair item
    function self:Repair()
        self.durability = self.maxDurability;
    end

    ---@return boolean
    function self:IsBroken()
        return self.durability == 0;
    end

    ---@return boolean
    function self:IsFullDurability()
        return self.durability == self.maxDurability;
    end

    ---@return boolean
    function self:HasLevel()
        return self.level > -1;
    end

    ---@return number
    function self:GetLevel()
        return self.level;
    end

    ---@param level number
    function self:SetLevel(level)
        self.level = level;
    end

    ---@return number
    function self:GetMaxLevel()
        return self.maxLevel;
    end

    ---Upgrade item to max level
    function self:Upgrade()
        self.level = self.maxLevel;
    end

    ---@return boolean
    function self:IsMaxLevel()
        return self.level == self.maxLevel;
    end

    return self;
end)