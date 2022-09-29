---
---Created Date: 19:06 28/09/2022
---Author: JustGod
---Made with ❤

---File: [Inventory]

---Copyright (c) 2022 JustGodWork, All Rights Reserved.
---This file is part of JustGodWork project.
---Unauthorized using, copying, modifying and/or distributing of this file
---via any medium is strictly prohibited. This code is confidential.
---
    
---@class Inventory
Inventory = {}

---@param name string
---@param owner string
---@param slots number
---@param maxWeight number
function Inventory:new(name, owner, maxWeight, slots, items)
    ---@type Inventory
    local self = {}
    setmetatable(self, { __index = Inventory});

    self.name = name;
    self.owner = owner;
    self.weight = 0;
    self.maxWeight = maxWeight;
    self.slots = slots;
    ---@type ItemStack[]
    self.items = {};

    if (items) then
        self:build(items);
    end
    return self
end

---@return number
function Inventory:getNumberOfSlots()
    return self.slots;
end

---@private
---Return first free slot
---@return number
function Inventory:getFreeSlot()
    for i = 1, self.slots do
        if (not self.items[i]) then
            return i;
        end
    end
    return nil;
end

---@private
---@param itemName string
---@return number id of slot
function Inventory:getFirstSlotWithFreeSpace(itemName)
    for i = 1, self.slots do
        if (self.items[i]) then
            if (self.items[i]:getName() == itemName) then
                if (self.items[i]:getAmount() < self.items[i]:getMaxSize()) then
                    return i;
                end
            end
        end
    end
    return nil;
end

---@return number
function Inventory:getMaxWeight()
    return self.maxWeight;
end

---@return number
function Inventory:getWeight()
    return self.weight;
end

---@private
---Update Inventory weight
---@return number
function Inventory:updateWeight()
    local weight = 0;
    for i = 1, self.slots do
        if (self.items[i]) then
            weight = weight + self.items[i]:getWeight();
        end
    end
    self.weight = weight;
end

---@private
---@param item table
---@return ItemStack | nil
function Inventory:createStack(item, amount)
    local itemExist = jServer.itemManager:exist(item.name);
    local freeSlot = self:getFreeSlot();
    if (itemExist) then
        if (freeSlot) then
            self.items[freeSlot] = ItemStack:new(
                    item.name,
                    item.label,
                    item.description,
                    (amount ~= nil and amount <= item.maxSize and amount),
                    item.weight,
                    item.maxSize,
                    item.durability,
                    item.maxDurability,
                    item.level,
                    item.maxLevel
            );
            return self.items[freeSlot];
        end
    end
    return nil;
end

---@private
---@param stackOne ItemStack
---@param stackTwo ItemStack
function Inventory:stackMetaEquals(stackOne, stackTwo)
    if (stackOne:getDescription() == stackTwo:getDescription()) then
        if (stackOne:getDurability() == stackTwo:getDurability()) then
            if (stackOne:getLevel() == stackTwo:getLevel()) then
                return true;
            end
        end
    end
    return false;
end

---@private
---@param stackFrom ItemStack
---@param stackTo ItemStack
function Inventory:switchStack(stackFrom, stackTo)
    local tempFrom = self.items[stackFrom];
    local tempTo = self.items[stackTo];
    self.items[stackFrom] = tempTo;
    self.items[stackTo] = tempFrom;
end

---@private
---@param stackFrom ItemStack
---@param stackTo ItemStack
---@param amount number
---@return boolean
function Inventory:onSwitchStackAmount(stackFrom, stackTo, amount)
    if (self.items[stackFrom]:getAmount() - amount >= 0) then
        if (self.items[stackTo]:getAmount() + amount <= stackTo:getMaxSize()) then
            return true;
        end
    end
    return false;
end

---@param stackToRemove ItemStack
---@param stackToAdd ItemStack
---@param amount number
function Inventory:switchStackAmount(stackToRemove, stackToAdd, amount)
    if (self:onSwitchStackAmount(stackToRemove, stackToAdd, amount)) then
        self.items[stackToRemove]:remove(amount);
        self.items[stackToAdd]:add(amount);
    end
end

---@param from number
---@param to number
function Inventory:changeStackSlot(from, to)
    if (self.items[from] and self.items[to]) then
        local itemFrom = self.items[from];
        local itemTo = self.items[to];
        if not (itemTo and itemTo <= self.slots) then
            self:createStack(itemFrom);
        else
            return false;
        end
        if (itemFrom:getName() == itemTo:getName()) then
            if (self:stackMetaEquals(itemFrom, itemTo)) then
                if (itemTo:getFreeSpace() >= itemFrom:getAmount()) then
                    itemTo:setAmount(itemFrom:getAmount() + itemTo:getAmount());
                    self.items[from] = nil;
                    return true;
                else
                    local freeSpace = itemTo:getFreeSpace();
                    itemTo:setAmount(itemTo:getMaxSize());
                    itemFrom:setAmount(itemFrom:getAmount() - freeSpace);
                    return true;
                end
            else
                self.items[itemTo] = nil;
            end
        else
            self:switchStack(itemFrom, itemTo);
            return true;
        end
    end
    return false;
end

---@private
---@param item table
---@param amount number
function Inventory:processStack(item, amount)
    local freeSpace = self:getFirstSlotWithFreeSpace(item.name);
    ---@type ItemStack
    local firstStack;
    if (freeSpace) then
        firstStack = self.items[freeSpace];
    else
        firstStack = self:createStack(item, item.amount);
    end
    if (firstStack) then
        if (firstStack:hasMeta() and amount == 1) then
            firstStack:add(1);
        elseif (firstStack:canCarryItem(amount)) then
            firstStack:add(amount);
        else
            if (self:getFreeSlot()) then
                local space  = firstStack:getFreeSpace();
                local rest = amount - space;
                firstStack:add(space);
                self:processStack(item, rest);
            end
        end
    end
end

---@private
---@param items table
function Inventory:build(items)
    for i = 1, #items do
        if (items[i]) then
            if (items[i].maxSize == 1) then
                self:processStack(items[i], 1);
            else
                self:processStack(items[i], items[i].amount);
            end
        end
    end
end

--[[
local inv = Inventory:new("test", "test", 100, 10);

local water = jServer.itemManager:getItem("water");
local bread = jServer.itemManager:getItem("bread");

local invItems = {}

for i = 1, 6 do
    print(i)
    if (i <= 2) then
        local item = {
            name = water.name,
            label = water.label,
            description = "Water is good" .. i,
            amount = 1,
            weight = water.weight,
            maxSize = water.maxSize,
            durability = water.durability,
            maxDurability = water.maxDurability,
            level = water.level,
            maxLevel = water.maxLevel
        }
        invItems[i] = item;
    else
        local item = {
            name = bread.name,
            label = bread.label,
            description = bread.description,
            amount = 1,
            weight = bread.weight,
            maxSize = bread.maxSize,
            durability = bread.durability,
            maxDurability = bread.maxDurability,
            level = bread.level,
            maxLevel = bread.maxLevel
        }
        invItems[i] = item;
    end
end

inv:build(invItems);

jShared.log:info(inv.items);
]]