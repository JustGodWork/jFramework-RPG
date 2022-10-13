--[[
----
----Created Date: 12:05 Thursday October 13th 2022
----Author: JustGod
----Made with ❤
----
----File: [Example]
----
----Copyright (c) 2022 JustGodWork, All Rights Reserved.
----This file is part of JustGodWork project.
----Unauthorized using, copying, modifying and/or distributing of this file
----via any medium is strictly prohibited. This code is confidential.
----
--]]

---@type parentClass
local parentClass = Class.new(function(class)

    ---@class parentClass: BaseObject
    local self = class;

    ---@param name string
    ---@param age number
    function self:Constructor(name, age)
        self.name = name;
        self.age = age;
    end

    ---@return string
    function self:GetName()
        return self.name;
    end

    ---@return number
    function self:GetAge()
        return self.age;
    end

    return self;
end);

---@type childrenClass
local childrenClass = Class.extends(parentClass, function(class)

    ---@class childrenClass: parentClass
    local self = class;

    ---@param name string
    ---@param age number
    function self:Constructor(name, age)
        self:super(name, age)
    end

    return self;
end);

local instance = childrenClass("Paul", 18);
print(instance:GetName(), instance:GetAge());