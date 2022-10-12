--[[
--Created Date: Thursday September 22nd 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Thursday September 22nd 2022 11:35:53 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

---@type SWorld
SWorld = Class.extends(ServerModule, function(class)

    ---@class SWorld: ServerModule
    local self = class;

    function self:Constructor()
        self:super("World");
    end

    return self;
end);

---@type SWorld
GM.Server.modules.world = SWorld();

Package.Require("manifest.lua");