--
--Created Date: 11:57 30/09/2022
--Author: JustGod
--Made with ❤
--
--File: [Utils]
--
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
--

---@class SUtils
local SUtils = {};

function SUtils:new()
    local self = {};
    setmetatable(self, { __index = SUtils });
    return self
end

---@param entity Actor
---@return void
function SUtils:isEntityValid(entity)
    return entity ~= nil and entity:IsValid();
end

jServer.utils = SUtils:new();

jServer:loadFrameworkModule("Utils/loader.lua");