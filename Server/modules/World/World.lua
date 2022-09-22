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

---@class jWorld
local jWorld = {}

---@return jWorld
function jWorld:new()
    local self = {}
    setmetatable(self, { __index = jWorld});
    return self;
end

jServer.modules.world = jWorld:new();

jServer:loadModule("World/loader.lua");