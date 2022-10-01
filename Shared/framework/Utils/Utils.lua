---
---Created Date: 17:29 28/09/2022
---Author: JustGod
---Made with ❤

---File: [Utils]

---Copyright (c) 2022 JustGodWork, All Rights Reserved.
---This file is part of JustGodWork project.
---Unauthorized using, copying, modifying and/or distributing of this file
---via any medium is strictly prohibited. This code is confidential.
---

---@class Utils
Utils = {}

---@return Utils
function Utils:new()
    ---@type Utils
    local self = {}
    setmetatable(self, { __index = Utils});

    return self
end

---@param int number
function Utils:isNumber(int)
    return type(int) == "number";
end

---@param str string
function Utils:isString(str)
    return type(str) == "string";
end

---@param tbl table
function Utils:isTable(tbl)
    return type(tbl) == "table";
end

---@param bool boolean
function Utils:isBoolean(bool)
    return type(bool) == "boolean";
end

---@param value any
function Utils:isNil(value)
    return type(value) == "nil";
end

jShared.utils = Utils:new();

jShared:loadFrameworkModule("Utils/loader.lua");