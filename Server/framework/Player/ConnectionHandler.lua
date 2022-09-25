--[[
--Created Date: Wednesday September 21st 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Wednesday September 21st 2022 4:02:03 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

---@class ConnectionHandler
local ConnectionHandler = {}

---@return ConnectionHandler
function ConnectionHandler:new()
    ---@type ConnectionHandler
    local self = {}
    setmetatable(self, { __index = ConnectionHandler});

    self.players = {};

    jShared.log:debug("[ ConnectionHandler ] initialized.");

    return self;
end

---@param nanosPlayer Player
---@param callback fun(playerData: table | nil)
---@return table
function ConnectionHandler:requestData(nanosPlayer, callback)
    local identifier = nanosPlayer:GetSteamID();
    jServer.mysql:select("SELECT * FROM players WHERE identifier = ?", { identifier }, function(result)
        self.players[identifier] = result[1];
        if (callback) then
            callback(self.players[identifier]);
        end
    end);
end

---@param nanosPlayer Player
---@param callback? fun(player: Player)
function ConnectionHandler:handle(nanosPlayer, callback)
    local name = nanosPlayer:GetName();

    jShared.log:info("[ ConnectionHandler ] => Player ".. name .." connecting...");
    self:requestData(nanosPlayer, function(playerData)
        if (playerData) then
            self:connect(nanosPlayer, callback);
        else
            self:createPlayer(nanosPlayer, function(playerCreated)
                if (playerCreated) then
                    self:connect(nanosPlayer, callback);
                else
                    jShared.log:warn("[ConnectionHandler] => Player ".. name .." not created correctly !");
                end
            end)
        end
    end);
end

---@param nanosPlayer Player
---@param callback fun(player: Player)
function ConnectionHandler:connect(nanosPlayer, callback)
    local identifier = nanosPlayer:GetSteamID();
    local name = nanosPlayer:GetName();
    if (self.players[identifier]) then
        local data = self.players[identifier];
        local player = jServer.playerManager:registerPlayer(data, nanosPlayer);
        self:initPlayerData(player);
        Timer.SetTimeout(function()
            self.players[identifier] = nil;
            Events.Call("onPlayerConnecting", player);
            Events.CallRemote("playerLoaded", player);
            jShared.log:success(string.format("[ ConnectionHandler ] => Player [%s] %s %s connected !", identifier, data.firstname, data.lastname));
            if (callback) then
                callback(player);
            end
        end, 1000);
    else
        jShared.log:warn("ConnectionHandler:connect() Player ".. name .." not created correctly !");
    end
end

---Create Player in database
---@param nanosPlayer Player
---@param callback fun(playerCreated: boolean)
function ConnectionHandler:createPlayer(nanosPlayer, callback)
    local identifier = nanosPlayer:GetSteamID();

    jServer.mysql:query("INSERT INTO players (identifier, firstname, lastname) VALUES (?, ?, ?)", { 
        identifier,
        "new",
        "player"
    }, function(result)
        if (result ~= 0) then
            self:requestData(nanosPlayer, function (playerData)
                jShared.log:info(string.format("[ ConnectionHandler ] => Player [%s] %s %s created !", identifier, playerData.firstname, playerData.lastname));
                if (callback) then
                    callback(result);
                end
            end);
        end
    end);
end

---This is not the final state, where are wating for RepositoryManager to be done
---@param nanosPlayer Player
function ConnectionHandler:initPlayerData(nanosPlayer)
    local id = nanosPlayer:getCharacterId();
    jServer.mysql:select("SELECT * FROM accounts WHERE owner = ?", { id }, function(result)
        if (#result > 0) then
            for i = 1, #result do
                jServer.accountManager:register(result[i].name, id);
            end
        else
            for i = 1, #Config.player.accounts do
                local account = Config.player.accounts[i];
                if (account) then
                    jServer.accountManager:create(account.name, account.label, id, account.money, account.shared);
                end
            end
        end
    end);
    jServer.mysql:select("SELECT * FROM inventories WHERE owner = ?", { id }, function(result)
        if (#result > 0) then
            for i = 1, #result do
                jServer.inventoryManager:register(result[i].name, id);
            end
        else
            for i = 1, #Config.player.inventories do
                local inventory = Config.player.inventories[i];
                if (inventory) then
                    jServer.inventoryManager:create(inventory.name, inventory.label, id, inventory.maxWeight, inventory.shared);
                end
            end
        end
    end)
end

jServer.ConnectionHandler = ConnectionHandler:new();
