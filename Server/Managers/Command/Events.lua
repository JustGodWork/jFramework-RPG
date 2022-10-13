--
--Created Date: 10:52 30/09/2022
--Author: JustGod
--Made with ❤
--
--File: [Events]
--
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
--

Events.Subscribe(SharedEnums.Commands.execute, function(player, commandName, args)
    GM.Server.CommandManager:Execute(commandName, player, args);
end)