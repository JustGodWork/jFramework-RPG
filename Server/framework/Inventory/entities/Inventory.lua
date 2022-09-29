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

---@param id number
---@param name string
---@param label string
---@param owner string
---@param maxWeight number
---@param slots number
---@param shared number
function Inventory:new(id, name, label, owner, maxWeight, slots, shared)
    ---@type Inventory
    local self = {}
    setmetatable(self, { __index = Inventory});

    self.id = id;
    self.name = name;
    self.label = label;
    self.owner = owner;
    self.weight = 0;
    self.maxWeight = maxWeight;
    self.slots = slots;
    ---@type ItemStack[]
    self.items = {};
    self.shared = shared

    self:buildProcess(items);

    jShared.log:debug(("[ Inventory: %s ] initialized."):format(self.id));

    return self
end

---@return number
function Inventory:getNumberOfSlots()
    return self.slots;
end

---@private
---Return first free slot
---@return number | nil
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
    for i = 1, #self.items do
        if (self.items[i]) then
            if (self.items[i]:getName() == itemName) then
                ---@type ItemStack
                local stack = self.items[i];
                if (not stack:isFull()) then
                    return i;
                end
            end
        end
    end
    return nil;
end

---@private
---@param itemName string
---@param description string
---@param durability number
---@param level number
---@return number
function Inventory:getSlotWithItem(itemName, description, durability, level)
    for i = 1, #self.items do
        if (self.items[i].name == item.name) then
            if (self.items[i].description == description) then
                if (self.items[i].durability == durability) then
                    if (self.items[i].level == level) then
                        return i;
                    end
                end
            end
        end
    end
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
---@return ItemStack | nil, number
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
            return self.items[freeSlot], freeSlot;
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
            if (not self:createStack(itemFrom)) then
                return false;
            end
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

---@param itemWeight number
---@param amount number
---@return boolean
function Inventory:canCarryItem(itemWeight, amount)
    if (self:getMaxWeight() >= self:getWeight() + (itemWeight * amount)) then
        return true;
    end
    return false;
end

---@param stack ItemStack
---@param slot number
---@param amount number
---@param callback fun(success: boolean)
function Inventory:requestUpdate(stack, slot, amount, callback)
    jServer.mysql:query("UPDATE `inventories_items` SET `amount` = ? WHERE `inventoryId` = ? AND `slot` = ?", {
        amount, 
        self.id, 
        slot
    }, function(result)
        if (callback) then
            callback(result == 1);
        end
    end);
end

---@param stack ItemStack
---@param slot number
---@param amount number
---@param callback fun(success: boolean)
function Inventory:requestInsert(stack, slot, amount, callback)
    print("INSERT")
    jServer.mysql:query("INSERT INTO `inventories_items` (`inventoryId`, `slot`, `name`, `amount`, `description`, `durability`, `level`) VALUES (?, ?, ?, ?, ?, ?, ?)", {
        self.id, 
        slot, 
        stack:getName(), 
        amount, 
        stack:getDescription(), 
        stack:getDurability(), 
        stack:getLevel()
    }, function(result)
        if (callback) then
            callback(result == 1);
        end
    end);
end

---@private
---@param item ItemStack | table
---@param amount number
---@return ItemStack | nil, number | nil
function Inventory:addItemToStack(item, amount)
    local freeSpace = self:getFirstSlotWithFreeSpace(item.name);
    local slot;
    local stack;
    if (freeSpace) then
        print("FREE SPACE ", freeSpace)
        if (self:canCarryItem(item.weight, amount)) then
            stack, slot = self.items[freeSpace], freeSpace;
            return stack, slot;
        end
        return nil, nil;
    else
        print("CAN CARRY ", self:canCarryItem(item.weight, amount))
        if (self:canCarryItem(item.weight, amount)) then
            stack, slot = self:createStack(item);
            return stack, slot;
        end
        return nil, nil;
    end
    return nil, nil;
end

---@param item ItemStack | table
---@param amount number
---@return boolean | nil, number | nil
function Inventory:processStack(item, amount)
    local stack, slot = self:addItemToStack(item, amount);
    if (stack) then
        print("STACK VALID ! SLOT: ", slot);
        if (stack:hasMeta() and amount == 1) then
            print("STACK HAS META ! SLOT: ", slot);
            stack:add(1);
            return true, slot;
        elseif (stack:canCarryItem(amount)) then
            print("STACK CAN CARRY ITEM ! SLOT: ", slot);
            stack:add(amount);
            return true, slot;
        else
            print("STACK CANNOT CARRY ITEM ! SLOT: ", slot);
            if (self:getFreeSlot()) then
                print("FREE SLOT FOUND ! SLOT: ", slot);
                local space  = stack:getFreeSpace();
                local rest = amount - space;
                stack:add(space);
                self:processStack(item, rest);
            end
        end
    end
    print("STACK INVALID SNIFF ! SLOT: ", slot);
    return false, nil;
end

---@param item table
---@param amount number
---@param callback fun(success: boolean)
function Inventory:addItem(item, amount, callback)
    local managedItem = jServer.itemManager:getItem(item.name);
    local freeStack = self:getFirstSlotWithFreeSpace(managedItem.name);
    if (managedItem) then
        if (self.weight + item.weight <= self.maxWeight) then
            if (amount) then
                local stack, slot = self:processStack(item, amount);
                if (freeStack) then stack, slot = self.items[freeStack], freeStack; end
                if (stack) then
                    if (slot == freeStack) then
                        self:requestUpdate(self.items[slot], slot, amount, callback);
                    else
                        self:requestInsert(self.items[slot], slot, amount, callback);
                    end
                    return true;
                end
            end
        end
    end
    return false;
end

---@param slot number
---@param amount number
---@return boolean
function Inventory:removeItem(slot, amount)
    if (self.items[slot]) then
        if (self.items[slot]:remove(amount)) then
            self:updateWeight();
            return true;
        end
    end
    return false;
end

---Build inventory from database
function Inventory:buildProcess()
    jServer.mysql:select("SELECT * FROM `inventories_items` WHERE `inventoryId` = ?", { self.id }, function (items)
        if (#items > 0) then
            for _, item in pairs(items) do
                local managedItem = jServer.itemManager:getItem(item.name);
                if (managedItem) then
                    self.items[item.slot] = ItemStack:new(
                            item.name,
                            managedItem.label,
                            item.description,
                            item.amount,
                            managedItem.weight,
                            managedItem.maxSize,
                            item.durability,
                            item.maxDurability,
                            item.level,
                            item.maxLevel
                    );
                else
                    jServer.mysql:query("DELETE FROM `inventories_items` WHERE `inventoryId` = ? AND `slot` = ?", { self.id, item.slot });
                    jShared.log:warn("Invalid Item [" .. item.name .. "] has been deleted from inventory " .. self.id .. ".");
                end
            end
            self:updateWeight();
        end
    end);
end

---@return table
function Inventory:getItems()
    return self.items
end