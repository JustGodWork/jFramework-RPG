--[[
--Created Date: Wednesday September 21st 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Wednesday September 21st 2022 10:15:59 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

local ticks = {}

---Create a loop
---@param callback function
function setTick(callback)
    local id = jShared:uuid()
    local function thread()
        callback()
    end
    ticks[id] = Timer.SetInterval(function()
        thread()
    end, 5)
    return id
end

function clearTick(id)
    Timer.ClearInterval(ticks[id])
end

---Create an async fake thread
---@param callback function
function CreateThread(callback)
    local function thread()
        callback()
    end
    Timer.SetTimeout(function()
        thread()
    end, 0)
end