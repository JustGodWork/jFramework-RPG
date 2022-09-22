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

---@return Command
function Command:new(name, callback)
    ---@type Command
    local self = {}
    setmetatable(self, {__index = Command})

    self.name = name
    self.callback = callback

    return self
end

---@return fun(player: Player, args: string[])
function Command:getCallback()
    return self.callback
end