--[[
--Created Date: Tuesday September 20th 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Tuesday September 20th 2022 7:54:42 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

---@class Repository 
Repository = {}

function Repository:new(name)
    local self = {}
    setmetatable(self, { __index = Repository});

    self.name = name;

    if (Config.debug) then
        Package.Log("Server: [Repository: ".. name .."] initialized.");
    end

    return self;
end