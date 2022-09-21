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
    local self = {}
    setmetatable(self, { __index = AccountManager});

    ---@type Account[]
    self.accounts = {};

    if (Config.debug) then
        Package.Log("Server: [ AccountManager ] initialized.");
    end
    
    return self;
end

---@param id string
---@param name string
---@param owner string
---@param money number
---@param accountType number
---@return Account
function AccountManager:register(id, name, owner, money, accountType)
    if (not self.accounts[id]) then
        self.accounts[id] = Account:new(id, name, owner, money, accountType);
        return self.accounts[id];
    else
        Package.Warn("AccountManager:register(): account [ ".. name .." ] already exists");
    end
end

---@param owner string
---@param accountName string
---@return Account
function AccountManager:getByOwner(owner, accountName)
    local found = false;
    for account, _ in pairs(self.accounts) do
        local acc = self.accounts[account];
        if (acc) then
            if (acc.owner == owner and acc.name == accountName) then
                found = true;
                return acc;
            end
        end
    end
    if (not found) then
        Package.Warn('AccountManager:getByOwner(): account [ Owner: "'.. owner.. '" name: "'.. accountName ..'" ] not found');
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