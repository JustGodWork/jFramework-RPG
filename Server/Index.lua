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
    local self = {}
    setmetatable(self, { __index = _Server});

    self.database = {
        db = "jframework",
        user = "root",
        host = "localhost",
        port = 3307
    }

    self.modules = {};

    ---@param module string
    function self:loadFrameworkModule(module)
        Package.Require(string.format("./framework/%s", module));
    end

    ---@param module string
    function self:loadModule(module)
        Package.Require(string.format("./modules/%s", module));
    end

    jShared.log:debug("[ jServer ] initialized.");

    return self
end

jServer = _Server:new();

jServer:loadFrameworkModule("Database/MySQL.lua");

if (jServer.mysql:isOpen()) then
    Package.Require("./loader.lua");
end
