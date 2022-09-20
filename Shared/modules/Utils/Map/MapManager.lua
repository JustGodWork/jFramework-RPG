--[[
--Created Date: Tuesday September 20th 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Tuesday September 20th 2022 8:06:02 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

---@class MapManager
local MapManager = {}

---@return MapManager
function MapManager:new()
    local class = {}
    setmetatable(class, {__index = MapManager});

    self.maps = {};

    Package.Log("Shared: [MapManager] initialized.");
    
    return self;
end

---@param id string
---@param data? table
---@return Map
function MapManager:register(id, type, data)
    if not self.maps[type] then
        self.maps[type] = {};
    end
    self.maps[type][id] = Map:new(id, data);
    Package.Log("Map [ type: " .. type .. " Id: ".. id .. "] created.")
    return self.maps[type][id];
end

---@param id string
---@param type string
---@return Map
function MapManager:get(id, type)
    return self.maps[type][id];
end

---@return table
function MapManager:getAll()
    return self.maps;
end

---@param id string
---@return boolean
function MapManager:delete(id)
    for map, value in pairs(self.maps) do
        if value[id] then
            self.maps[map][id] = nil;
            return true
        end
    end
    return false
end

---Remove all maps
function MapManager:clear()
    self.maps = {};
end

jShared.utils.mapManager = MapManager:new();
