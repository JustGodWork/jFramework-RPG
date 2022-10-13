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

--_GM
Package.Require("_GM.lua");

--Database
Package.Require("Managers/Database/MySQL.lua");

---@type _Server
local _Server = Class.extends(Shared, function(class)

    ---@class _Server: Shared
    local self = class;

    function self:Constructor()
        self:super();
        if (not Config.disclaimer) then
            self.MySQL = MySQL();
            if (self.MySQL:IsOpen()) then
                self.alive = true;
                Package.Require("Managers/manifest.lua");
            else
                self:Delete();
            end
        end
    end
    
    ---@private
    function self:LoadManagers()
        self.CommandManager = CommandManager();
        self.InventoryManager = InventoryManager();
        self.ItemManager = ItemManager();
        self.PlayerManager = PlayerManager();
        self.VehicleManager = VehicleManager();
        self.utils = {};
        self.utils.Entity = Entity();
    end

    ---@private
    function self:LoadModules()
        Package.Require("modules/Modules.lua");
    end

    ---@private
    function self:Initialize()
        if (self.alive) then
            self:LoadManagers();
            self:LoadModules();
        end
    end

    return self;
end);

GM.Server = _Server();
GM.Server:Initialize();