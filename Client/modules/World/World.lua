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

---@class cWorld
local cWorld = {};

---@return cWorld
function cWorld:new()
    local self = {};
    setmetatable(self, { __index = cWorld});

    return self;
end

jClient.modules.world = cWorld:new();

jClient:loadModule("World/loader.lua");