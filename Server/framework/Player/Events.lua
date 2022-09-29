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
end)

-- Spawns and possess a Character when a Player joins the server
Player.Subscribe("Spawn", function(player)
    jServer.playerManager:registerPlayer(player);
end)

-- Destroys the Character when the Player leaves the server
Player.Subscribe("Destroy", function(player)
    local playerToRemove = player
    jServer.playerManager:removePlayer(playerToRemove);
end)

--[[Events.Subscribe("onPlayerConnecting", function(player)
    jServer.mysql:select("SELECT * FROM players AS p JOIN inventories AS i ON p.identifier = i.owner WHERE identifier = ?", { player:GetSteamID() }, function(inventories)
        if (#inventories > 0) then
            for i = 1, #inventories do
                jServer.inventoryManager:register(inventories[i].name, inventories[i].owner);
            end
        else
            for i = 1, #Config.player.inventories do
                jServer.inventoryManager:create(
                        Config.player.inventories[i].name,
                        Config.player.inventories[i].label,
                        player:GetSteamID(),
                        Config.player.inventories[i].maxWeight,
                        Config.player.inventories[i].shared
                );
            end
        end
    end)
end)]]

Events.Subscribe("onPlayerConnecting", function(player)
    Timer.SetTimeout(function()
        -- todo : remove this when inventory system is done
        local jPlayer = jServer.playerManager:getFromId(player:GetID());
        --local inv = jServer.inventoryManager:getByOwner(jPlayer:GetSteamID(), "main");
        --[[if (inv:addItem("water", 15)) then
            jShared.log:info(inv:getItems());
            jShared.log:info("You have been given 15 water bottles");
        end]]
    end, 2000)
end)