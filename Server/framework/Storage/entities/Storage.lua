--[[
--Created Date: Tuesday August 2nd 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Tuesday August 2nd 2022 3:39:50 am
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

---@class Storage
Storage = {}

---@param name string
---@param owner string
---@param storeType number
---@param data table
---@return Storage
function Storage:new(name, label, storeType, data, owner)
	local class = {}
	setmetatable(class, {__index = Storage})
	
	self.name = name
	self.label = label
	self.owner = owner
	self.type = storeType
	self.data = data or {}

	return self
end

---@return string
function Storage:getName()
	return self.name
end

---@return string
function Storage:getLabel()
	return self.label
end

---@return string | nil
function Storage:getOwner()
	return self.owner
end

---@return number
function Storage:getType()
	return self.type
end

 ---@return table
function Storage:get()
	return self.data
end

 ---@param data table
function Storage:set(data)
	self.data = data
	self:save()
end

 ---@param key string
 ---@param value any
function Storage:setData(key, value)
	self.data[key] = value
	self:save()
end

 ---@param key string
 ---@return any
function Storage:getData(key)
	return self.data[key]
end

function Storage:save()
	MySQL.ready(function()
		MySQL.query('UPDATE addons_storages SET data = @data WHERE name = @name', {
			['@name'] = self.name,
			['@data'] = json.encode(self.data)
		})
	end)
end