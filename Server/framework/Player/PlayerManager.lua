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
    local class = {}
    setmetatable(class, {__index = PlayerManager});

    self.players = jShared.utils.mapManager:register("players");

    Package.Log("Server: [ PlayerManager ] initialized.");

    return self;
end

---@param id string
---@return jPlayer
function PlayerManager:getFromId(id)
    return self.players:get(id);
end

---@param name string
---@return jPlayer
function PlayerManager:getFromName(name)
    for _, player in pairs(self.players:getAll()) do
        if player:getName() == name then
            return self.players:get(player:getId());
        end
    end
end

---@param idenfitier string
---@return jPlayer
function PlayerManager:getFromIdentifier(idenfitier)
    for _, player in pairs(self.players:getAll()) do
        if player:getIdentifier() == idenfitier then
            return self.players:get(player:getId());
        end
    end
end

---@param data table
---@param nanosPlayer Player
function PlayerManager:registerPlayer(data, nanosPlayer)
    self.players:set(nanosPlayer:GetID(), jPlayer:new(data, nanosPlayer));
end

---@param playerId number
function PlayerManager:removePlayer(playerId)
    self.players:remove(playerId);
end

jServer.playerManager = PlayerManager:new();