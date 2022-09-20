--[[
--Created Date: Monday September 19th 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Monday September 19th 2022 8:37:33 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

---@class Map
Map = {}

---@param name string
---@param data table
---@return Map
function Map:new(name, data)
    local class = {}
    setmetatable(class, {__index = Map})
    
    self.name = name;
    self.data = data or {};

    return self;
end

---Get value for key
---@param key string
function Map:get(key)
    return self.data[key];
end

---Set value for key
---@param key string
---@param value any
function Map:set(key, value)
    self.data[key] = value;
end

---Remove value for key
---@param key string
function Map:remove(key)
    self.data[key] = nil;
end

---Check if data with key exist
---@param key string
function Map:contains(key)
    return self.data[key] ~= nil;
end

---@param cb fun(k: string, v: any)
function Map:foreach(cb)
    for k,v in pairs(self.data) do
        cb(k,v);
    end
end

---@param predicate fun(k: string, v: any):boolean
---@return Map
function Map:filter(predicate)
    for k,v in pairs(self.data) do
        if predicate(k,v) then
            self:set(k,v);
        end
    end
    return self;
end

---@param cb fun(value: any)
function Map:values(cb)
    for _, v in pairs(self.data) do
        cb(v);
    end
end

---@param cb fun(key: string)
function Map:keys(cb)
    for k, _ in pairs(self.data) do
        cb(k);
    end
end

---@param predicate fun(k: string, v: any):boolean
function Map:removeIf(predicate)
    for k,v in pairs(self.data) do
        if predicate(k,v) then
            self.data[k] = nil;
        end
    end
end

---Init data
---@param map table
function Map:setMap(map)
    self.data = map;
end

---@param cb function
function Map:sizeOf()
    local count = 0;
    for _, _ in pairs(self.data) do
        count = count + 1;
    end
    return count;
end