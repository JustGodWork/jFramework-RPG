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

    jShared.log:debug("[ RepositoryManager ] initialized.");
    
    return self;
end

---@param name string
---@param Object table
---@return Repository | nil
function RepositoryManager:register(name, Object)
    if (not self.repositories[name]) then
        self.repositories[name] = Repository:new(name, Object);
        return self.repositories[name];
    else
        jShared.log:warn("RepositoryManager:register(): repository [ ".. name .." ] already exists");
        return nil;
    end
end

---@param name string
---@param id string
function RepositoryManager:find(name, id)
    if (self.repositories[name]) then
        return self.repositories[name]:find(id);
    else
        jShared.log:warn("RepositoryManager:find(): repository [ ".. name .." ] not found");
        return nil;
    end
end

---Save all repositories
function RepositoryManager:saveAll()
    for _, repository in pairs(self.repositories) do
        repository:save();
    end
end

jServer.repositoryManager = RepositoryManager:new();