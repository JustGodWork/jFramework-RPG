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
    self.owned = {}

    jShared.log:debug("[ AccountManager ] initialized.");
    
    return self;
end

---@param id string
---@param name string
---@param label string
---@param owner string
---@param money number
---@param accountType number
---@return Account
function AccountManager:register(id, name, label, owner, money, accountType)
    if (owner) then
        if (not self.owned[owner]) then
            self.owned[owner] = {};
        end
        if (not self.owned[owner][id]) then
            self.owned[owner][id] = Account:new(id, name, label, owner, money, accountType);
            return self.owned[owner][id];
        else
            jShared.log:warn("AccountManager:register(): account [ ".. name .." ] already exists");
            return nil;
        end
    elseif (not self.accounts[id]) then
        self.accounts[id] = Account:new(id, name, label, owner, money, accountType);
        return self.accounts[id];
    else
        jShared.log:warn("AccountManager:register(): account [ ".. name .." ] already exists");
    end
end

---@param owner string
---@param accountName string
---@return Account
function AccountManager:getByOwner(owner, accountName)
    local found = false;
    if (self.owned[owner]) then
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
        jShared.log:warn('AccountManager:getByOwner(): owner [ '.. owner ..' ] not found');
        return nil;
    end
    if (not found) then
        jShared.log:warn('AccountManager:getByOwner(): account [ Owner: "'.. owner.. '" name: "'.. accountName ..'" ] not found');
        return nil;
    end
end

---@param id string id or name of account
---@return Account
function AccountManager:get(id)
    for account, _ in pairs(self.accounts) do
        local acc = self.accounts[account];
        if (acc:getId() == id or acc:getName() == id) then
            return self.accounts[account];
        end
    end
end

jServer.accountManager = AccountManager:new();