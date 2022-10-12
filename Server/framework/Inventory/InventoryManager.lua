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

---@type InventoryManager
local InventoryManager = Class.new(function(class)
    
    ---@class InventoryManager: BaseObject
    local self = class;

    function self:Constructor()
        ---@type Inventory[]
        self.inventories = {};
        ---@type Inventory[][]
        self.owned = {};
    
        GM.Server.mysql:Query([[
            CREATE TABLE IF NOT EXISTS inventories (
                id INT(11) NOT NULL AUTO_INCREMENT,
                name VARCHAR(255) NOT NULL,
                label VARCHAR(255) NOT NULL,
                owner VARCHAR(255) NOT NULL,
                shared INT(11) NOT NULL,
                maxWeight FLOAT NOT NULL,
                slots INT(11) NOT NULL,
                PRIMARY KEY (id)
            ) ENGINE=InnoDB DEFAULT CHARSET=latin1
        ]])
    
        GM.Server.mysql:Query([[
            CREATE TABLE IF NOT EXISTS inventories_items (
                id INT(11) NOT NULL AUTO_INCREMENT,
                inventoryId INT(11) NOT NULL,
                name VARCHAR(255) NOT NULL,
                durability FLOAT NULL,
                description LONGTEXT NULL,
                level FLOAT NULL,
                amount INT(11) NOT NULL DEFAULT 0,
                slot INT(11) NOT NULL,
                PRIMARY KEY (id)
            ) ENGINE=InnoDB DEFAULT CHARSET=latin1
        ]])
    
        self:Initialize();
    
        GM.Server.log:debug("[ InventoryManager ] initialized.");
    
        return self;
    end
    
    ---@private 
    ---Load all inventories from database
    function self:Initialize()
        GM.Server.mysql:Select("SELECT * FROM inventories", {}, function(result)
            for _, row in pairs(result) do
                if (row) then
                    if (row.shared == 1) then
                        self:Register(row.id, row.name, row.label, row.owner, row.maxWeight, row.slots, row.shared);
                        GM.Server.log:debug("[ InventoryManager ] Loaded inventory " .. row.name .. " with id " .. row.id);
                    end
                end
            end
        end)
    end
    
    ---@param owner string
    ---@param name string
    ---@param callback? fun(inventoryLoaded: boolean, inventory: Inventory)
    function self:LoadOwned(owner, name, callback)
        GM.Server.mysql:Select("SELECT * FROM inventories WHERE owner = ? AND name = ?", { owner, name }, function (result)
            if (#result > 0) then
                local inventoryLoaded = self:Register(result[1].id, result[1].name, result[1].label, result[1].owner, result[1].maxWeight, result[1].slots, result[1].shared)
                local inventory = self:GetByOwner(owner, name);
                if (callback) then callback(inventoryLoaded, inventory); end;
            end
        end)
    end
    
    ---@param id number
    ---@param name string
    ---@param label string
    ---@param owner string
    ---@param maxWeight number
    ---@param slots number
    ---@param shared boolean
    function self:Register(id, name, label, owner, maxWeight, slots, shared)
        if (owner) then
            if (not self.owned[owner]) then
                self.owned[owner] = {};
            end
            if (not self.owned[owner][id]) then
                self:BuildInventory(id, name, label, owner, maxWeight, slots, shared, true);
                return true;
            else
                GM.Server.log:warn("InventoryManager:register(): inventory [ ".. name .." ] already exists");
                return false;
            end
        else
            if (not self.inventories[id]) then
                self:BuildInventory(id, name, label, owner, maxWeight, slots, shared, false);
                return true;
            else
                GM.Server.log:warn("InventoryManager:register(): inventory [ ".. name .." ] already exists");
                return false;
            end
        end
    end
    
    ---@param id number | string id or name of inventory
    ---@return boolean
    function self:Remove(id)
        for inventoryId, value in pairs(self.inventories) do
            if (inventoryId == id or value.name == id) then
                self.inventories[inventoryId] = nil;
                return true;
            end
        end
        return false;
    end
    
    ---@param owner string
    ---@param name string
    ---@return boolean
    function self:RemoveByOwner(owner, name)
        if (self.owned[owner]) then
            for k, v in pairs(self.owned[owner]) do
                if (v.name == name) then
                    self.owned[owner][k] = nil;
                    return true;
                end
            end
        end
        return false;
    end
    
    ---@param owner string
    function self:RemoveAllByOwner(owner)
        if (self.owned[owner]) then
            self.owned[owner] = nil;
        end
    end
    
    ---@param owner number
    ---@param inventoryName? string
    ---@return Inventory | nil
    function self:GetByOwner(owner, inventoryName)
        local found = false;
        if (self.owned[owner]) then
            if (inventoryName) then
                for inventory, _ in pairs(self.owned[owner]) do
                    local inv = self.owned[owner][inventory];
                    if (inv) then
                        if (inv.owner == owner and inv.name == inventoryName) then
                            found = true;
                            return inv;
                        end
                    end
                end
            else
                return self.owned[owner];
            end
        else
            GM.Server.log:warn('InventoryManager:getByOwner(): owner [ '.. owner ..' ] not found');
            return nil;
        end
        if (not found) then
            GM.Server.log:warn('InventoryManager:getByOwner(): inventory [ Owner: "'.. owner.. '" name: "'.. inventoryName ..'" ] not found');
            return nil;
        end
    end
    
    ---@param inventory Inventory
    ---@param owner string
    ---@return void
    function self:SetOwner(inventory, owner)
        if (inventory) then
            if (self.inventories[inventory:GetId()]) then
                self.inventories[inventory:GetId()]:SetOwner(owner);
                self.owned[inventory:GetOwner()][inventory:getId()] = self.inventories[inventory:GetId()];
                self.inventories[inventory:GetId()] = nil;
            elseif (self.owned[inventory:GetOwner()][inventory:GetId()]) then
                local lastOwner = inventory:GetOwner();
                self.owned[lastOwner][inventory:GetId()]:SetOwner(owner);
                self.owned[owner][inventory:GetId()] = self.owned[inventory:GetOwner()][inventory:GetId()];
                self.owned[lastOwner][inventory:GetId()] = nil;
            else
                GM.Server.log:warn('InventoryManager:setOwner(): inventory [ '.. inventory ..' ] not found');
            end
        end
    end
    
    ---@param id string id or name of Inventory
    ---@return Inventory
    function self:Get(id)
        for inventory, _ in pairs(self.inventories) do
            local inv = self.inventories[inventory]
            if (inv:GetId() == id or inv:GetName() == tostring(id)) then
                return inv;
            end
        end
    end
    
    ---@param name string
    ---@param label string
    ---@param owner number
    ---@param maxWeight number
    ---@param slots number
    ---@param shared number
    function self:Create(name, label, owner, maxWeight, slots, shared)
        GM.Server.mysql:Query("INSERT INTO inventories (name, label, owner, maxWeight, slots, shared) VALUES (?, ?, ?, ?, ?, ?)", {
            name,
            label,
            owner,
            maxWeight,
            slots,
            shared
        }, function()
            self:Register(name, owner);
        end)
    end
    
    ---@param name string
    ---@param owner string
    ---@param callback fun(success: boolean)
    function self:Delete(name, owner, callback)
        local query = "DELETE FROM inventories WHERE name = ?";
        if (self:Exist(name, owner)) then
            if (owner) then 
                query = query .. " AND owner = ?"; 
            end
            GM.Server.mysql:Query(query, {
                name,
                owner
            }, function(affected)
                if (affected == 1) then
                    if (owner) then
                        callback(self:RemoveByOwner(owner, name));
                    else
                        callback(self:Remove(name));
                    end
                else
                    local str = "InventoryManager:delete(): inventory [ ".. name .." ] not found"
                    if (owner) then str = str .. " for owner [ ".. owner .." ]"; end
                    GM.Server.log:warn(str);
                end
            end)
        end
    end
    
    ---@param name string
    ---@param owner string
    ---@return boolean
    function self:Exist(name, owner)
        if (owner) then
            if (self.owned[owner]) then
                return self.owned[owner][name] ~= nil;
            end
            return false;
        end
        for _, value in pairs(self.inventories) do
            if (value.name == name) then
                return true;
            end
        end
        return false;
    end
    
    ---@private
    ---@param id number
    ---@param name string
    ---@param label string
    ---@param owner string
    ---@param maxWeight number
    ---@param slots number
    ---@param shared number
    ---@param owned boolean
    function self:BuildInventory(id, name, label, owner, maxWeight, slots, shared, owned)
        local inventory = Inventory(id, name, label, owner, maxWeight, slots, shared)
        if (owned) then
            self.owned[owner][id] = inventory
        else
            self.inventories[name] = inventory
        end
    end
    
    ---@private
    ---@param steamId string
    function self:CreatePlayerInventories(steamId)
        local conf = Config.player.inventories
        self:Create("main", conf.main.label, steamId, conf.main.maxWeight, conf.main.slots, 0);
        if (#conf.others > 0) then
            for i = 1, #conf.others do
                local inv = conf.others[i];
                self:Create(inv.name, inv.label, steamId, inv.maxWeight, inv.slots, inv.shared);
            end
        end
    end

    return self;
end);

---@type InventoryManager
GM.Server.inventoryManager = InventoryManager();