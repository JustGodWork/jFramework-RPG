--[[
--Created Date: Tuesday September 20th 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Tuesday September 20th 2022 7:51:46 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

---@class RepositoryManager
local RepositoryManager = {}

---@return RepositoryManager
function RepositoryManager:new()
    ---@type RepositoryManager
    local self = {}
    setmetatable(self, { __index = RepositoryManager});

    self.repositories = {};

    if (Config.debug) then
        Package.Log("Server: [ RepositoryManager ] initialized.");
    end
    
    return self;
end

jServer.repositoryManager = RepositoryManager:new();