--[[
--Created Date: Friday September 23rd 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Friday September 23rd 2022 2:27:24 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

---@type cWorld
local cWorld = Class.new(function(class)
    
    ---@class cWorld: BaseObject
    local self = class;

    function self:Constructor()
        GM.Client.log:debug("[ cWorld ] initialized.");
    end

    return self;
end);

GM.Client.modules.world = cWorld();

Package.Require("manifest.lua");