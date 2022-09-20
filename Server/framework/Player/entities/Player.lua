--[[
--Created Date: Monday September 19th 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Monday September 19th 2022 8:49:45 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]


jPlayer = {}

---@param nanosPlayer Player
---@param data table
---@return jPlayer
function jPlayer:new(nanosPlayer, data)
    local class = {}
    setmetatable(class, {__index = jPlayer})

    local debug = jShared:isDebugMode()
    self.id = data.id or nil
    self.serverId = (debug and 1) or nanosPlayer:GetID()
    self.handler = (debug and {}) or nanosPlayer
    self.character = (debug and {}) or nanosPlayer:GetControlledCharacter()
    self.name = (debug and "JustGod") or nanosPlayer:GetName()
    self.firstname = data.firstname or "new"
    self.lastname = data.lastname or "Player"
    self.steamId = (debug and "11000013d019ee1") or nanosPlayer:GetSteamID()
    self.ip = (debug and "127.0.0.1") or nanosPlayer:GetIP()
    self.skin = (debug and "mp_m_freemode_01") or "mp_m_freemode_01"

    if (debug) then
        self.position = { x = 0.0, y = 0.0, z = 0.0, heading = 0.0 }
    else
        local coords = self.character:GetLocation()
        local heading = self.character:GetRotation()
        self.position = { x = coords.x, y = coords.y, z = coords.z, heading = heading}
    end

    Package.Log("Player [" .. self.name .. "] loaded.")
    return self
end

---@return Player
function jPlayer:getHandle()
    return self.handler
end

---Ban the current player
function jPlayer:ban()
    self.handler:Ban()
end

---@param reason string
function jPlayer:kick(reason)
    self.handler:Kick(reason)
end

---@return Character
function jPlayer:getCharacter()
    return self.character
end

---@param character Character
---@return Character
function jPlayer:setCharacter(character)
    self.handler:Process(character)
    self.character = self.handler:GetControlledCharacter()
    return self.character
end

---@return string
function jPlayer:getName()
    return self.name
end

---@param name string
---@return string
function jPlayer:setName(name)
    self.name = name
    return self.name
end

---@return number
function jPlayer:getId()
    return self.serverId
end

---@return string
function jPlayer:getSteamId()
    return self.steamId
end

---@return string
function jPlayer:getIp()
    return self.ip
end

