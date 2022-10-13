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
        self.modules = {};
        Client.SetMouseEnabled(false);
        self.log:debug("[ Client ] initialized.");
    end

    return self;
end);

---@type _Client
GM.Client = _Client();

Package.Require("./manifest.lua");