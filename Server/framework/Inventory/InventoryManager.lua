--[[
--Created Date: Tuesday September 20th 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Tuesday September 20th 2022 11:24:02 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

---@class InventoryManager
local InventoryManager = {}

---@return InventoryManager
function InventoryManager:new()
    setmetatable(InventoryManager, self)
    self.__index = self

    ---@type Inventory[]
    self.inventories = {};

    if (Config.debug) then
        Package.Log("Server: [ InventoryManager ] initialized.");
    end

    return InventoryManager;
end

---todo modify params
---@param id string
---@param name string
---@param owner string
---@param items Item[]
---@param inventoryType number
---@return Inventory
function InventoryManager:register(id, name, owner, items, inventoryType)
    if (not self.inventories[id]) then
        self.inventories[id] = Inventory:new(id, name, owner, items, inventoryType);
        return self.inventories[id];
    else
        Package.Warn("InventoryManager:register(): inventory [ ".. name .." ] already exists");
    end
end

---@param owner string
---@param inventoryName string
---@return Inventory
function InventoryManager:getByOwner(owner, inventoryName)
    local found = false;
    for inventory, _ in pairs(self.inventories) do
        local inv = self.accounts[inventory];
        if (inv) then
            if (inv.owner == owner and inv.name == inventoryName) then
                found = true;
                return inv;
            end
        end
    end
    if (not found) then
        Package.Warn('InventoryManager:getByOwner(): inventory [ Owner: "'.. owner.. '" name: "'.. inventoryName ..'" ] not found');
    end
end

---@param id string id or name of Inventory
---@return Inventory
function InventoryManager:get(id)
    for inventory, _ in pairs(self.inventories) do
        local inv = self.inventories[inventory]
        if (inv:getId() == id or inv:getName() == id) then
            return inv;
        end
    end
end

jServer.inventoryManager = InventoryManager:new();