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
end

---@param name string
---@param callback fun(player: Player, args: string[])
function CommandManager:register(name, callback)
    self.commands[name] = Command:new(name, callback);
    jShared.log:info(string.format("[ CommandManager ] => Command [%s] registered !", name));
end

---@param name string
---@param player Player
---@param args string[]
function CommandManager:execute(name, player, args)
    if (self:exists(name)) then
        self.commands[name]:getCallback()(player, args);
        if (player) then
            jShared.log:info(string.format("[ CommandManager ] => Command [%s] executed by [%s] %s", name, player:GetSteamID(), player:getFullName()));
        else
            jShared.log:info(string.format("[ CommandManager ] => Command [%s] executed by console", name));
        end
    else
        if (player) then
            Server.SendChatMessage(player, "<red>[ CommandManager ] => Command not found !</>");
        else
            jShared.log:info(string.format("[ CommandManager ] => Command [%s] not found !", name));
        end
    end
end

---@param name string
---@return Command
function CommandManager:get(name)
    return self.commands[name];
end

---@param name string
---@return boolean
function CommandManager:exists(name)
    return self.commands[name] ~= nil;
end

---@param name string
---@return void
function CommandManager:remove(name)
    self.commands[name] = nil;
end

jServer.commandManager = CommandManager:new();