--[[
--Created Date: Tuesday September 20th 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Tuesday September 20th 2022 9:11:59 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

---@class StorageManager
local StorageManager = {}

function StorageManager:new()
    ---@type StorageManager
    local self = {}
    setmetatable(self, { __index = StorageManager});

    ---@type Storage[]
    self.storages = {};
    ---@type Storage[][]
    self.owned = {}

    jShared.log:debug("[ StorageManager ] initialized.");
    
    return self;
end

---@param id string
---@param name string
---@param label string
---@param owner string
---@param data table
---@param storageType number
---@return Storage
function StorageManager:register(id, name, label, owner, data, storageType)
    if (owner) then
        if (not self.owned[owner]) then
            self.owned[owner] = {};
        end
        if (not self.owned[owner][id]) then
            self.owned[owner][id] = Storage:new(id, name, label, owner, data, storageType);
            return self.owned[owner][id];
        else
            jShared.log:warn("StorageManager:register(): storage [ ".. name .." ] already exists");
            return nil;
        end
    elseif (not self.storages[id]) then
        self.storages[id] = Storage:new(id, name, label, owner, data, storageType);
        return self.storages[id];
    else
        jShared.log:warn("StorageManager:register(): storage [ ".. name .." ] already exists");
    end
end

---@param owner string
---@param accountName string
---@return Storage
function StorageManager:getByOwner(owner, accountName)
    local found = false;
    if (self.owned[owner]) then
        for storage, _ in pairs(self.owned[owner]) do
            local store = self.owned[owner][storage];
            if (store) then
                if (store.owner == owner and store.name == accountName) then
                    found = true;
                    return store;
                end
            end
        end
    else
        jShared.log:warn('StorageManager:getByOwner(): owner [ '.. owner ..' ] not found');
        return nil;
    end
    if (not found) then
        jShared.log:warn('StorageManager:getByOwner(): storage [ Owner: "'.. owner.. '" name: "'.. accountName ..'" ] not found');
        return nil;
    end
end

---@param id string id or name of storage
---@return Storage
function StorageManager:get(id)
    for storage, _ in pairs(self.storages) do
        local store = self.storages[storage];
        if (store:getId() == id or store:getName() == id) then
            return self.storages[storage];
        end
    end
end

jServer.storageManager = StorageManager:new();