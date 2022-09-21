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
    local self = {}
    setmetatable(self, { __index = Shared});

    self.utils = {}

    if (Config.debug) then
        Package.Log("Shared: [ jShared ] initialized.");
    end

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

---@param pattern  string
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

jShared = Shared:new();

Package.Require("./loader.lua");