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
    jServer.playerManager:removeAll()
    --Events.BroadcastRemote("onResourceReload")
    Server.BroadcastChatMessage("The package <cyan>Framework</> has been reloaded!")

    local players = Player.GetAll()
    for i = 1 , #players do
        local player = players[i]
        jServer.connexionHandler:handle(player)
    end
end)

-- When resource restart or reload, the player is respawned
Events.Subscribe("resourceReloaded", function(player)
    jServer.connexionHandler:handle(player)
end)

-- Spawns and possess a Character when a Player joins the server
Player.Subscribe("Spawn", function(player)
    jServer.connexionHandler:handle(player)
end)

-- Destroys the Character when the Player leaves the server
Player.Subscribe("Destroy", function(player)
    local nanosPlayer = player
    local character = nanosPlayer:GetControlledCharacter()
    if (character) then
        character:Destroy()
    end
    jServer.playerManager:removePlayer(nanosPlayer:GetID())
end)