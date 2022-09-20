--[[
--Created Date: Tuesday August 2nd 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Tuesday August 2nd 2022 8:48:07 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

---@class AccountManager
local _AccountManager = {}

---@return AccountManager
function _AccountManager:new()
    local class = {}
    setmetatable(class, {__index = _AccountManager})
    
    self.accounts = jShared.utils.map:new("Accounts")
    self.sharedAccounts = jShared.utils.map:new("SharedAccounts")
	self.repository = jServer.repositoryManager:register("accounts", {
		name = "",
		label = "",
		type = 0,
		money = 0
	})

    --self:init()

	Package.Log("AccountManager initialized")
    return self
end

function _AccountManager:init()
	MySQL.ready(function()
		MySQL.query('SELECT * FROM addons_accounts', {}, function(result)
			local count = 0
			for i = 1, #result do
				local name = result[i].name
				local label = result[i].label
				local shared = result[i].shared
				local money = result[i].money
				if shared == 0 and not self.accounts:get(name) then
					count = count + 1
					self.accounts:set(name, Account:new(name, label, shared, money or 5000))
				elseif shared == 1 and not self.sharedAccounts:get(name) then
					count = count + 1
					self.sharedAccounts:set(name, Account:new(name, label, shared, money or 5000))
				end
			end
			Console:info(("^7[^1AccountManager^7]^4 %s ^3comptes ont été charger avec succès ✔️"):format(count))
		end)
	end)
end

function _AccountManager:newAccount(name, data, cb)
	data.money = (data.money and Noob.Math.Round(data.money)) or 5000
	if self.accounts:get(name) or self.sharedAccounts:get(name) then
		if cb then cb(false) end
	end
	if data.shared == 0 then
		self.accounts:set(name, Account:new(name, data.label, data.shared, data.money or 5000))
	elseif data.shared == 1 then
		self.sharedAccounts:set(name, Account:new(name, data.label, data.shared, data.money or 5000))
	end
	MySQL.insert("INSERT INTO addons_accounts (name, label, shared, money) VALUES (@name, @label, @shared, @money)", {
		['@name'] = name,
		['@label'] = data.label,
		['@shared'] = data.shared,
		['@money'] = data.money or 5000
	}, function()
		if cb then cb(true) end
	end)
end

function _AccountManager:deleteAccount(name)
	if self.accounts:get(name) then
		self.accounts:remove(name)
	elseif self.sharedAccounts:get(name) then
		self.sharedAccounts:remove(name)
	end
	MySQL.query('DELETE FROM addons_accounts WHERE name = @name', {['@name'] = name})
end

---@return Account
function _AccountManager:getAccount(name)
	return self.accounts:get(name)
end

---@return Map
function _AccountManager:getAccounts()
	return self.accounts
end

---@param name string
---@return Account
function _AccountManager:getSharedAccount(name)
	return self.sharedAccounts:get(name)
end

---@return Map
function _AccountManager:getSharedAccounts()
	return self.sharedAccounts
end

jServer.accountManager = _AccountManager:new();