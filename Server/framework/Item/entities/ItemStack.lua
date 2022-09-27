---
---Created Date: 21:21 27/09/2022
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

-- todo make this work with inventories
---@param items Item[]
---@param itemData Item | table
---@param stackId number
---@return ItemStack
function ItemStack:new(items, itemData, stackId)
    ---@type ItemStack
    local self = {}
    setmetatable(self, { __index = ItemStack});

    self.id = stackId;
    ---@type Item[]
    self.items = items or {};
    self.amount = #self.items;
    self.name = itemData.name;
    self.maxStackSize = itemData.maxStack or 0;
    self.type = itemData.type;
    self.itemWeight = itemData.weight;
    self.unique = self.maxStackSize <= 1;

    return self;
end

---@return number
function ItemStack:getId()
    return self.id;
end

---@return string
function ItemStack:getName()
    return self.name;
end

---@return string
function ItemStack:getType()
    return self.type;
end

---@return number
function ItemStack:getItemWeight()
    return self.itemWeight;
end

---@return number
function ItemStack:getCount()
    return #self.items;
end

---@return Item
function ItemStack:getItem()
    return self.items[#self.items];
end

---@param item Item
---@return boolean
function ItemStack:addItem(item, count)
    item.stackId = self.id;
    local newItem = Item:new(item.name, item.label, item.type, item.weight, item.metadata, item.maxStack, item.extras, self.id);
    if (self:getCount() + count < self:getMaxSize() and self:getCount() + count < newItem:getMaxStack()) then
        for i = 1, count do
            self.items[i] = newItem;
        end
        self.amount = self:getCount();
        return true
    end
    return false
end

---Remove an item from the stack
function ItemStack:removeItem(count)
    local hasRemove = false;
    if (count == nil) then count = 1; end
    for i = 1, count do
        if (self:hasItems()) then
            self.items[#self.items] = nil;
            hasRemove = true;
        else
            hasRemove = false;
        end
    end
    self.amount = self:getCount();
    return hasRemove;
end

---@return boolean
function ItemStack:hasItems()
    return self.amount > 0;
end

---@return number
function ItemStack:getWeight()
    local weight = 0;
    for _, item in pairs(self.items) do
        if (item) then
            weight = weight + item:getWeight();
        end
    end
    return weight;
end

---Return true if the stack can contain one item only
---@return boolean
function ItemStack:uniqueItem()
    return self.unique;
end

---Return true if the stack is full
---@return boolean
function ItemStack:isFull()
    return self.amount >= self.maxStackSize;
end

---Return true if the stack is empty
---@return boolean
function ItemStack:isEmpty()
    return self.amount == 0;
end

---@return boolean
function ItemStack:getMaxSize()
    return self.maxStackSize;
end

---@param unique boolean
function ItemStack:setItemUnique(unique)
    self.unique = unique;
end
