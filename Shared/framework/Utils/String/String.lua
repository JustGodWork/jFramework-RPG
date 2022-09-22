--[[
--Created Date: Thursday September 22nd 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Thursday September 22nd 2022 7:27:59 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

---@class _String
local String = {};

---@return _String
function String:new()
    ---@type _String
    local self = {};
    setmetatable(self, {__index = String});

    return self;
end

---@param str string string to split
---@param sep string string separator
function String:split(str, sep)
    if sep == nil then
        sep = "%s"
    end

    local strTable = {};
    for newStr in string.gmatch(str, "([^"..sep.."]+)") do
        table.insert(strTable, newStr)
    end

    return strTable;
end

jShared.utils.string = String:new();
