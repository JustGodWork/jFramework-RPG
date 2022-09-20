--[[
--Created Date: Monday September 19th 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Monday September 19th 2022 7:30:11 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

---@class PlayerManager
local _PlayerManager = {}

---@return PlayerManager
function _PlayerManager:new()
    local class = {}
    setmetatable(class, {__index = _PlayerManager})

    self.repository = jServer.repositoryManager:register("players", {
        skin = "",
        name = "newPlayer",
        firstname = "new",
        lastname = "player",
        steamId = "",
        ip = ""
    })
    self.players = jShared.utils.map:new("Players")
    self:constructor()

    return self
end

---@return void
function _PlayerManager:constructor()
    if (jShared:isDebugMode()) then -- Bypass Nanos connexion system
        Package.Warn("PlayerManager: Bypassing Nanos connexion system...")
        self:addPlayer({})
        return
    end
    -- Spawns and possess a Character when a Player joins the server
    Player.Subscribe("Spawn", function(nPlayer)
        local new_char = Character()
        nPlayer:Possess(new_char)
        self:addPlayer(nPlayer)
    end)

    -- Destroys the Character when the Player leaves the server
    Player.Subscribe("Destroy", function(nPlayer)
        local character = nPlayer:GetControlledCharacter()
        local player = self:getPlayer(nPlayer:GetId())
        if (character) then
            character:Destroy()
        end
        if (player) then
            self:removePlayer(player)
        end
    end)
    Package.Log("PlayerManager initialized")
end

---@param nanosPlayer Player
---@param callback fun(player: jPlayer)
function _PlayerManager:addPlayer(nanosPlayer, callback)
    local debug = jShared:isDebugMode()
    self.repository:find("steamId", (debug and "11000013d019ee1") or nanosPlayer:GetSteamID(), function (result)
        if (result) then
            self.players:set((debug and 1) or nanosPlayer:GetId(), jPlayer:new(nanosPlayer, {
                id = result.id,
                skin = result.skin,
                firstname = result.firstname,
                lastname = result.lastname,
            }))
        else
            self.players:set((debug and 1) or nanosPlayer:GetId(), jPlayer:new(nanosPlayer, {}))
        end
        local player = self.players:get((debug and 1) or nanosPlayer:GetId())
        if (player) then
            self.repository:save(player)
            Package.Log(string.format("Player [%s] has been added to the player manager.", player:getName()))
            if (callback) then
                callback(player)
            end
        else
            Package.Error("There was an error while adding the player to the player manager.")
            callback({})
        end
    end)
end

---@param playerId number
---@return void
function _PlayerManager:removePlayer(playerId)
    local player = self.players:get(playerId)
    if (player) then
        Package.Log(string.format("Player [%s] has been removed from the player manager.", player:getName()))
        self.players:remove(playerId)
    end
end

---@param playerId number
---@return jPlayer
function _PlayerManager:getPlayer(playerId)
    return self.players:get(playerId)
end

---@return Map
function _PlayerManager:getPlayers()
    return self.players
end

jServer.playerManager = _PlayerManager:new();

