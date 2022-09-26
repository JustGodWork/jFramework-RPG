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

---@class AccountManager
local AccountManager = {}

function AccountManager:new()
    ---@type AccountManager
    local self = {}
    setmetatable(self, { __index = AccountManager});

    ---@type Account[]
    self.accounts = {};
    ---@type Account[][]
    self.owned = {};

    self._repository = jServer.repositoryManager:register("accounts", {
        { name = "name", type = "VARCHAR(255) NOT NULL" },
        { name = "label", type = "VARCHAR(255) NOT NULL" },
        { name = "owner", type = "INT(11) NOT NULL" },
        { name = "money", type = "INT(11) NOT NULL" },
        { name = "shared", type = "INT(11) NOT NULL DEFAULT 0" }
    });

    jShared.log:debug("[ AccountManager ] initialized.");
    
    return self;
end

---@return Repository
function AccountManager:repository()
    return self._repository;
end

---@param name string
---@param owner string
function AccountManager:register(name, owner)
    if (owner) then
        self:repository():prepare({ "owner", "name" }, { owner = owner, name = name }, function(result, success)
            if (success) then
                if (not self.owned[result[1].owner]) then
                    self.owned[owner] = {};
                end
                if (not self.owned[owner][result[1].id]) then
                    self.owned[owner][result[1].id] = Account:new(result[1].id, result[1].name, result[1].label, result[1].owner, result[1].money, result[1].shared);
                else
                    jShared.log:warn("AccountManager:register(): account [ ".. name .." ] already exists");
                end
            end
        end);
    else
        self:repository():prepare("name", name, function(result, success)
            if (success) then
                if (not self.accounts[result[1].id]) then
                    self.accounts[result[1].id] = Account:new(result[1].id, result[1].name, result[1].label, result[1].owner, result[1].money, result[1].shared);
                else
                    jShared.log:warn("AccountManager:register(): account [ ".. name .." ] already exists");
                end
            end
        end);
    end
end

---@param owner number
---@param accountName? string
---@return Account | nil
function AccountManager:getByOwner(owner, accountName)
    local found = false;
    if (self.owned[owner]) then
        if (accountName) then
            for account, _ in pairs(self.owned[owner]) do
                local acc = self.owned[owner][account];
                if (acc) then
                    if (acc.owner == owner and acc.name == accountName) then
                        found = true;
                        return acc;
                    end
                end
            end
        else
            return self.owned[owner];
        end
    else
        jShared.log:warn('AccountManager:getByOwner(): owner [ '.. owner ..' ] not found');
        return nil;
    end
    if (not found) then
        jShared.log:warn('AccountManager:getByOwner(): account [ Owner: "'.. owner.. '" name: "'.. accountName ..'" ] not found');
        return nil;
    end
end

---@param account Account
---@param owner number
---@return void
function AccountManager:setOwner(account, owner)
    if (account) then
        if (self.inventories[account:getId()]) then
            self.inventories[account:getId()].owner = owner;
            self:repository():save(self.accounts[account:getId()]);
        else
            jShared.log:warn('AccountManager:setOwner(): account [ '.. account:getId() ..' ] not found');
        end
    end
end

---@param id string id or name of Account
---@return Account
function AccountManager:get(id)
    for account, _ in pairs(self.accounts) do
        local acc = self.accounts[account]
        if (acc:getId() == id or acc:getName() == tostring(id)) then
            return acc;
        end
    end
end

---@param name string
---@param label string
---@param owner number
---@param money number
---@param shared number
---@param callback? function
function AccountManager:create(name, label, owner, money, shared, callback)
    self:repository():save({
        name = name,
        label = label,
        owner = owner,
        money = money,
        shared = shared
    }, function()
        self:register(name, owner);
        if (callback) then callback(); end
    end);
end

jServer.accountManager = AccountManager:new();