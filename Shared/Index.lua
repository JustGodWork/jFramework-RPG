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

---@class Shared
local Shared = {}

Package.Require("./Config.lua")

---@return Shared
function Shared:new()
    ---@type Shared
    local self = {}
    setmetatable(self, { __index = Shared});

    self.utils = {}

    ---@param module string
    function self:loadFrameworkModule(module)
        Package.Require(string.format("./framework/%s", module));
    end

    ---@param module string
    function self:loadModule(module)
        Package.Require(string.format("./modules/%s", module));
    end

    self:disclaimer();

    return self;
end

---@return boolean
function Shared:isDebugMode()
    return Config.debug
end

---@param bool boolean
function Shared:setDebugMode(bool)
    Config.debug = bool
end

---@return boolean
function Shared:isServer()
    return Server ~= nil
end

---@return boolean
function Shared:isClient()
    return Client ~= nil
end

---@param pattern string
---@return string
function Shared:uuid(pattern)
    local random = math.random
    local template = pattern and type(pattern) == "string" and pattern or 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%x', v)
    end)
end

---@param Object table
function Shared:printObject(Object)
    for k, v in pairs(Object) do
        if (type(v) ~= "function") then
            print("[ ".. k .. " ] =", JSON.stringify(v))
        end
    end
end

---@param module string
function Shared:loadModule(module)
    Package.Require(string.format("./modules/%s", module));
end

function Shared:disclaimer()
    if (Config.disclaimer) then
        Package.Warn(string.format("\n%s",[[
            --------------------------------------------------------------
            -   Before you start, set up the config file                 -
            -   in Shared\Config.lua,                                    -   
            -   after that create a blank database for jFramework.       -
            -   you can now stop showing this disclaimer by setting      -
            -   Config.disclaimer to false in Shared\Config.lua          -
            -   Enjoy jFramework !                                       -
            --------------------------------------------------------------
        ]]));
        Timer.SetTimeout(function()
            if (Server) then os.exit() end
        end, 0)
    end
end

jShared = Shared:new();

Package.Require("./loader.lua");

jShared.log:debug("[ jShared ] initialized.");