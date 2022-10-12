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

---Client only
---@param commandName string
---@param args string[]
function Utils:executeCommand(commandName, args)
    Events.CallRemote(SharedEnums.Commands.execute, commandName, args);
end