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

    jServer.mysql:query([[
        CREATE TABLE IF NOT EXISTS `players` (
            `id` INT NOT NULL AUTO_INCREMENT,
            `identifier` VARCHAR(255) NOT NULL,
            `firstname` VARCHAR(255) NOT NULL DEFAULT 'new',
            `lastname` VARCHAR(255) NOT NULL DEFAULT 'Player',
            `skin` VARCHAR(255) NULL,
            `posX` VARCHAR(255) NULL,
            `posY` VARCHAR(255) NULL,
            `posZ` VARCHAR(255) NULL,
            `Yaw` VARCHAR(255) NULL,
            PRIMARY KEY (id)
        ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
    ]])

    self:saveInterval();
    jShared.log:debug("[ PlayerManager ] initialized.");
    
    return self;
end

---@return Repository
function PlayerManager:repository()
    return self._repository;
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

---@param characterId number
---@return Player
function PlayerManager:getByCharacterId(characterId)
    for playerId, player in pairs(self.players) do
        if (player:getCharacterId() == characterId) then
            return self.players[playerId];
        end
    end
end

---@private
---@param player Player
---@param callback function
---@private
function PlayerManager:createNew(player, callback)
    jServer.mysql:query("INSERT INTO players (identifier) VALUES (?)", { player:GetSteamID() }, function(result)
        if (result == 1) then
            jServer.mysql:select("SELECT * FROM players WHERE identifier = ?", { player:GetSteamID() }, function(result)
                if (result) then
                    player:onConnect({
                        id = result[1].id,
                        identifier = player:GetSteamID(),
                        firstname = "new",
                        lastname = "Player"
                    });
                    self.players[player:GetID()] = player;
                    Events.Call(SharedEnums.Player.connecting, player);
                    if (callback) then callback(); end
                end
            end)
        end
    end)
end

---@private
---@param player Player
function PlayerManager:loadPlayerInventories(player)
    jServer.mysql:select("SELECT * FROM players AS p JOIN inventories AS i ON p.identifier = i.owner WHERE identifier = ?", { player:GetSteamID() }, function(inventories)
        if (#inventories > 0) then
            player:SetValue("inventoryCount", #inventories)
            for i = 1, #inventories do
                jServer.inventoryManager:register(inventories[i].name, inventories[i].owner);
            end
        else
            for i = 1, #Config.player.inventories do
                jServer.inventoryManager:create(
                        Config.player.inventories[i].name,
                        Config.player.inventories[i].label,
                        player:GetSteamID(),
                        Config.player.inventories[i].maxWeight,
                        Config.player.inventories[i].slots,
                        Config.player.inventories[i].shared
                );
            end
        end
    end)
end

---@param player Player
function PlayerManager:initPlayer(player)
    self:loadPlayerInventories(player);
end

---@param player Player
function PlayerManager:registerPlayer(player)
    jServer.mysql:select("SELECT * FROM players WHERE identifier = ?", { player:GetSteamID() }, function(result)
        if (result[1]) then
            player:onConnect(result[1]);
            self.players[player:GetID()] = player;
            jShared.log:info(("[ PlayerManager ] Player [%s] %s connected."):format(player:GetSteamID(), player:GetName()));
            self:loadPlayerInventories(player);
            Events.Call(SharedEnums.Player.connecting, player);
        else
            self:createNew(player);
        end
    end);
end

---@param playerToRemove Player
function PlayerManager:removePlayer(playerToRemove)
    local id = playerToRemove:GetID();
    local player = self.players[id];
    if (player) then
        local character = player:GetControlledCharacter();
        self:save(player, function()
            if (character) then
                character:Destroy();
            end
            self.players[id] = nil;
        end)
        jShared.log:info(string.format("Player [%s] %s removed from playerManager", player:GetSteamID(), player:getFullName()))
    else
        jShared.log:info(string.format("Player [%s] not found in playerManager", playerId))
    end
end

---@param player Player
---@param callback fun(result: boolean)
function PlayerManager:save(player, callback)
    if (player) then
        local position = player:updatePosition();
        jServer.mysql:query("UPDATE players SET posX = ?, posY = ?, posZ = ?, Yaw = ? WHERE id = ?", {
            position.X,
            position.Y,
            position.Z,
            position.Yaw,
            player:getCharacterId()
        }, callback);
    end
end

---Save all Players
function PlayerManager:saveAll()
    for _, player in pairs(self.players) do
        self:save(player);
    end
end

---Save all players data
---@private
function PlayerManager:saveInterval()
    Timer.SetTimeout(function()
        local count = 0;
        for _, player in pairs(self.players) do
            if (player) then
                count = count + 1;
                self:save(player);
            end
        end
        if (count > 0) then
            jShared.log:info(("[ PlayerManager ] saved [%s] players."):format(count));
        end
        self:saveInterval();
    end, Config.player.saveInterval * 1000 * 60);
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