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

---@class StorageManager
local _StorageManager = {}

---@return StorageManager
function _StorageManager:new()
	local class = {}
	setmetatable(class, {__index = _StorageManager})
	
	self.storages = jShared.utils.map:new("Storages")
	self.sharedStorages = jShared.utils.map:new("SharedStorages")
	self.repository = jServer.repositoryManager:register("Storages", {
		name = "",
		label = "",
		owner = "",
		type = 0,
		data = {}
	})

	--self:init()

	Package.Log("StorageManager initialized")
	return self
end

function _StorageManager:init()
	MySQL.ready(function()
		MySQL.query('SELECT * FROM addons_storages', {}, function(result)
			local count = 0
			for i = 1, #result do
				local name = result[i].name
				local label = result[i].label
				local shared = result[i].shared
				local data = json.decode(result[i].data)
				local owner = result[i].owner
				if shared == 0 and not self.storages:get(name) then
					count = count + 1
					self.storages:set(name, Storage:new(name, label, shared, data or {}, owner))
				elseif shared == 1 and not self.sharedStorages:get(name) then
					count = count + 1
					self.sharedStorages:set(name, Storage:new(name, label, shared, data or {}, owner))
				end
			end
			Console:info(("^7[^1StorageManager^7]^4 %s ^3stockages ont été charger avec succès ✔️"):format(count))
		end)
	end)
end

function _StorageManager:newStorage(name, data, cb)
	data.data = (data.data and json.encode(data.data)) or nil
	if self.storages:get(name) or self.sharedStorages:get(name) then
		if cb then cb(false) end
	end
	if data.shared == 0 then
		self.storages:set(name, Storage:new(name, data.label, data.shared, data.data or {}, data.owner))
	elseif data.shared == 1 then
		self.sharedStorages:set(name, Storage:new(name, data.label, data.shared, data.data or {}, data.owner))
	end
	MySQL.insert("INSERT INTO addons_storages (name, label, shared, data, owner) VALUES (@name, @label, @shared, @items, @owner)", {
		['@name'] = name,
		['@label'] = data.label,
		['@shared'] = data.shared,
		['@items'] = data.data or nil,
		['@owner'] = data.owner
	}, function()
		if cb then cb(true) end
	end)
end

function _StorageManager:deleteStorage(name)
	if self.storages:get(name) then
		self.storages:remove(name)
	elseif self.sharedStorages:get(name) then
		self.sharedStorages:remove(name)
	end
	MySQL.query('DELETE FROM addons_storages WHERE name = @name', {['@name'] = name})
end

---@return Storage
function _StorageManager:getStore(name)
	return self.storages:get(name)
end

---@return Map
function _StorageManager:getStores()
	return self.storages
end

---@param name string
---@return Storage
function _StorageManager:getSharedStore(name)
	return self.sharedStorages:get(name)
end

---@return Map
function _StorageManager:getSharedStores()
	return self.sharedStorages
end

jServer.storageManager = _StorageManager:new();