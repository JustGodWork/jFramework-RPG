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
    self._hud = WebUI("hud", "file://framework/ui/hud/hud.html", true);

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

---@return WebUI
function _Client:hud()
    return self._hud;
end

jClient = _Client:new()

Events.Subscribe("onPlayerConnecting", function()
    jShared.log:success("Client data initialized.");
    -- This event is called when the player is loaded
    -- You can use it to load modules only when player is loaded
    Client.SendChatMessage("All your data have been loaded !")
end)

Package.Require("./loader.lua");