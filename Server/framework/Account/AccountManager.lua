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
    local class = {};
    setmetatable(class, {__index = AccountManager});

    self.accounts = jShared.utils.mapManager:register("accounts");

    return self;
end

---@param id string
---@param name string
---@param owner string
---@param money number
---@param accountType number
---@return Account
function AccountManager:register(id, name, owner, money, accountType)
    local accountsOwners = jShared.utils.mapManager:get("accountsOwners");
    if (owner) then
        if (not accountsOwners or not accountsOwners:get(owner)) then
            jShared.utils.mapManager:register(owner, "accountsOwners");
            accountsOwners = jShared.utils.mapManager:get("accountsOwners");
        end
        accountsOwners:get(owner):set(name, Account:new(id, name, owner, money, accountType));
        return accountsOwners:get(owner):get(name);
    else
        self.accounts:set(name, Account:new(id, name, owner, money, accountType));
        return self.accounts:get(name);
    end
end

---@param owner string
---@param accountName string
---@param callback fun(account: Account)
function AccountManager:getByOwner(owner, accountName, callback)
    local accountsOwners = jShared.utils.mapManager:get("accountsOwners")
    if (accountsOwners) then
        local accounts = accountsOwners:get(owner)
        if (accounts) then
            accounts:foreach(function(name, account)
                if (account ~= nil and name == accountName) then
                    if (callback) then
                        callback(accounts:get(name));
                    end
                end
            end)
        end
    else
        return nil;
    end
end

---@param id string id or name of account
---@return Account
function AccountManager:get(id)
    self.accounts:values(function(data)
        if (data:getId() == id or data:getName() == id) then
            return self.accounts:get(data:getName());
        end
    end)
end

jServer.accountManager = AccountManager:new();