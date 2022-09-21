--[[
--Created Date: Tuesday September 20th 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Tuesday September 20th 2022 7:57:12 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

---@class PlayerManager
local PlayerManager = {}

---@return PlayerManager
function PlayerManager:new()
    local self = {}
    setmetatable(self, { __index = PlayerManager});

    ---@type jPlayer[]
    self.players = {};

    if (Config.debug) then
        Package.Log("Server: [ PlayerManager ] initialized.");
    end
    
    return self;
end

---@param id string
---@return jPlayer
function PlayerManager:getFromId(id)
    return self.players[id];
end

---@param name string
---@return jPlayer
function PlayerManager:getFromName(name)
    for id, player in pairs(self.players) do
        if (player:getName() == name) then
            return self.players[id];
        end
    end
end

---@param idenfitier string
---@return jPlayer
function PlayerManager:getFromIdentifier(idenfitier)
    for id, player in pairs(self.players) do
        if (player:getIdentifier() == idenfitier) then
            return self.players[id];
        end
    end
end

---@param data table
---@param nanosPlayer Player
function PlayerManager:registerPlayer(data, nanosPlayer)
    self.players[nanosPlayer:GetID()] = jPlayer:new(data, nanosPlayer);
end

---@param playerId number
function PlayerManager:removePlayer(playerId)
    self.players[playerId] = nil;
end

jServer.playerManager = PlayerManager:new();