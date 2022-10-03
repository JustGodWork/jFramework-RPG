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
local _Client = {}

---@return jClient
function _Client:new()
    local self = {}
    setmetatable(self, { __index = _Client});

    self.modules = {};
    Client.SetMouseEnabled(false);

    jShared.log:debug("[ jClient ] initialized.");

    return self;
end

---@param module string
function _Client:loadFrameworkModule(module)
    Package.Require(string.format("./framework/%s", module));
end

---@param module string
function _Client:loadModule(module)
    Package.Require(string.format("./modules/%s", module));
end

jClient = _Client:new();

Package.Require("./loader.lua");