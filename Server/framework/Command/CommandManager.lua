--[[
--Created Date: Thursday September 22nd 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Thursday September 22nd 2022 7:05:59 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

--- @class CommandManager
local CommandManager = {};

---@return CommandManager
function CommandManager:new()
    ---@type CommandManager
    local self = {};
    setmetatable(self, {__index = CommandManager})

    ---@type Command[]
    self.commands = {};

    self:constructor();

    return self
end

function CommandManager:constructor()
    Server.Subscribe("Chat", function(text, player)
        local index = text:sub(1, 1) == '/';
        local cmd = text:sub(2, (text:find(" ") and text:find(" ") - 1) or #text + 1);
        local args = text:sub(#cmd + 2, #text);
        if (index) then
            self:execute(cmd, player, jShared.utils.string:split(args, " "));
        end
        return false;
    end)

    Server.Subscribe("Console", function(text)
        local index = text:sub(1, 1) == '/';
        local cmd = text:sub(2, (text:find(" ") and text:find(" ") - 1) or #text + 1);
        local args = text:sub(#cmd + 2, #text);
        if (index) then
            self:execute(cmd, nil, jShared.utils.string:split(args, " "));
        end
        return false;
    end)
end

---@param name string
---@param callback fun(player: Player, args: string[])
---@param clientOnly boolean
function CommandManager:register(name, callback, clientOnly)
    self.commands[string.upper(name)] = Command:new(name, callback, clientOnly);
    jShared.log:debug(string.format("[ CommandManager ] => Command [%s] registered !", name));
end

---@param name string
---@param player Player
---@param args string[]
function CommandManager:onExecute(name, player, args)
    if (self.commands[string.upper(name)]:getCallback()(player, args)) then
        if (player) then
            jShared.log:debug(string.format("[ CommandManager ] => Command [%s] executed by [%s] %s", name, player:GetSteamID(), player:getFullName()));
        else
            jShared.log:debug(string.format("[ CommandManager ] => Command [%s] executed by console", name));
        end
    else
        if (player) then
            jShared.log:warn(string.format("[ CommandManager ] => Command [%s] failed to execute by [%s] %s", name, player:GetSteamID(), player:getFullName()));
        else
            jShared.log:warn(string.format("[ CommandManager ] => Command [%s] failed to execute by console", name));
        end
    end
end

---@param name string
---@param player Player
---@param args string[]
function CommandManager:execute(name, player, args)
    if (self:exists(string.upper(name))) then
        if (self.commands[string.upper(name)]:isClient() and not player) then
            return jShared.log:warn(string.format("[ CommandManager ] => Command [%s] can only be executed by a player !", name));
        end
        self:onExecute(name, player, args);
    else
        if (player) then
            Server.SendChatMessage(player, "<red>Command not found !</>");
        else
            jShared.log:info(string.format("[ CommandManager ] => Command [%s] not found !", name));
        end
    end
end

---@param name string
---@return Command
function CommandManager:get(name)
    return self.commands[string.upper(name)];
end

---@param name string
---@return boolean
function CommandManager:exists(name)
    return self.commands[string.upper(name)] ~= nil;
end

---@param name string
---@return void
function CommandManager:remove(name)
    self.commands[string.upper(name)] = nil;
end

jServer.commandManager = CommandManager:new();