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

---@class AccountManager
local InventoryManager = {}

function InventoryManager:new()
    local class = {};
    setmetatable(class, {__index = InventoryManager});

    self.inventories = jShared.utils.mapManager:register("inventories");

    Package.Log("Server: [ InventoryManager ] initialized.");

    return self;
end

---todo modify params
---@param id string
---@param name string
---@param owner string
---@param items Map
---@param inventoryType number
---@return Inventory
function InventoryManager:register(id, name, owner, money, inventoryType)
    local inventoryOwners = jShared.utils.mapManager:get("inventoriesOwners");
    if (owner) then
        if (not inventoryOwners or not inventoryOwners:get(owner)) then
            jShared.utils.mapManager:register(owner, "inventoriesOwners");
            inventoryOwners = jShared.utils.mapManager:get("inventoriesOwners");
        end
        inventoryOwners:get(owner):set(name, Inventory:new(id, name, owner, money, inventoryType));
        return inventoryOwners:get(owner):get(name);
    else
        self.inventories:set(name, Inventory:new(id, name, owner, money, inventoryType));
        return self.inventories:get(name);
    end
end

---@param owner string
---@param inventoryName string
---@param callback fun(inventory: Inventory)
function InventoryManager:getByOwner(owner, inventoryName, callback)
    local inventoryOwners = jShared.utils.mapManager:get("inventoriesOwners")
    if (inventoryOwners) then
        local inventories = inventoryOwners:get(owner)
        if (inventories) then
            inventories:foreach(function(name, inventory)
                if (inventory ~= nil and name == inventoryName) then
                    if (callback) then
                        callback(inventories:get(name));
                    end
                end
            end)
        end
    else
        return nil;
    end
end

---@param id string id or name of Inventory
---@return Inventory
function InventoryManager:get(id)
    self.inventories:values(function(data)
        if (data:getId() == id or data:getName() == id) then
            return self.inventories:get(data:getName());
        end
    end)
end

jServer.inventoryManager = InventoryManager:new();