--[[
--Created Date: Tuesday August 2nd 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Tuesday August 2nd 2022 5:06:34 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

---@class InventoryManager
local _InventoryManager = {}

---@return InventoryManager
function _InventoryManager:new()
    local class = {}
    setmetatable(class, {__index = _InventoryManager})
	
    self.inventories = jShared.utils.map:new("Inventories")
    self.sharedInventories = jShared.utils.map:new("SharedInventories")
	self.repository = jServer.repositoryManager:register("inventories", {
		name = "",
		label = "",
		owner = "",
		type = 0,
		items = {}
	})
    --self:init()

	Package.Log("InventoryManager initialized")
    return self
end

function _InventoryManager:init()
	MySQL.ready(function()
		MySQL.query('SELECT * FROM addons_inventories', {}, function(result)
			local count = 0
			for i = 1, #result do
				local name = result[i].name
				local label = result[i].label
				local shared = result[i].shared
				local items = json.decode(result[i].items)
				local owner = result[i].owner
				if shared == 0 and not self.inventories:get(name) then
					count = count + 1
					self.inventories:set(name, Inventory:new(name, label, shared, items or {}, owner))
				elseif shared == 1 and not self.sharedInventories:get(name) then
					count = count + 1
					self.sharedInventories:set(name, Inventory:new(name, label, shared, items or {}, owner))
				end
			end
			Console:info(("^7[^1InventoryManager^7]^4 %s ^3inventaires ont été charger avec succès ✔️"):format(count))
		end)
	end)
end

function _InventoryManager:newInventory(name, data, cb)
	data.items = (data.items and json.encode(data.items)) or nil
	if self.inventories:get(name) or self.sharedInventories:get(name) then
		if cb then cb(false) end
	end
	if data.shared == 0 then
		self.inventories:set(name, Inventory:new(name, data.label, data.shared, data.items or {}, data.owner))
	elseif data.shared == 1 then
		self.sharedInventories:set(name, Inventory:new(name, data.label, data.shared, data.items or {}, data.owner))
	end
	MySQL.insert("INSERT INTO addons_inventories (name, label, shared, items, owner) VALUES (@name, @label, @shared, @items, @owner)", {
		['@name'] = name,
		['@label'] = data.label,
		['@shared'] = data.shared,
		['@items'] = data.items or nil,
		['@owner'] = data.owner
	}, function()
		if cb then cb(true) end
	end)
end

function _InventoryManager:deleteInventory(name)
	if self.inventories:get(name) then
		self.inventories:remove(name)
	elseif self.sharedInventories:get(name) then
		self.sharedInventories:remove(name)
	end
	MySQL.query('DELETE FROM addons_inventories WHERE name = @name', {['@name'] = name})
end

---@return Inventory
function _InventoryManager:getInventory(name)
	return self.inventories:get(name)
end

---@return Map
function _InventoryManager:getInventories()
	return self.inventories
end

---@param name string
---@return Inventory
function _InventoryManager:getSharedInventory(name)
	return self.sharedInventories:get(name)
end

---@return Map
function _InventoryManager:getSharedInventories()
	return self.sharedInventories
end

jServer.inventoryManager = _InventoryManager:new();