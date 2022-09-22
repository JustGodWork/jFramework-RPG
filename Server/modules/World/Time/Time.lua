--[[
--Created Date: Thursday September 22nd 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Thursday September 22nd 2022 11:35:01 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

---@class Time = {}
local Time = {}

---@return Time
function Time:new()
    local self = {}
    setmetatable(self, { __index = Time});

    self.hour = 12;
    self.minute = 0;
    self.freeze = false;

    self:constructor();

    return self;
end

-- todo sync time when more than one player connect to server
function Time:constructor()
    Events.Subscribe("onPlayerConnecting", function(player)
        Events.CallRemote("jServer:modules:world:time:sync", player, self.hour, self.minute)
    end)
end

---@return number, number
function Time:get()
    return self.hour, self.minute;
end

---@return number
function Time:getHour()
    return self.hour;
end

---@return number
function Time:getMinute()
    return self.minute;
end

jServer.modules.world.time = Time:new();

