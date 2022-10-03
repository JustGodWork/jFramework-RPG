--[[
--Created Date: Thursday September 22nd 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Thursday September 22nd 2022 7:11:28 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

---@class Command
Command = {}

---@param name string
---@param callback fun(player: Player | nil, args: string[])
---@param isClient boolean
---@return Command
function Command:new(name, callback, isClient)
    ---@type Command
    local self = {}
    setmetatable(self, {__index = Command})

    self.name = name
    self.callback = callback
    self.client_only = isClient

    return self
end

---@return string
function Command:getName()
    return self.name
end

---@return boolean
function Command:isClient()
    return self.client_only
end

---@return fun(player: Player, args: string[])
function Command:getCallback()
    return self.callback
end