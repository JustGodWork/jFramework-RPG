--[[
--Created Date: Tuesday September 20th 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Tuesday September 20th 2022 4:41:20 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

---@class RepositoryManager
local _RepositoryManager = {}

function _RepositoryManager:new()
    local class = {}
    setmetatable(class, {__index = _RepositoryManager})
    self.repositories = {}

    return self
end

---@param name string
---@param data table 
---@return Repository
function _RepositoryManager:register(name, data)
    self.repositories[name] = Repository:new(name, data)
    return self.repositories[name]
end

---@param name string
---@param data table
---@return Repository
function _RepositoryManager:registerIfNotExists(name, data)
    if self.repositories[name] == nil then
        self.repositories[name] = Repository:new(name, data)
    end
    return self.repositories[name]
end

---@param name string
---@return Repository
function _RepositoryManager:get(name)
    return self.repositories[name]
end

---@param name string
---@return boolean
function _RepositoryManager:exists(name)
    return self.repositories[name] ~= nil
end

---@param name string
function _RepositoryManager:remove(name)
    self.repositories[name] = nil
end

---Delete all data in repository
function _RepositoryManager:clear()
    self.repositories[name]:delete()
end

---Delete all data in all repositories
function _RepositoryManager:clearAll()
    for _, repository in pairs(self.repositories) do
        repository:delete()
    end
end

function _RepositoryManager:loadAll()
    for _, repository in pairs(self.repositories) do
        repository:createTable()
    end
end

jServer.repositoryManager = _RepositoryManager:new();