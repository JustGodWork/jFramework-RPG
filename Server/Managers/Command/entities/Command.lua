--[[
--Created Date: Thursday September 22nd 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Thursday September 22nd 2022 7:11:28 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

---@type Command
Command = Class.new(function(class)

    ---@class Command: BaseObject
    local self = class;

    ---@param name string
    ---@param callback fun(player: Player | nil, args: string[])
    ---@param isClient boolean
    ---@return Command
    function self:Constructor(name, callback, isClient)
        self.name = name;
        self.callback = callback;
        self.client_only = isClient;
    end

    ---@return string
    function self:GetName()
        return self.name;
    end

    ---@return boolean
    function self:IsClient()
        return self.client_only;
    end

    ---@return fun(player: Player, args: string[])
    function self:GetCallback()
        return self.callback;
    end

    return self;
end);