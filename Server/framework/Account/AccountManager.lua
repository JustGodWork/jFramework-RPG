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

    jShared.log:debug("[ AccountManager ] initialized.");
    
    return self;
end

---@param id number
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

---@param owner number
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

---@param id number id or name of account
---@return Account
function AccountManager:get(id)
    for account, _ in pairs(self.accounts) do
        local acc = self.accounts[account];
        if (acc:getId() == id or acc:getName() == tostring(id)) then
            return self.accounts[account];
        end
    end
end

---@param name string
---@param label string
---@param owner number
---@param money number
---@param accountType number
---@param callback fun(success: boolean)
function AccountManager:create(name, label, owner, money, accountType, callback)
    jServer.mysql:query("INSERT INTO accounts (name, label, owner, money, shared) VALUES (?, ?, ?, ?, ?)", {
        name, 
        label, 
        owner, 
        money, 
        accountType
    }, function(success)
        if (success) then
            jServer.mysql:select("SELECT * FROM accounts WHERE owner = ? AND name = ?", { owner, name }, function(result)
                if (result) then
                    local acc = self:register(result[1].id, result[1].name, result[1].label, result[1].owner, result[1].money, result[1].shared);
                    if (owner) then
                        if (acc) then
                            jShared.log:info("AccountManager:create(): account [ Id: ".. acc:getId() .." Owner: ".. acc:getOwner() .." Name: ".. acc:getName() .." ] created");
                        else
                            jShared.log:warn("AccountManager:create(): account [ Owner: ".. owner .." Name: ".. name .." ] not created");
                        end
                    else
                        if (acc) then
                            jShared.log:info("AccountManager:create(): account [ Id: ".. acc:getId() .." Name: ".. acc:getName() .." ] created");
                        else
                            jShared.log:warn("AccountManager:create(): account [ Name: ".. name .." ] not created");
                        end
                    end
                    if (callback) then callback(acc ~= nil); end
                else
                    jShared.log:warn("AccountManager:create(): account [ ".. name .." ] not created");
                end
            end, name);
        else
            if (owner) then
                jShared.log:warn("AccountManager:create(): account [ Owner: ".. owner .." Name: ".. name .." ] not created");
            else
                jShared.log:warn("AccountManager:create(): account [ ".. name .." ] not created");
            end
            if (callback) then callback(false); end
        end
    end)
end

---@param id Player.character_id
---@param callback fun(success: boolean)
function AccountManager:initPlayer(id, callback)
    jServer.mysql:select("SELECT * FROM accounts WHERE owner = ?", { id }, function (result)
        if (#result > 0) then
            for i = 1, #result do
                self:register(
                    result[i].id,
                    result[i].name,
                    result[i].label, 
                    id,
                    result[i].money,
                    result[i].shared
                );
            end
            jShared.log:success("[ AccountManager ] => player [".. id .."] accounts initialized");
            if (callback) then callback(true); end
        else
            for i = 1, #Config.player.accounts do 
                local account = Config.player.accounts[i];
                self:create(
                    account.name,
                    account.label,
                    id,
                    account.money,
                    account.shared,
                    callback
                );
            end
        end
    end);
end

jServer.accountManager = AccountManager:new();