--[[
--Created Date: Monday September 19th 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Monday September 19th 2022 7:10:53 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

---@class _Server
local _Server = {}

---@return _Server
function _Server:new()
    local class = {}
    setmetatable(class, {__index = _Server});

    ---@param module string
    function self:loadFrameworkModule(module)
        Package.Require(string.format("./framework/%s", module));
    end

    ---@param module string
    function self:loadModule(module)
        Package.Require(string.format("./modules/%s", module));
    end

    Package.Log("Server: [jServer] initialized.");

    return self
end

jServer = _Server:new();

Package.Require("./loader.lua");
