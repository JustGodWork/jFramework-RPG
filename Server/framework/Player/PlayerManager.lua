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

    self.repository = jServer.repositoryManager:register("players", {
        { name = "identifier", type = "VARCHAR(255) NOT NULL" },
        { name = "firstname", type = "VARCHAR(255) NOT NULL" },
        { name = "lastname", type = "VARCHAR(255) NOT NULL" },
        { name = "skin", type = "VARCHAR(255)" },
        { name = "position", type = "LONGTEXT" },
        { name = "heading", type = "LONGTEXT" }
    })

    jShared.log:debug("[ PlayerManager ] initialized.");
    
    return self;
end

---@param id number
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
        jShared.log:info(string.format("Player [%s] %s removed from playerManager", player:GetSteamID(), player:getFullName()))
        self.players[playerId] = nil;
    else
        jShared.log:info(string.format("Player [%s] not found in playerManager", playerId))
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