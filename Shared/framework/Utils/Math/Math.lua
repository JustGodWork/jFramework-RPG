---
---Created Date: 11:57 27/09/2022
---Author: JustGod
---Made with ❤

---File: [Math]

---Copyright (c) 2022 JustGodWork, All Rights Reserved.
---This file is part of JustGodWork project.
---Unauthorized using, copying, modifying and/or distributing of this file
---via any medium is strictly prohibited. This code is confidential.
---

---@class Math
local Math = {};

---@return Math
function Math:new()
    ---@type Math
    local self = {};
    setmetatable(self, {__index = Math});

    return self;
end

---@param value number
---@param numDecimalPlaces number
function Math:round(value, numDecimalPlaces)
    if numDecimalPlaces then
        local power = 10^numDecimalPlaces
        return math.floor((value * power) + 0.5) / (power)
    else
        return math.floor(value + 0.5)
    end
end

-- credit http://richard.warburton.it
---@param value number
function Math:groupDigits(value)
    local left,num,right = string.match(value,'^([^%d]*%d)(%d*)(.-)$')

    return left..(num:reverse():gsub('(%d%d%d)','%1' .. "$"):reverse())..right
end

---@param value number
function Math:Trim(value)
    if value then
        return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
    else
        return nil
    end
end

jShared.utils.math = Math:new();
