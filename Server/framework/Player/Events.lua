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

-- Destroys All players data and rebuild them
Package.Subscribe("Load", function()
    local players = Player.GetAll();
    for i = 1 , #players do
        jServer.playerManager:registerPlayer(players[i]);
    end
    Server.BroadcastChatMessage("<cyan>GameMode</> has been reloaded!");
end);

-- Spawns and possess a Character when a Player joins the server
Player.Subscribe("Spawn", function(player)
    jServer.playerManager:registerPlayer(player);
end);

-- Destroys the Character when the Player leaves the server
Player.Subscribe("Destroy", function(player)
    local playerToRemove = player
    jServer.playerManager:removePlayer(playerToRemove);
end);

Events.Subscribe(SharedEnums.Player.inventoryLoaded, function(owner, inventoryId, inventoryName)
    local player = jServer.playerManager:getFromIdentifier(owner);
    if (player) then
        if (not player:GetValue("inventories")) then player:SetValue("inventories", {}); end
        local inventories = player:GetValue("inventories");
        inventories[inventoryName] = inventoryId;
        player:SetValue("inventories", inventories);
    end
end);

--When player is created, and his character is loaded load Death handle.
---@param character Character
---@param instigator Player
Character.Subscribe("Death", function(self, _, _, _, _, instigator)
    if (self and NanosUtils.IsA(self, Character)) then
        local player = self:GetPlayer();
        if (player) then
            player:setPosition();
            local message;
            if (instigator) then
                if (instigator == self) then
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
            jShared.log:info(string.format("Player [%s] %s die.", player:GetSteamID(), player:getFullName()));
            Server.BroadcastChatMessage(message);
            player:handleRespawn();
        end
    end
end)