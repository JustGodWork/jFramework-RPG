--[[
----
----Created Date: 7:10 Sunday October 9th 2022
----Author: JustGod
----Made with ❤
----
----File: [Modules]
----
----Copyright (c) 2022 JustGodWork, All Rights Reserved.
----This file is part of JustGodWork project.
----Unauthorized using, copying, modifying and/or distributing of this file
----via any medium is strictly prohibited. This code is confidential.
----
--]]

---@type ServerModule
ServerModule = Class.extends(BaseObject, function(class)

    ---@class ServerModule: BaseObject
    local self = class

    function self:Constructor(moduleName)
        self.name = moduleName or "UNDEFINED";
        GM.Server.log:info(("[MODULE] [ %s ] initialized."):format(self.name));
    end
    
    ---@return string
    function self:GetName()
        return self.name;
    end

    return self;
end);

Package.Require("World/World.lua");
Package.Require("Test.lua");