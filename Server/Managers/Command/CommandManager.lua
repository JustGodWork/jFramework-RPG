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

---@type CommandManager
CommandManager = Class.new(function(class)

    ---@class CommandManager:  BaseObject
    local self = class;

    function self:Constructor()
        ---@type Command[]
        self.commands = {};
        self:Initialize();
    end
    
    ---@param text string
    function self:ToExecute(text)
        local index = text:sub(1, 1) == '/';
        local cmd = text:sub(2, (text:find(" ") and text:find(" ") - 1) or #text + 1);
        local args = text:sub(#cmd + 2, #text);
        return index, cmd, args
    end
    
    function self:Initialize()
        Server.Subscribe("Chat", function(text, player)
            local index, cmd, args = self:ToExecute(text);
            if (index) then
                self:Execute(cmd, player, GM.Utils.String:Split(args, " "));
            end
            return false;
        end)
    
        Server.Subscribe("Console", function(text)
            local index, cmd, args = self:ToExecute(text);
            if (index) then
                self:Execute(cmd, nil, GM.Utils.String:Split(args, " "));
            end
            return false;
        end)
    end
    
    ---@param name string
    ---@param callback fun(player: Player, args: string[])
    ---@param clientOnly boolean
    function self:Register(name, callback, clientOnly)
        self.commands[string.upper(name)] = Command(name, callback, clientOnly);
        GM.Log:debug(string.format("[ CommandManager ] => Command [%s] registered !", name));
    end
    
    ---@param name string
    ---@param player Player
    ---@param args string[]
    function self:OnExecute(name, player, args)
        if (self.commands[string.upper(name)]:GetCallback()(player, args)) then
            if (player) then
                GM.Log:debug(string.format("[ CommandManager ] => Command [%s] executed by [%s] %s", name, player:GetSteamID(), player:GetFullName()));
            else
                GM.Log:debug(string.format("[ CommandManager ] => Command [%s] executed by console", name));
            end
        else
            if (player) then
                GM.Log:warn(string.format("[ CommandManager ] => Command [%s] failed to execute by [%s] %s", name, player:GetSteamID(), player:GetFullName()));
            else
                GM.Log:warn(string.format("[ CommandManager ] => Command [%s] failed to execute by console", name));
            end
        end
    end
    
    ---@param name string
    ---@param player Player
    ---@param args string[]
    function self:Execute(name, player, args)
        if (self:Exist(string.upper(name))) then
            if (self.commands[string.upper(name)]:IsClient() and not player) then
                return GM.Log:warn(string.format("[ CommandManager ] => Command [%s] can only be executed by a player !", name));
            end
            self:OnExecute(name, player, args);
        else
            if (player) then
                Server.SendChatMessage(player, "<red>Command not found !</>");
            else
                GM.Log:info(string.format("[ CommandManager ] => Command [%s] not found !", name));
            end
        end
    end
    
    ---@param name string
    ---@return Command
    function self:Get(name)
        return self.commands[string.upper(name)];
    end
    
    ---@param name string
    ---@return boolean
    function self:Exist(name)
        return self.commands[string.upper(name)] ~= nil;
    end
    
    ---@param name string
    ---@return void
    function self:Remove(name)
        self.commands[string.upper(name)] = nil;
    end

    return self;
end);