--
--Created Date: 10:37 30/09/2022
--Author: JustGod
--Made with ❤
--
--File: [Commands]
--
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
--

jServer.commandManager:register("saveall", function(player)
    jServer.playerManager:saveAll();
    jShared.log:info(("All players saved by [%s] %s."):format(player:GetSteamID(), player:getFullName()));
    return true;
end);

jServer.commandManager:register("save", function(player)
    jServer.playerManager:save(player);
    jShared.log:info(("Player [%s] %s saved."):format(player:GetSteamID(), player:getFullName()));
    return true;
end);

jServer.commandManager:register("noclip", function(player)
    player:toggleNoClip();
    return true;
end);