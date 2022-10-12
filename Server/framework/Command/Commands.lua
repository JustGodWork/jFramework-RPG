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

GM.Server.commandManager:Register("setTime", function (player, args)
    --World.SetTime(9, 30)
    if (player) then
        Server.SendChatMessage(player, "This command is not available yet.");
        return true;
    else
        GM.Server.log:warn("This command is not available yet.");
        return false;
    end
end)

local function getCoords(player)
    local location = player:GetControlledCharacter():GetLocation();
    local rotation = player:GetControlledCharacter():GetRotation();

    location = {
        X = GM.Server.utils.math:Round(location.X, 2),
        Y = GM.Server.utils.math:Round(location.Y, 2),
        Z = GM.Server.utils.math:Round(location.Z, 2)
    };
    rotation.Yaw = GM.Server.utils.math:Round(rotation.Yaw, 2);

    local coords = ([[Player [%s] %s coords are:

        default: [ x: %s, y: %s, z: %s, heading: %s]
        position: Vector(%s, %s, %s)
        rotation: Rotator(0.0, 0.0, %s)

    ]]
    ):format(
        player:GetSteamID(),
        player:GetFullName(),
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

GM.Server.commandManager:Register("coords", function (player)
    local coords = getCoords(player);

    Server.SendChatMessage(player, coords);
    GM.Server.log:info(coords);
    return true;
end, true)

GM.Server.commandManager:Register("playerCoords", function(player, args)
    if (player) then Server.SendChatMessage(player, "This command is server only."); return false; end
    if (args[1]) then
        if (GM.Server.utils:isNumber(tonumber(args[1]))) then
            local jPlayer = GM.Server.playerManager:GetFromId(tonumber(args[1]));

            if (jPlayer) then
                GM.Server.log:info(getCoords(jPlayer));
            else
                GM.Server.log:warn(string.format("Player [%s] not found.", args[1]));
            end
        else
            GM.Server.log:warn("Invalid player id.");
        end
    else
        GM.Server.log:warn("Missing player id.");
    end
    return true;
end)