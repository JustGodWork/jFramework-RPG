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

    self.modules = {};

    ---@param module string
    function self:loadFrameworkModule(module)
        Package.Require(string.format("./framework/%s", module));
    end

    ---@param module string
    function self:loadModule(module)
        Package.Require(string.format("./modules/%s", module));
    end

    function _Server:disclaimer()
        if (Config.disclaimer) then
            Package.Warn(string.format("\n%s",[[
                --------------------------------------------------------------
                -   Before you start, set up the config file                 -
                -   in Shared\Config.lua                                     -   
                -   after that execute jFramework.sql in your database       -
                -   you can now stop showing this disclaimer by setting      -
                -   Config.disclaimer to false in Shared\Config.lua          -
                -   Enjoy jFramework !                                       -
                --------------------------------------------------------------
            ]]));
        end
    end

    self:disclaimer();

    jShared.log:debug("[ jServer ] initialized.");

    return self
end

jServer = _Server:new();

Package.Require("./loader.lua");

