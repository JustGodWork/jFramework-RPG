--[[
--Created Date: Thursday September 22nd 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Thursday September 22nd 2022 3:35:39 am
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

---@type _Client
local _Client = Class.extends(Shared, function(class)

    ---@class _Client: Shared
    local self = class;

    function self:Constructor()
        self:super();
        Client.InitializeDiscord(Config.discord.APPLICATION_ID); -- Initialize application id
        self.modules = {};
        GM.Log:debug("[ Client ] initialized.");
    end

    ---@private
    function self:LoadManagers()
        Package.Require("framework/manifest.lua");
    end

    ---@private
    function self:LoadModules()
        Package.Require("modules/manifest.lua");
        self.modules.world = cWorld();
    end

    ---@private
    function self:Initialize()
       self:LoadManagers();
       self:LoadModules();
    end

    return self;
end)

GM.Client = _Client();
GM.Client:Initialize();
