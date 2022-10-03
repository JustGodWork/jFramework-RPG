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
        return true;
    else
        jShared.log:warn("This command is not available yet.");
        return false;
    end
end)

local function getCoords(player)
    local location = player:GetControlledCharacter():GetLocation();
    local rotation = player:GetControlledCharacter():GetRotation();

    location = {
        X = jShared.utils.math:round(location.X, 2),
        Y = jShared.utils.math:round(location.Y, 2),
        Z = jShared.utils.math:round(location.Z, 2)
    };
    rotation.Yaw = jShared.utils.math:round(rotation.Yaw, 2);

    local coords = ([[Player [%s] %s coords are:

        default: [ x: %s, y: %s, z: %s, heading: %s]
        position: Vector(%s, %s, %s)
        rotation: Rotator(0.0, 0.0, %s)

    ]]
    ):format(
        player:GetSteamID(),
        player:getFullName(),
        location.X,
        location.Y,
        location.Z,
        rotation.Yaw,
        location.X,
        location.Y,
        location.Z,
        rotation.Yaw
    );

    return coords;
end

jServer.commandManager:register("coords", function (player)
    local coords = getCoords(player);

    Server.SendChatMessage(player, coords);
    jShared.log:info(coords);
    return true;
end, true)

jServer.commandManager:register("playerCoords", function(player, args)
    if (player) then Server.SendChatMessage(player, "This command is server only."); return false; end
    if (args[1]) then
        if (jShared.utils:isNumber(tonumber(args[1]))) then
            local jPlayer = jServer.playerManager:getFromId(tonumber(args[1]));

            if (jPlayer) then
                jShared.log:info(getCoords(jPlayer));
            else
                jShared.log:warn(string.format("Player [%s] not found.", args[1]));
            end
        else
            jShared.log:warn("Invalid player id.");
        end
    else
        jShared.log:warn("Missing player id.");
    end
    return true;
end)