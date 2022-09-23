--[[
--Created Date: Friday September 23rd 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Friday September 23rd 2022 3:33:03 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

---@class Log
local Log = {};

function Log:new()
    local self = {};
    setmetatable(self, { __index = Log});

    self.types = {
        ["info"] = "INFO",
        ["warn"] = "WARN",
        ["error"] = "ERROR",
        ["debug"] = "DEBUG",
        ["success"] = "SUCCESS",
    };

    return self;
end

function Log:getSide()
    if (Server and Client) then
        return "SHARED";
    elseif (Server) then
        return "SERVER";
    elseif (Client) then
        return "CLIENT";
    end
end

---@return table | nil
function Log:convertArgs(...)
    local args = {...};
    if (#args > 0) then
        for i = 1, #args do
            if (type(args[i]) == "table") then
                args[i] = NanosUtils.Dump(args[i]);
            elseif (type(args[i]) == "boolean" or type(args[i]) == "number") then
                args[i] = tostring(args[i]);
            end
        end
    else
        args = nil;
    end
    return args
end

function Log:convertMessage(logType, message, messageType, ...)
    local msg = string.format("[%s] => [%s] => %s", self:getSide(), self.types[logType], message)
    local args = self:convertArgs(...)
    if (messageType == "string" or messageType == "boolean" or messageType == "number") then
        if (messageType == "number" or messageType == "boolean") then 
            msg = string.format("[%s] => [%s] => %s", self:getSide(), self.types[logType], tostring(message))
        end
        if (args) then
            for i = 1, #args do
                msg = string.format("%s %s", msg, args[i]);
            end
        end
    elseif (messageType == "table") then
        msg = string.format("[%s] => [%s] => %s", self:getSide(), self.types[logType], NanosUtils.Dump(message));
        if (args) then
            for i = 1, #args do
                msg = string.format("%s %s", msg, args[i]);
            end
        end
    end
    return msg;
end

function Log:send(logType, message, ...)
    local msg = self:convertMessage(logType, message, type(message), ...);
    if (logType == "error") then
        Package.Error(msg)
    elseif (logType == "warn") then
        Package.Warn(msg)
    else
        Package.Log(msg)
    end
end

function Log:info(message, ...)
    self:send("info", message, ...);
end

function Log:warn(message, ...)
    self:send("warn", message, ...);
end

function Log:error(message, ...)
    self:send("error", message, ...);
end

function Log:debug(message, ...)
    if (Config.debug) then
        self:send("debug", message, ...);
    end
end

function Log:success(message, ...)
    self:send("success", message, ...);
end

jShared.log = Log:new();
