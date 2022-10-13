--[[
--Created Date: Thursday September 22nd 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Thursday September 22nd 2022 3:16:24 am
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

Server.Subscribe("PlayerConnect", function(IP, player_account_ID, player_name, player_steam_ID)
    GM.Log:debug(("Player [ SteamID: %s IP: %s ] %s has started connection process..."):format(player_steam_ID, IP, player_name));
end)

-- Destroys All players data and rebuild them
Package.Subscribe("Load", function()
    local players = Player.GetAll();
    for i = 1 , #players do
        GM.Server.PlayerManager:RegisterPlayer(players[i]);
    end
    Server.BroadcastChatMessage("<cyan>GameMode</> has been reloaded!");
end);

-- Spawns and possess a Character when a Player joins the server
Player.Subscribe("Spawn", function(player)
    GM.Server.PlayerManager:RegisterPlayer(player);
end);

-- Destroys the Character when the Player leaves the server
Player.Subscribe("Destroy", function(player)
    local playerToRemove = player
    GM.Server.InventoryManager:RemoveByOwner(playerToRemove:GetSteamID(), "main");
    GM.Server.PlayerManager:RemovePlayer(playerToRemove);
end);

--When player is created, and his character is loaded load Death handle.
---@param character Character
---@param instigator Player
Character.Subscribe("Death", function(self, _, _, _, _, instigator)
    local player = GM.Server.utils.Entity:IsPlayerAndOfType(self, Character);
    if (player) then
        local message;
        if (instigator) then
            if (instigator == player) then
                message = ("<cyan>%s</> committed suicide"):format(
                        instigator:GetName()
                );
            else
                message = ("<cyan>%s</> killed <cyan>%s</>"):format(
                        instigator:GetName(),
                        player:GetName()
                );
            end
        else
            message = ("<cyan>%s</> died"):format(
                    player:GetName()
            );
        end
        GM.Log:info(string.format("Player [%s] %s die.", player:GetSteamID(), player:GetFullName()));
        Server.BroadcastChatMessage(message);
        player:HandleRespawn();
    end
end)