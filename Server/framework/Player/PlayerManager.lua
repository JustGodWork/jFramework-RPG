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

---@type PlayerManager
local PlayerManager = Class.new(function(class)

    ---@class PlayerManager: BaseObject
    local self = class;

    function self:Constructor()
        ---@type Player[]
        self.players = {};

        GM.Server.mysql:Query([[
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

        self:SaveInterval();
        GM.Server.log:debug("[ PlayerManager ] initialized.");
    end

    ---@return Repository
    function self:Repository()
        return self._repository;
    end

    ---@param id number
    ---@return Player
    function self:GetFromId(id)
        return self.players[id];
    end

    ---@param name string
    ---@return Player
    function self:GetFromName(name)
        for id, player in pairs(self.players) do
            if (player:GetName() == name) then
                return self.players[id];
            end
        end
    end

    ---@param idenfitier string
    ---@return Player
    function self:GetFromIdentifier(idenfitier)
        for id, player in pairs(self.players) do
            if (player:GetSteamID() == idenfitier) then
                return self.players[id];
            end
        end
    end

    ---@param characterId number
    ---@return Player
    function self:GetByCharacterId(characterId)
        for playerId, player in pairs(self.players) do
            if (player:GetCharacterId() == characterId) then
                return self.players[playerId];
            end
        end
    end

    ---@private
    ---@param player Player
    ---@param callback function
    ---@private
    function self:CreateNewPlayer(player, callback)
        GM.Server.mysql:Query("INSERT INTO players (identifier) VALUES (?)", { player:GetSteamID() }, function(result)
            if (result == 1) then
                GM.Server.mysql:Select("SELECT * FROM players WHERE identifier = ?", { player:GetSteamID() }, function(result)
                    if (result) then
                        self:HandleConnection(player, result[1], true, callback);
                    end
                end)
            end
        end)
    end

    ---@param player Player
    function self:RegisterPlayer(player)
        GM.Server.mysql:Select("SELECT * FROM players WHERE identifier = ?", { player:GetSteamID() }, function(result)
            if (result[1]) then
                self:HandleConnection(player, result[1], false);
            else
                self:CreateNewPlayer(player);
            end
        end);
    end

    ---@private
    ---@param player Player
    ---@param isNew boolean
    function self:InitializePlayer(player, isNew)
        if (isNew) then
            GM.Server.inventoryManager:CreatePlayerInventories(player:GetSteamID());
        else
            GM.Server.inventoryManager:LoadOwned(player:GetSteamID(), "main");
        end
    end

    ---@private
    ---@param player Player
    ---@param data table
    ---@param isNew boolean
    ---@param callback function
    function self:HandleConnection(player, data, isNew, callback)
        self:InitializePlayer(player, isNew);
        player:OnConnect(data);
        self.players[player:GetID()] = player;
        GM.Server.log:info(("[ PlayerManager ] Player [%s] %s connected."):format(player:GetSteamID(), player:GetName()));
        Events.Call(SharedEnums.Player.connecting, player);
        if (callback) then callback(); end
    end

    ---@param playerToRemove Player
    function self:RemovePlayer(playerToRemove)
        local id = playerToRemove:GetID();
        local player = self.players[id];
        if (player) then
            local character = player:GetControlledCharacter();
            self:Save(player, function()
                if (character) then
                    character:Destroy();
                end
                self.players[id] = nil;
            end)
            GM.Server.log:info(string.format("Player [%s] %s removed from playerManager", player:GetSteamID(), player:GetFullName()))
        else
            GM.Server.log:info(string.format("Player [%s] not found in playerManager", playerId))
        end
    end

    ---@param player Player
    ---@param callback fun(result: boolean)
    function self:Save(player, callback)
        if (player) then
            local position = GM.Server.utils:ReduceVector(player:GetPosition(), true);
            local rotation = GM.Server.utils:ReduceRotator(player:GetRotation(), true);
            GM.Server.mysql:Query("UPDATE players SET posX = ?, posY = ?, posZ = ?, Yaw = ? WHERE id = ?", {
                position.X,
                position.Y,
                position.Z,
                rotation.Yaw,
                player:GetCharacterId()
            }, callback);
        end
    end

    ---Save all Players
    function self:SaveAll()
        for _, player in pairs(self.players) do
            self:Save(player);
        end
    end

    ---Save all players data
    ---@private
    function self:SaveInterval()
        Timer.SetTimeout(function()
            local count = 0;
            for _, player in pairs(self.players) do
                if (player) then
                    count = count + 1;
                    self:Save(player);
                end
            end
            if (count > 0) then
                GM.Server.log:info(("[ PlayerManager ] saved [%s] players."):format(count));
            end
            self:SaveInterval();
        end, Config.player.saveInterval * 1000 * 60);
    end

    ---Remove all player from PlayerManager
    function self:RemoveAll()
        for id, _ in pairs(self.players) do
            self:RemovePlayer(id);
        end
    end

    ---@return Player[]
    function self:GetAll()
        return self.players;
    end

    return self;
end);

---@type PlayerManager
GM.Server.playerManager = PlayerManager();