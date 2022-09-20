--[[
--Created Date: Tuesday September 20th 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Tuesday September 20th 2022 9:11:59 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

---@class AccountManager
local AccountManager = {}

function AccountManager:new()
    local class = {};
    setmetatable(class, {__index = AccountManager});

    self.accounts = jShared.utils.mapManager:register("accounts");

    return self;
end

jServer.accountManager = AccountManager:new();