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

GM = {};

Package.Require("./manifest.lua");

---@type Shared
Shared = Class.new(function(class)

    ---@class Shared: BaseObject
    local self = class;

    function self:Constructor()
        self.log = Log();
        self.utils = Utils();
        self.utils.math = Math();
        self.utils.string = String();
        self.utils.thread = ThreadManager();
        self:Disclaimer();
        self.log:debug("[ Shared ] initialized.");
    end
    
    ---@return boolean
    function self:IsDebugMode()
        return Config.debug
    end
    
    ---@param bool boolean
    function self:SetDebugMode(bool)
        Config.debug = bool
    end
    
    ---@return boolean
    function self:IsServer()
        return Server ~= nil
    end
    
    ---@return boolean
    function self:IsClient()
        return Client ~= nil
    end
    
    ---@param pattern string
    ---@return string
    function self:Uuid(pattern)
        local random = math.random
        local template = pattern and type(pattern) == "string" and pattern or 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
        return string.gsub(template, '[xy]', function (c)
            local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
            return string.format('%x', v)
        end)
    end
    
    ---@param Object table
    function self:PrintObject(Object)
        for k, v in pairs(Object) do
            if (type(v) ~= "function") then
                print("[ ".. k .. " ] =", JSON.stringify(v))
            end
        end
    end
    
    function self:Disclaimer()
        if (Config.disclaimer) then
            Package.Warn(string.format("\n%s",[[
                ---------------------------------------------------------------------
                -   Before you start, set up the config file                        -
                -   in Shared\Config.lua,                                           -
                -   after that create a blank database for jFramework.              -
                -   you can now stop showing this disclaimer by setting             -
                -   Config.disclaimer to false in Shared\Config.lua                 -
                -   Enjoy jFramework !                                              -
                -                                                                   -
                -   About:                                                          -
                -   JFramework is a project that is made                            -
                -   for fun and learning.                                           -
                -   Github:                                                         -
                -   https://github.com/JustGodWork/jFramework-RPG                   -
                ---------------------------------------------------------------------
            ]]));
            if (Server) then Server.Stop(); end
        end
    end
    
    return self;
end);

---@type Shared
GM.Shared = Shared();