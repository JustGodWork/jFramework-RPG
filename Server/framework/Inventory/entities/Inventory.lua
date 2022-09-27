--[[
--Created Date: Tuesday September 20th 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Tuesday September 20th 2022 11:28:01 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

---@class Inventory
Inventory = {}

---@param id string
---@param name string
---@param label string
---@param owner string
---@param items Item[]
---@param maxWeight number
---@param inventoryType number
---@return Inventory
function Inventory:new(id, name, label, owner, items, maxWeight, inventoryType)
    ---@type Inventory
    local self = {}
    setmetatable(self, { __index = Inventory});

    self.id = id;
    self.name = name;
    self.label = label;
    self.owner = owner;
    ---@type ItemStack[]
    self.items = self:generateStack(items) or {};
    self.maxWeight = maxWeight or 0;
    self.inventoryType = inventoryType or 0;
    return self;
end

-- todo make this work correctly
---@param name string
---@param unique boolean
---@return ItemStack[] | nil
function Inventory:getStacksByItemName(name, unique)
    local stacks = {};
    for _, stack in pairs(self.items) do
        if (stack:hasItems()) then
            if (stack:getName() == name and unique and stack:getMaxSize() <= 1) then
                stacks[#stacks + 1] = stack;
            elseif (stack:getName() == name and not unique) then
                stacks[#stacks + 1] = stack;
            end
        end
    end
    return (#stacks > 0 and stacks) or nil;
end

---@return number
function Inventory:getId()
    return self.id;
end

---@return string
function Inventory:getName()
    return self.name;
end

---@return string
function Inventory:getLabel()
    return self.label;
end

---@param label string
function Inventory:setLabel(label)
    self.label = label;
end

---@return string
function Inventory:getOwner()
    return self.owner;
end

---@param owner string
function Inventory:setOwner(owner)
    self.owner = owner;
end

---@return Item[]
function Inventory:getItems()
    return self.items;
end

---@return number
function Inventory:getType()
    return self.inventoryType;
end

---Generate stacks from items
---@param items Item[]
---@return ItemStack[]
function Inventory:generateStack(items)
    ---@type ItemStack[]
    local stack = {};
    for _, item in pairs(items or self.items) do
        if (item and item.name) then
            local newStack = #stack;
            if (stack[newStack] == nil) then
                stack[newStack] = ItemStack:new(nil, item, newStack);
            else
                if (stack[newStack]:isFull()) then
                    newStack = newStack + 1;
                    stack[newStack] = ItemStack:new({item}, item, newStack);
                end
            end

            if (item:getMaxStack() <= 1) then
                newStack = #stack + 1;
                stack[newStack] = ItemStack:new({item}, item, newStack);
            end

            stack[newStack]:addItem(item, 1);
        end
    end
    return stack;
end

---@param itemName string
---@return boolean
function Inventory:hasItem(itemName)
    for i = 1, #self.items do
        if (
                self.items[i]:getName() == itemName
                        and self.items[i]:hasItems()
        )
        then
            return true;
        end
    end
end

---@param itemName string
---@param count number
---@return ItemStack | nil
function Inventory:getFreeSlots(itemName, count)
    if (self:hasItem(itemName)) then
        for stackId, itemStack in pairs(self.items) do
            if (itemStack:getName() == itemName) then
                if (not itemStack:isFull() and not count) then
                    return self.items[stackId];
                elseif (itemStack:getCount() + count < itemStack:getMaxSize()) then
                    return self.items[stackId];
                end
            end
        end
    end
    return nil;
end

---@return number
function Inventory:getWeight()
    local weight = 0;
    for i = 1, #self.items do
        weight = weight + self.items[i]:getWeight();
    end
    return weight;
end

---@param itemName string
---@param count number
---@return boolean
function Inventory:canCarryItem(itemName, count)
    local item = jServer.itemManager:getItem(itemName)
    if (item) then
        if (self:getWeight() + (item.weight * count)) <= self.maxWeight then
            return true;
        end
        return false;
    else
        jShared.log:warn("Inventory:canCarryItem(): Inventory: [%s] item [%s] item not found", self.id, itemName)
        return false;
    end
    return false;
end

-- todo add item to stack if possible else create a unique stack for unique items
---@param itemName string
---@param count number
---@param metadata table
---@param extras table
---@return boolean
function Inventory:addItem(itemName, count, metadata, extras)
    local item = jServer.itemManager:getItem(itemName)

    if (item) then
        item.metadata = metadata or item.metadata;
        item.extras = extras or item.extras;

        if (self:canCarryItem(itemName, count)) then
            print("1")
            if (item.maxStack <= 1 and count == 1) then
                print("2")
                local stackId = #self.items + 1
                self.items[stackId] = ItemStack:new({ item }, item, stackId);
                return true;
            elseif (self:hasItem(itemName)) then
                print("3")
                local freeSlot = self:getFreeSlots(itemName, count)
                if (freeSlot) then
                    print("4")
                    freeSlot:addItem(item, count);
                end
                return true;
            elseif (not self:hasItem(itemName)) then
                print("5")
                local stackId = #self.items + 1
                self.items[stackId] = ItemStack:new(nil, item, stackId);
                if (self.items[stackId]:addItem(item, count)) then
                    print("6")
                    return true;
                else
                    print("We are there...")
                    self.items[stackId] = ItemStack:new(nil, item, stackId);
                    if (self.items[stackId]:addItem(item, count)) then
                        return true;
                    end
                end
                return false;
            else
                jShared.log:warn(string.format("Inventory:addItem(): Inventory: [%s] item [%s] is unique but count is not 1", self.id, itemName));
                return false;
            end
        else
            jShared.log:warn(string.format("Inventory:addItem(): Inventory: [%s] item [%s] can't be carried", self.id, itemName));
            return false;
        end
    else
        jShared.log:warn(string.format("Inventory:addItem(): Inventory: [%s] item [%s] item not found", self.id, itemName));
        return false;
    end
end

---@param itemStack ItemStack
---@param count number
---@return boolean
function Inventory:removeItem(itemStack, count)
    if not count then count = 0 end
    local item = jServer.itemManager:getItem(itemStack:getName());
    if (item) then
        if (self:hasItem(item.name)) then
            if (itemStack:getCount() - count == 0) then
                self.items[itemStack:getId()] = nil;
                return true;
            elseif (itemStack:getCount() - count < 0) then
                jShared.log:warn("Inventory:removeItem(): Inventory: [%s] item [%s] count is less than 0", self.id, item.name);
                return false;
            else
                if itemStack:removeItem(count) then
                    if (not itemStack:hasItems()) then
                        self.items[itemStack:getId()] = nil;
                    end
                    return true;
                end
                return false
            end
        end
    else
        jShared.log:warn(string.format("Inventory:removeItem(): Inventory: [%s] item [%s] item not found", self.id, item.name));
    end
end

---@param itemName string
function Inventory:getItemCount(itemName)
    local count = 0;
    if (self:hasItem(itemName)) then
        for i = 1, #self.items do
            if (self.items[i]:getName() == itemName) then
                count = count + self.items[i]:getCount();
            end
        end
        return count;
    end
    return 0;
end

---@param itemName string
---@return Item
function Inventory:getItem(itemName)
    for i = 1, #self.items[itemName] do
        if (self.items[i]:getName() == itemName) then
            if (self.items[i]:hasItems()) then
                return self.items[i]:getItem();
            end
        end
    end
    return nil;
end

---@param items Item[]
function Inventory:setItems(items)
    self.items = self:generateStack(items);
    self:getWeight();
end

---Clear inventory Items
function Inventory:clearItems()
    self.items = {};
    self:getWeight();
end

---@return boolean
function Inventory:isShared()
    return self.inventoryType == 1;
end

---@param value boolean
function Inventory:setShared(value)
    self.inventoryType = (value == true and 1) or 0;
end

---@param stackId number
function Inventory:getStack(stackId)
    return self.items[stackId];
end