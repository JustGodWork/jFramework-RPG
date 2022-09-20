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
    local class = {}
    setmetatable(class, {__index = jPlayer});

    self.character_id = data.character_id;
    self.identifier = nanosPlayer:GetSteamID();
    self.id = nanosPlayer:GetID();
    self.handle = nanosPlayer;
    self.name = nanosPlayer:GetName();
    self.accounts = {};
    self.inventory = {};

    Package.Log("Server: [Player: ".. self.name .."] initialized.");

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

---@return Account[]
function jPlayer:getAccounts()
    return self.accounts;
end

---@return Inventory[]
function jPlayer:getInventory()
    return self.inventory;
end