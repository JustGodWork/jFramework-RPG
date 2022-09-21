--[[
--Created Date: Tuesday September 20th 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Tuesday September 20th 2022 7:58:21 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

---@class jPlayer
jPlayer = {}

---@param data table
---@param nanosPlayer Player
---@return jPlayer
function jPlayer:new(data, nanosPlayer)
    ---@type jPlayer
    local self = {}
    setmetatable(self, { __index = jPlayer});

    self.character_id = data.id;
    self.identifier = nanosPlayer:GetSteamID();
    self.id = nanosPlayer:GetID();
    self.handle = nanosPlayer;
    self.name = nanosPlayer:GetName();
    self.firstname = data.firstname;
    self.lastname = data.lastname;
    self.position = data.position or Config.player.defaultPosition;
    ---@type Account[]
    self.accounts = {};
    ---@type Inventory[]
    self.inventories = {};

    if (Config.debug) then
        Package.Log("Server: [Player: ".. self.name .."] initialized.");
    end
    
    return self;
end

---@return number
function jPlayer:getCharacterId()
    return self.character_id;
end

---@return number
function jPlayer:getId()
    return self.id;
end

---@return Player
function jPlayer:getHandle()
    return self.handle;
end

---@return string
function jPlayer:getName()
    return self.name;
end

---@return string
function jPlayer:getFirstName()
    return self.firstname;
end

---@param name string
---@return void
function jPlayer:setFirstName(name)
    self.firstname = name;
end

---@return string
function jPlayer:getLastName()
    return self.lastname;
end

---@param name string
---@return void
function jPlayer:setLastName(name)
    self.lastname = name;
end

---@return string
function jPlayer:getFullName()
    if  (self.firstname == nil or self.lastname == nil) then
        return self.name;
    end
    return string.format("%s %s", self.firstname, self.lastname);
end

---@return Account[]
function jPlayer:getAccounts()
    return self.accounts;
end

---@param name string
function jPlayer:getAccount(name)
    return self.accounts[name];
end

---@return Inventory[]
function jPlayer:getInventories()
    return self.inventories;
end

---@param name string
---@return Inventory
function jPlayer:getInventory(name)
    return self.inventories[name];
end