--[[
--Created Date: Tuesday August 2nd 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Tuesday August 2nd 2022 8:48:15 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

---@class Account
Account = {}

---@param name string
---@param owner string
---@param storeType number
---@param money table
---@return Account
function Account:new(name, label, storeType, money)
	local class = {}
	setmetatable(class, {__index = Account})
    
	self.name = name
	self.label = label
	self.type = storeType
	self.money = money

	return self
end

---@return string
function Account:getName()
	return self.name
end

---@return string
function Account:getLabel()
	return self.label
end

---@return number
function Account:getType()
	return self.type
end

 ---@return number
function Account:getMoney()
	return self.money
end

---@param amount number
function Account:addMoney(amount)
	if type(amount) ~= 'number' then return end
    self.money = self.money + Noob.Math.Round(amount)
    self:save()
	return self.money
end

---@param amount number
function Account:removeMoney(amount)
	if type(amount) ~= 'number' then return end
    if amount < 0 then return false end
	if self.money - amount < 0 then return false end
    self.money = self.money - Noob.Math.Round(amount)
    self:save()
    return true
end

 ---@param value number
function Account:setMoney(value)
	if type(value) ~= 'number' then return end
	self.money = Noob.Math.Round(value)
	self:save()
end

function Account:save()
	MySQL.ready(function()
		MySQL.query('UPDATE addons_accounts SET money = @money WHERE name = @name', {
			['@name'] = self.name,
			['@money'] = self.money
		})
	end)
end