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

---@class ConnexionHandler
local ConnexionHandler = {}

---@return ConnexionHandler
function ConnexionHandler:new()
    ---@type ConnexionHandler
    local self = {}
    setmetatable(self, { __index = ConnexionHandler});

    self.players = {};

    if (Config.debug) then
        Package.Log("Server: [ConnexionHandler] initialized.");
    end

    return self;
end

---@param nanosPlayer Player
---@param callback fun(playerData: table | nil)
---@return table
function ConnexionHandler:requestData(nanosPlayer, callback)
    local identifier = nanosPlayer:GetSteamID();
    jServer.mysql:select("SELECT * FROM players WHERE identifier = ?", { identifier }, function (result)
        self.players[identifier] = result[1];
        callback(self.players[identifier]);
    end);
end

---@param nanosPlayer Player
---@param callback fun(player: Player)
function ConnexionHandler:handle(nanosPlayer, callback)
    local name = nanosPlayer:GetName();

    Package.Log("Server: [ConnexionHandler] Player ".. name .." connecting...");
    self:requestData(nanosPlayer, function(playerData)
        if (playerData) then
            self:connect(nanosPlayer, callback);
        else
            self:createPlayer(nanosPlayer, function(playerCreated)
                if (playerCreated) then
                    self:connect(nanosPlayer, callback);
                else
                    Package.Warn("Server: [ConnexionHandler] Player ".. name .." not created correctly !");
                end
            end)
        end
    end);
end

---@param nanosPlayer Player
---@param callback fun(player: Player)
function ConnexionHandler:connect(nanosPlayer, callback)
    local identifier = nanosPlayer:GetSteamID();
    local name = nanosPlayer:GetName();
    if (self.players[identifier]) then
        local data = self.players[identifier];
        Package.Log("Server: [ConnexionHandler] Player [%s] %s %s connected !", identifier, data.firstname, data.lastname);
        local player = jServer.playerManager:registerPlayer(data, nanosPlayer);
        self.players[identifier] = nil;
        if (callback) then
            callback(player);
        end
    else
        Package.Warn("Server: ConnexionHandler:connect() Player ".. name .." not created correctly !");
    end
end

---Create Player in database
---@param nanosPlayer Player
---@param callback fun(playerCreated: boolean)
function ConnexionHandler:createPlayer(nanosPlayer, callback)
    local identifier = nanosPlayer:GetSteamID();

    jServer.mysql:query("INSERT INTO players (identifier, firstname, lastname) VALUES (?, ?, ?)", { 
        identifier,
        "new",
        "player"
    }, function (result)
        if (result ~= 0) then
            self:requestData(nanosPlayer, function (playerData)
                Package.Log("Server: [ConnexionHandler] Player [%s] %s %s created !", identifier, playerData.firstname, playerData.lastname);
            end);
        end
        if (callback) then
            callback(result);
        end
    end);
end

jServer.connexionHandler = ConnexionHandler:new();