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
    ---@type PlayerManager
    local self = {}
    setmetatable(self, { __index = PlayerManager});

    ---@type Player[]
    self.players = {};

    if (Config.debug) then
        Package.Log("Server: [ PlayerManager ] initialized.");
    end
    
    return self;
end

---@param id string
---@return Player
function PlayerManager:getFromId(id)
    return self.players[id];
end

---@param name string
---@return Player
function PlayerManager:getFromName(name)
    for id, player in pairs(self.players) do
        if (player:GetName() == name) then
            return self.players[id];
        end
    end
end

---@param idenfitier string
---@return Player
function PlayerManager:getFromIdentifier(idenfitier)
    for id, player in pairs(self.players) do
        if (player:GetSteamID() == idenfitier) then
            return self.players[id];
        end
    end
end

---@param data table
---@param nanosPlayer Player
---@return Player
function PlayerManager:registerPlayer(data, nanosPlayer)
    nanosPlayer:onCreate(data);
    self.players[nanosPlayer:GetID()] = nanosPlayer;
    return self.players[nanosPlayer:GetID()];
end

---@param playerId number
function PlayerManager:removePlayer(playerId)
    local player = self.players[playerId];
    if (player) then
        Package.Log("Player [%s] %s removed from playerManager", player:GetSteamID(), player:getFullName())
        self.players[playerId] = nil;
    else
        Package.Log("Player [%s] not found in playerManager", playerId)
    end
end

---Remove all player from PlayerManager
function PlayerManager:removeAll()
    for id, _ in pairs(self.players) do
        self:removePlayer(id);
    end
end

---@return Player[]
function PlayerManager:getAll()
    return self.players;
end

jServer.playerManager = PlayerManager:new();