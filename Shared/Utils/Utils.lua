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

Package.Require("manifest.lua");

---@type Utils
Utils = Class.new(function(class)
    
    ---@class Utils: BaseObject
    local self = class;

    function self:Constructor()
        self.Math = Math();
        self.String = String();
        self.Thread = ThreadManager();
    end
    
    ---@param int number
    function self:isNumber(int)
        return type(int) == "number";
    end
    
    ---@param str string
    function self:isString(str)
        return type(str) == "string";
    end
    
    ---@param tbl table
    function self:isTable(tbl)
        return type(tbl) == "table";
    end
    
    ---@param bool boolean
    function self:isBoolean(bool)
        return type(bool) == "boolean";
    end
    
    ---@param value any
    function self:isNil(value)
        return type(value) == "nil";
    end
    
    ---@param vector Vector
    ---@param hasTable boolean
    ---@return Vector | table
    function self:ReduceVector(vector, hasTable)
        if (not hasTable) then
            return Vector(
                self.Math:Round(vector.X),
                self.Math:Round(vector.Y),
                self.Math:Round(vector.Z)
            );
        else
            return {
                X = self.Math:Round(vector.X),
                Y = self.Math:Round(vector.Y),
                Z = self.Math:Round(vector.Z)
            };
        end
    end
    
    ---@param rotator Rotator
    ---@param hasTable boolean
    ---@return Rotator | table
    function self:ReduceRotator(rotator, hasTable)
        if (not hasTable) then
            return Rotator(
                self.Math:Round(rotator.Pitch),
                self.Math:Round(rotator.Yaw),
                self.Math:Round(rotator.Roll)
            );
        else
            return {
                Pitch = self.Math:Round(rotator.Pitch),
                Yaw = self.Math:Round(rotator.Yaw),
                Roll = self.Math:Round(rotator.Roll)
            };
        end
    end
    
    return self;
end);