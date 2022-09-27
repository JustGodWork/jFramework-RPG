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
    if (player) then
        Server.SendChatMessage(player, "This command is not available yet.");
    else
        jShared.log:warn("This command is not available yet.");
    end
end)

jServer.commandManager:register("coords", function (player, args)
    local location = player:GetControlledCharacter():GetLocation()
    local rotation = player:GetControlledCharacter():GetRotation()
    Server.SendChatMessage(player, ("Your coords are: \n [ x: %s, y: %s, z: %s, heading: %s]"):format(
            location.X,
            location.Y,
            location.Z,
            rotation.Yaw
    ));
end, true)