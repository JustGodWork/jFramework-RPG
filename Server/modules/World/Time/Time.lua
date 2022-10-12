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

--[[---@class Time: ServerModule
local Time = Class.Inherit(ServerModule);

function Time:Constructor()
    self.hour = 12;
    self.minute = 0;
    self.second = 0;
    self.freeze = false;

    self:Initialize();

    self:Start();
end

-- todo sync time when more than one player connect to server
function Time:Initialize()
    Events.Subscribe(SharedEnums.Player.connecting, function(player)
        Events.CallRemote(SharedEnums.Events.Time.sync, player, self.hour, self.minute)
    end)
end

---@return number, number
function Time:Get()
    return self.hour, self.minute;
end

---@return number
function Time:GetHour()
    return self.hour;
end

---@return number
function Time:GetMinute()
    return self.minute;
end

---Start time cycle
function Time:Start()
    Timer.SetInterval(function()
        self:Execute();
    end, (Config.Time.speed * 1000))
end

---Execute time cycle
function Time:Execute()
    if (self.freeze) then return end
    self.second = self.second + 1;
    if (self.second >= 60) then
        self.second = 0;
        self.minute = self.minute + 1;
        if (self.minute >= 60) then
            self.minute = 0;
            self.hour = self.hour + 1;
            if (self.hour >= Config.Time.hourFormat) then
                self.hour = 0;
            end
        end
    end
    --if (self.second == 0) then -- todo sync time when more than one player connect to server
        --self:sync();
    --end
end

function Time:Sync()
    print(string.format("Time: %s:%s", self.hour, self.minute))
    Events.BroadcastRemote(SharedEnums.Events.Time.sync, self.hour, self.minute)
end

---@type Time
GM.Server.modules.world.time = Time("Time");
]]
