--[[
----
----Created Date: 10:40 Thursday October 13th 2022
----Author: JustGod
----Made with ❤
----
----File: [Commands]
----
----Copyright (c) 2022 JustGodWork, All Rights Reserved.
----This file is part of JustGodWork project.
----Unauthorized using, copying, modifying and/or distributing of this file
----via any medium is strictly prohibited. This code is confidential.
----
--]]

GM.Server.CommandManager:Register("saveall", function(player)
    GM.Server.PlayerManager:SaveAll();
    GM.Log:info(("All players saved by [%s] %s."):format(player:GetSteamID(), player:GetFullName()));
    return true;
end);

GM.Server.CommandManager:Register("save", function(player)
    GM.Server.PlayerManager:Save(player);
    GM.Log:info(("Player [%s] %s saved."):format(player:GetSteamID(), player:GetFullName()));
    return true;
end);

GM.Server.CommandManager:Register("noclip", function(player)
    player:ToggleNoClip();
    return true;
end);