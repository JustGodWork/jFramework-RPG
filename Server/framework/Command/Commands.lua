--[[
--Created Date: Thursday September 22nd 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Thursday September 22nd 2022 11:21:08 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

jServer.commandManager:register("setTime", function (player, args)
    --World.SetTime(9, 30)
end)

jServer.commandManager:register("diable", function(player, args)
    local jPlayer = jServer.playerManager:getFromId(player:GetID())
    local location = jPlayer:GetControlledCharacter():GetLocation()
    local vehicle = SpawnVehicle(location, jPlayer:GetControlledCharacter():GetRotation(), nil, {
        torque = tonumber(args[1]), 
        rpm = tonumber(args[2])
    })
    jPlayer:GetControlledCharacter():EnterVehicle(vehicle)
end)

jServer.commandManager:register("coords", function (player, args)
    local location = player:GetControlledCharacter():GetLocation()
    local rotation = player:GetControlledCharacter():GetRotation()
    Server.SendChatMessage(player, ("Your coords are: \nlocation:\n [ x: %s, y: %s, z: %s]\n\n heading:\n [ Pitch: %s, Yaw: %s, Roll: %s]"):format(
        location.X, 
        location.Y, 
        location.Z, 
        rotation.Pitch, 
        rotation.Yaw, 
        rotation.Roll
    ))
end)