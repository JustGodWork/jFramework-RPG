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

---@type String
String = Class.new(function(class)

    ---@class String: BaseObject
    local self = class;
    
    ---@param str string string to split
    ---@param sep string string separator
    function self:Split(str, sep)
        if sep == nil then
            sep = "%s"
        end

        local strTable = {};
        for newStr in string.gmatch(str, "([^"..sep.."]+)") do
            table.insert(strTable, newStr)
        end

        return strTable;
    end

    return self;
end);
