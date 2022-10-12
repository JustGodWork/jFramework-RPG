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

---@type RepositoryManager
local RepositoryManager = Class.new(function(class)
    
    ---@class RepositoryManager: BaseObject
    local self = class;

    function self:Constructor()
        self.repositories = {};
        GM.Server.log:debug("[ RepositoryManager ] initialized.");
    end
    
    ---@param name string
    ---@param Object table
    ---@return Repository | nil
    function self:Register(name, Object)
        if (not self.repositories[name]) then
            self.repositories[name] = Repository(name, Object);
            return self.repositories[name];
        else
            GM.Server.log:warn("RepositoryManager:register(): repository [ ".. name .." ] already exists");
            return nil;
        end
    end
    
    ---@param name string
    ---@param id string
    function self:Find(name, id)
        if (self.repositories[name]) then
            return self.repositories[name]:find(id);
        else
            GM.Server.log:warn("RepositoryManager:find(): repository [ ".. name .." ] not found");
            return nil;
        end
    end
    
    ---Save all repositories
    function self:SaveAll()
        for _, repository in pairs(self.repositories) do
            repository:save();
        end
    end

    return self;
end);

---@type RepositoryManager
GM.Server.repositoryManager = RepositoryManager();