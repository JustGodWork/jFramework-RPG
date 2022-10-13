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
    
---@type Inventory
Inventory = Class.new(function(class)

    ---@class Inventory: BaseObject
    local self = class;

    ---@param id number
    ---@param name string
    ---@param label string
    ---@param owner string
    ---@param maxWeight number
    ---@param slots number
    ---@param shared number
    function self:Constructor(id, name, label, owner, maxWeight, slots, shared)
        self.id = id;
        self.name = name;
        self.label = label;
        self.owner = owner;
        self.weight = 0;
        self.maxWeight = maxWeight;
        self.slots = slots;
        ---@type ItemStack[]
        self.items = {};
        self.shared = shared;

        self:BuildProcess();

        GM.Log:debug(("[ Inventory: %s ] initialized."):format(self.id));
    end

    ---@return number
    function self:GetId()
        return self.id;
    end

    ---@return string
    function self:GetOwner()
        return self.owner;
    end

    ---@param newOwner string
    function self:SetOwner(newOwner)
        self.owner = newOwner;
    end

    ---@return number
    function self:GetNumberOfSlots()
        return self.slots;
    end

    ---@private
    ---Return first free slot
    ---@return number | nil
    function self:GetFreeSlot()
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
    function self:GetFirstSlotWithFreeSpace(itemName)
        for i = 1, #self.items do
            if (self.items[i]) then
                if (self.items[i]:GtName() == itemName) then
                    local stack = self.items[i];
                    if (not stack:IsFull()) then
                        return i;
                    end
                end
            end
        end
        return nil;
    end

    ---@private
    ---@param item table
    ---@param description string
    ---@param durability number
    ---@param level number
    ---@return number
    function self:GetSlotWithItem(item, description, durability, level)
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
    function self:GetMaxWeight()
        return self.maxWeight;
    end

    ---@return number
    function self:GetWeight()
        return self.weight;
    end

    ---@private
    ---Update Inventory weight
    ---@return number
    function self:UpdateWeight()
        local weight = 0;
        for i = 1, self.slots do
            if (self.items[i]) then
                weight = weight + self.items[i]:GetWeight();
            end
        end
        self.weight = weight;
    end

    ---@private
    ---@param item table
    ---@return ItemStack | nil, number
    function self:CreateStack(item, amount)
        local itemExist = GM.Server.ItemManager:Exist(item.name);
        local freeSlot = self:GetFreeSlot();
        if (itemExist) then
            if (freeSlot) then
                self.items[freeSlot] = ItemStack(
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
    function self:StackMetaEquals(stackOne, stackTwo)
        if (stackOne:GetDescription() == stackTwo:GetDescription()) then
            if (stackOne:GetDurability() == stackTwo:GetDurability()) then
                if (stackOne:GetLevel() == stackTwo:GetLevel()) then
                    return true;
                end
            end
        end
        return false;
    end

    ---@private
    ---@param stackFrom ItemStack
    ---@param stackTo ItemStack
    function self:SwitchStack(stackFrom, stackTo)
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
    function self:OnSwitchStackAmount(stackFrom, stackTo, amount)
        if (self.items[stackFrom]:GetAmount() - amount >= 0) then
            if (self.items[stackTo]:GetAmount() + amount <= stackTo:GetMaxSize()) then
                return true;
            end
        end
        return false;
    end

    ---@param stackToRemove ItemStack
    ---@param stackToAdd ItemStack
    ---@param amount number
    function self:SwitchStackAmount(stackToRemove, stackToAdd, amount)
        if (self:OnSwitchStackAmount(stackToRemove, stackToAdd, amount)) then
            self.items[stackToRemove]:Remove(amount);
            self.items[stackToAdd]:Add(amount);
        end
    end

    ---@param from number
    ---@param to number
    function self:ChangeStackSlot(from, to)
        if (self.items[from] and self.items[to]) then
            local itemFrom = self.items[from];
            local itemTo = self.items[to];
            if not (itemTo and itemTo <= self.slots) then
                if (not self:CreateStack(itemFrom)) then
                    return false;
                end
            else
                return false;
            end
            if (itemFrom:GetName() == itemTo:GetName()) then
                if (self:StackMetaEquals(itemFrom, itemTo)) then
                    if (itemTo:GetFreeSpace() >= itemFrom:GetAmount()) then
                        itemTo:GetAmount(itemFrom:GetAmount() + itemTo:GetAmount());
                        self.items[from] = nil;
                        return true;
                    else
                        local freeSpace = itemTo:GetFreeSpace();
                        itemTo:GetAmount(itemTo:GetMaxSize());
                        itemFrom:SetAmount(itemFrom:GetAmount() - freeSpace);
                        return true;
                    end
                else
                    self.items[itemTo] = nil;
                end
            else
                self:SwitchStack(itemFrom, itemTo);
                return true;
            end
        end
        return false;
    end

    ---@param itemWeight number
    ---@param amount number
    ---@return boolean
    function self:CanCarryItem(itemWeight, amount)
        if (self:GetMaxWeight() >= self:GetWeight() + (itemWeight * amount)) then
            return true;
        end
        return false;
    end

    ---@param stack ItemStack
    ---@param slot number
    ---@param amount number
    ---@param callback fun(success: boolean)
    function self:RequestUpdate(stack, slot, amount, callback)
        GM.Server.MySQL:Query("UPDATE `inventories_items` SET `amount` = ? WHERE `inventoryId` = ? AND `slot` = ?", {
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
    function self:RequestInsert(stack, slot, amount, callback)
        print("INSERT")
        GM.Server.MySQL:Query("INSERT INTO `inventories_items` (`inventoryId`, `slot`, `name`, `amount`, `description`, `durability`, `level`) VALUES (?, ?, ?, ?, ?, ?, ?)", {
            self.id, 
            slot, 
            stack:GetName(), 
            amount, 
            stack:GetDescription(), 
            stack:GetDurability(), 
            stack:GetLevel()
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
    function self:AddItemToStack(item, amount)
        local freeSpace = self:GetFirstSlotWithFreeSpace(item.name);
        local slot;
        local stack;
        if (freeSpace) then
            print("FREE SPACE ", freeSpace)
            if (self:CanCarryItem(item.weight, amount)) then
                stack, slot = self.items[freeSpace], freeSpace;
                return stack, slot;
            end
            return nil, nil;
        else
            print("CAN CARRY ", self:CanCarryItem(item.weight, amount))
            if (self:CanCarryItem(item.weight, amount)) then
                stack, slot = self:CreateStack(item);
                return stack, slot;
            end
            return nil, nil;
        end
        return nil, nil;
    end

    ---@param item ItemStack | table
    ---@param amount number
    ---@return boolean | nil, number | nil
    function self:ProcessStack(item, amount)
        local stack, slot = self:AddItemToStack(item, amount);
        if (stack) then
            print("STACK VALID ! SLOT: ", slot);
            if (stack:HasMeta() and amount == 1) then
                print("STACK HAS META ! SLOT: ", slot);
                stack:Add(1);
                return true, slot;
            elseif (stack:CanCarryItem(amount)) then
                print("STACK CAN CARRY ITEM ! SLOT: ", slot);
                stack:add(amount);
                return true, slot;
            else
                print("STACK CANNOT CARRY ITEM ! SLOT: ", slot);
                if (self:GetFreeSlot()) then
                    print("FREE SLOT FOUND ! SLOT: ", slot);
                    local space  = stack:GetFreeSpace();
                    local rest = amount - space;
                    stack:Add(space);
                    self:ProcessStack(item, rest);
                end
            end
        end
        print("STACK INVALID SNIFF ! SLOT: ", slot);
        return false, nil;
    end

    ---@param item table
    ---@param amount number
    ---@param callback fun(success: boolean)
    function self:AddItem(item, amount, callback)
        local managedItem = GM.Server.ItemManager:GetItem(item.name);
        local freeStack = self:GetFirstSlotWithFreeSpace(managedItem.name);
        if (managedItem) then
            if (self.weight + item.weight <= self.maxWeight) then
                if (amount) then
                    local stack, slot = self:ProcessStack(item, amount);
                    if (freeStack) then stack, slot = self.items[freeStack], freeStack; end
                    if (stack) then
                        if (slot == freeStack) then
                            self:RequestUpdate(self.items[slot], slot, amount, callback);
                        else
                            self:RequestInsert(self.items[slot], slot, amount, callback);
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
    function self:RemoveItem(slot, amount)
        if (self.items[slot]) then
            if (self.items[slot]:Remove(amount)) then
                self:UpdateWeight();
                return true;
            end
        end
        return false;
    end

    ---Build inventory from database
    function self:BuildProcess()
        GM.Server.MySQL:Select("SELECT * FROM `inventories_items` WHERE `inventoryId` = ?", { self.id }, function (items)
            if (#items > 0) then
                for _, item in pairs(items) do
                    local managedItem = GM.Server.ItemManager:GetItem(item.name);
                    if (managedItem) then
                        self.items[item.slot] = ItemStack(
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
                        GM.Server.MySQL:Query("DELETE FROM `inventories_items` WHERE `inventoryId` = ? AND `slot` = ?", { self.id, item.slot });
                        GM.Log:warn("Invalid Item [" .. item.name .. "] has been deleted from inventory " .. self.id .. ".");
                    end
                end
                self:UpdateWeight();
                GM.Log:debug("Inventory " .. self.id .. " has been built.");
            end
        end);
    end

    ---@return table
    function self:GetItems()
        return self.items
    end

    return self;
end);
