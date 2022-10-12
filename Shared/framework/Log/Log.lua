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

---@type Log
Log = Class.new(function(class)
    
    ---@class Log: BaseObject
    local self = class;

    function self:Constructor()
        self.types = {
            ["info"] = "INFO",
            ["warn"] = "WARN",
            ["error"] = "ERROR",
            ["debug"] = "DEBUG",
            ["success"] = "SUCCESS",
        };
    end

    ---Get wheter the script is running on the server or the client
    ---@private
    function self:getSide()
        if (Server) then
            return "SERVER";
        elseif (Client) then
            return "CLIENT";
        end
    end

    ---@private
    ---@param args table
    ---@return table | nil
    function self:convertArgs(args)
        local argsConverted = {};
        if (#args > 0) then
            for i = 1, #args do
                if (type(args[i]) == "table") then
                    argsConverted[i] = NanosUtils.Dump(args[i]);
                elseif (type(args[i]) == "boolean" or type(args[i]) == "number" or args[i] == nil or type(args[i]) == "string") then
                    argsConverted[i] = tostring(args[i]);
                end
            end
        else
            argsConverted = nil;
        end
        return argsConverted
    end

    ---@private
    ---@param logType string
    ---@param message any
    ---@param messageType type
    ---@param ... any
    function self:convertMessage(logType, message, messageType, ...)
        local msg = string.format("[%s] => [%s] => %s", self:getSide(), self.types[logType], message)
        local args = self:convertArgs({...})
        if (messageType == "string" or messageType == "boolean" or messageType == "number" or message == nil) then
            msg = string.format("[%s] => [%s] => %s", self:getSide(), self.types[logType], tostring(message))
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

    ---@private
    ---@param logType string
    ---@param message any
    ---@param ... any
    function self:send(logType, message, ...)
        local msg = self:convertMessage(logType, message, type(message), ...);
        if (logType == "error") then
            Package.Error(msg)
        elseif (logType == "warn") then
            Package.Warn(msg)
        else
            Package.Log(msg)
        end
    end

    ---@param message any
    ---@param ... any
    function self:info(message, ...)
        self:send("info", message, ...);
    end

    ---@param message any
    ---@param ... any
    function self:warn(message, ...)
        self:send("warn", message, ...);
    end

    ---@param message any
    ---@param ... any
    function self:error(message, ...)
        self:send("error", message, ...);
    end

    ---@param message any
    ---@param ... any
    function self:debug(message, ...)
        if (Config.debug) then
            self:send("debug", message, ...);
        end
    end

    ---@param message any
    ---@param ... any
    function self:success(message, ...)
        self:send("success", message, ...);
    end

    return self;
end);
