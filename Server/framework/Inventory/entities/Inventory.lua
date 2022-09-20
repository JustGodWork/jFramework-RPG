--[[
--Created Date: Tuesday August 2nd 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Tuesday August 2nd 2022 5:06:46 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

---@class Inventory
Inventory = {}

---@param name string
---@param owner string
---@param storeType number
---@param items Items[]
---@return Inventory
function Inventory:new(name, label, storeType, items, owner)
	local class = {}
	setmetatable(class, {__index = Inventory})
    
	self.name = name
	self.label = label
	self.owner = owner
	self.type = storeType
	self.items = items

	return self
end

---@return string
function Inventory:getName()
	return self.name
end

---@return string
function Inventory:getLabel()
	return self.label
end

---@return string | nil
function Inventory:getOwner()
	return self.owner
end

---@return number
function Inventory:getType()
	return self.type
end

 ---@return table
function Inventory:get()
	return self.items
end

 ---@param data table
function Inventory:set(data)
	self.items = data
	self:save()
end

---@param itemName string
function Inventory:hasItem(itemName)
    return self.items[itemName] ~= nil
end

---@param itemName string
---@param count number
function Inventory:addItem(itemName, count)
    local item = ItemManager:getItem(itemName)
    if item then
        if self:hasItem(itemName) then
            self.items[itemName].count = self.items[itemName].count + count
        else
			self.items[itemName] = {
				name = itemName,
				count = count,
				label = item.label,
				weight = item.weight,
				canRemove = item.canRemove,
				unique = item.unique
			}
        end
        self:save()
    end
end

---@param itemName string
---@param count number
function Inventory:removeItem(itemName, count)
    local item = ItemManager:getItem(itemName)
    if item then
        if self:hasItem(itemName) then
            if self.items[itemName].count - count <= 0 then
                self.items[itemName] = nil
            else
                self.items[itemName].count = self.items[itemName].count - count
            end
        end
        self:save()
    end
end

---@param itemName string
---@return table
function Inventory:getItem(itemName)
    return self.items[itemName]
end

function Inventory:save()
	MySQL.ready(function()
		MySQL.query('UPDATE addons_inventories SET items = @items WHERE name = @name', {
			['@name'] = self.name,
			['@items'] = json.encode(self.items)
		})
	end)
end