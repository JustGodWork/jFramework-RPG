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

GM.Server.CommandManager:Register("setTime", function (player, args)
    --World.SetTime(9, 30)
    if (player) then
        Server.SendChatMessage(player, "This command is not available yet.");
        return true;
    else
        GM.Log:warn("This command is not available yet.");
        return false;
    end
end)

local function getCoords(player)
    local location = player:GetControlledCharacter():GetLocation();
    local rotation = player:GetControlledCharacter():GetRotation();

    location = {
        X = GM.Utils.Math:Round(location.X, 2),
        Y = GM.Utils.Math:Round(location.Y, 2),
        Z = GM.Utils.Math:Round(location.Z, 2)
    };
    rotation.Yaw = GM.Utils.Math:Round(rotation.Yaw, 2);

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

GM.Server.CommandManager:Register("coords", function (player)
    local coords = getCoords(player);

    Server.SendChatMessage(player, coords);
    GM.Log:info(coords);
    return true;
end, true)

GM.Server.CommandManager:Register("playerCoords", function(player, args)
    if (player) then Server.SendChatMessage(player, "This command is server only."); return false; end
    if (args[1]) then
        if (GM.Utils:isNumber(tonumber(args[1]))) then
            local jPlayer = GM.Server.PlayerManager:GetFromId(tonumber(args[1]));

            if (jPlayer) then
                GM.Log:info(getCoords(jPlayer));
            else
                GM.Log:warn(string.format("Player [%s] not found.", args[1]));
            end
        else
            GM.Log:warn("Invalid player id.");
        end
    else
        GM.Log:warn("Missing player id.");
    end
    return true;
end)