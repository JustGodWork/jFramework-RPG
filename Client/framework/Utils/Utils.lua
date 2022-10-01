--
--Created Date: 11:03 30/09/2022
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

---@class CUtils
local CUtils = {};

function CUtils:new()
    local self = {};
    setmetatable(self, { __index = CUtils });

    return self
end

---@param commandName string
---@param args string[]
function CUtils:executeCommand(commandName, args)
    Events.CallRemote(SharedEnums.Commands.execute, commandName, args);
end

jClient.utils = CUtils:new();