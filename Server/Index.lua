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

---@type _Server
local _Server = Class.extends(Shared, function(class)

    ---@class _Server: Shared
    local self = class;

    function self:Constructor()

        self:super();
        
        self.database = {
            db = "jframework",
            user = "root",
            host = "localhost",
            port = 3307
        }
    
        self.modules = {};
    
        self.log:debug("[ Server ] initialized.");
    end

    return self;
end);

if (not Config.disclaimer) then

    GM.Server = _Server();

    Package.Require("framework/Database/MySQL.lua");

    if (GM.Server.mysql:IsOpen()) then
        Package.Require("./manifest.lua");
    end
end