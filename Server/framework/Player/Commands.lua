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

GM.Server.commandManager:Register("saveall", function(player)
    GM.Server.playerManager:SaveAll();
    GM.Server.log:info(("All players saved by [%s] %s."):format(player:GetSteamID(), player:GetFullName()));
    return true;
end);

GM.Server.commandManager:Register("save", function(player)
    GM.Server.playerManager:Save(player);
    GM.Server.log:info(("Player [%s] %s saved."):format(player:GetSteamID(), player:GetFullName()));
    return true;
end);

GM.Server.commandManager:Register("noclip", function(player)
    player:ToggleNoClip();
    return true;
end);