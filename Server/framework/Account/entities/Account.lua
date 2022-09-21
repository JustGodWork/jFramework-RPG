--[[
--Created Date: Tuesday September 20th 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Tuesday September 20th 2022 9:53:23 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

---@class Account
Account = {}

---@param id string
---@param name string
---@param owner string
---@param money number
---@param accountType number
function Account:new(id, name, owner, money, accountType)
    local self = {}
    setmetatable(self, { __index = Account});

    self.id = id;
    self.name = name;
    self.owner = owner;
    self.money = money or 0;
    self.type = accountType or 0;

    return self;
end

---@return string
function Account:getId()
    return self.id;
end

---@return string
function Account:getName()
    return self.name;
end

---@return string
function Account:getOwner()
    return self.owner;
end

---@return number
function Account:getMoney()
    return self.money;
end

---@param money number
---@return void
function Account:setMoney(money)
    self.money = money;
end

---@return number
function Account:getType()
    return self.type;
end

---@param type number
function Account:setType(type)
    self.type = type;
end