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

---@class jClient
local _jClient = {}

---@return jClient
function _jClient:new()
    local self = {}
    setmetatable(self, { __index = _jClient});

    self.modules = {};

    ---@param module string
    function self:loadFrameworkModule(module)
        Package.Require(string.format("./framework/%s", module));
    end

    ---@param module string
    function self:loadModule(module)
        Package.Require(string.format("./modules/%s", module));
    end

    jShared.log:debug("[ jClient ] initialized.");

    return self;
end

jClient = _jClient:new()

Package.Require("./loader.lua");