--[[
--Created Date: Tuesday September 20th 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Tuesday September 20th 2022 7:58:21 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

---@private
---@param data table
function Player:onConnect(data)

    local player = {
        _id = data.id,
        identifier = self:GetSteamID(),
        firstname = data.firstname,
        lastname = data.lastname,
        position = self:initPosition(data),
        skin = self:initSkin(data.skin),
    }

    self:SetValue("data", player, true);

    self:initialize(); --Spawn the player when all data are loaded

    jShared.log:debug("[ Player: ".. self:getFullName() .." ] initialized.");
end

---@private
function Player:initialize()
    local position = self:getPosition()
    local playerCharacter = Character(Vector(position.X, position.Y, position.Z), Rotator(0.0, 0.0, self:getHeading()), self:getSkin());
    self:Possess(playerCharacter);
    local weapon = Enums.Weapons.AK74U_CUSTOM();
    weapon:SetAutoReload(false);
    weapon:SetAmmoClip(0);
    playerCharacter:PickUp(weapon);
    self:handleDeath(); --When player is created, and his character is loaded load Death handle.
    if (Config.player.firstPersonOnly) then
        playerCharacter:SetCameraMode(CameraMode.FPSOnly);
    end
end

---@private
---@param playerPosition table
---@return Vector
function Player:initPosition(playerPosition)
    local position = Config.player.defaultPosition;
    if (
            playerPosition.posX
            and playerPosition.posY
            and playerPosition.posZ
            and playerPosition.Yaw
    )
    then
        position = {
            X = playerPosition.posX,
            Y = playerPosition.posY,
            Z = playerPosition.posZ,
            Yaw = playerPosition.Yaw
        };
    end
    return { X = position.X, Y = position.Y, Z = position.Z, Yaw = position.Yaw };
end

---@private
---@param playerSkin string
---@return string
function Player:initSkin(playerSkin)
    local skin = Config.player.defaultSkin;
    if (playerSkin) then
        skin = playerSkin;
    end
    return skin
end

---@private
function Player:handleDeath()
    local character = self:GetControlledCharacter();
    character:Subscribe("Death", function(chara, _, _, _, _, instigator)
        jShared.log:info(string.format("Player [%s] %s die.", self:GetSteamID(), self:getFullName()));
        local message;
        if (instigator) then
            if (instigator == self) then
                message = ("<cyan>%s</> committed suicide"):format(
                        instigator:GetName()
                );
            else
                message = ("<cyan>%s</> killed <cyan>%s</>"):format(
                        instigator:GetName(),
                        self:GetName()
                );
            end
        else
            message = ("<cyan>%s</> died"):format(
                    self:GetName()
            )
        end
        Server.BroadcastChatMessage(message);
        self:handleRespawn(chara);
    end)
end

---Handle Respawning player
---@param playerCharacter Character
---@private
function Player:handleRespawn(playerCharacter)
    Timer.Bind(Timer.SetTimeout(function(character)
        jShared.log:info(string.format("Respawning Player [%s] %s...", self:GetSteamID(), self:getFullName()));
        local data = self:GetValue("data")
        local position = character:GetLocation()
        data.position = {
            X = position.X,
            Y = position.Y,
            Z = position.Z,
            Yaw = character:GetRotation().Yaw
        }
        self:SetValue("data", data, true);
        if (character:GetHealth() ~= 0) then return end
        character:Respawn(self:getPosition(), Rotator(0.0, 0.0, self:getHeading()));
    end, Config.player.respawnTimer * 1000, playerCharacter), playerCharacter);
end

---@return number
function Player:getCharacterId()
    return self:GetValue("data")._id;
end

---@return string
function Player:getFirstName()
    return self:GetValue("data").firstname;
end

---@param name string
---@return void
function Player:setFirstName(name)
    self:GetValue("data").firstname = name;
end

---@return string
function Player:getLastName()
    return self:GetValue("data").lastname;
end

---@param name string
---@return void
function Player:setLastName(name)
    self:GetValue("data").lastname = name;
end

---@return string
function Player:getFullName()
    local firstname = self:GetValue("data").firstname;
    local lastname = self:GetValue("data").lastname;
    if  (firstname == nil or lastname == nil) then
        return self:GetName();
    end
    return string.format("%s %s", firstname, lastname);
end

---@return Vector
function Player:getPosition()
    local position = self:GetValue("data").position
    return Vector(position.X, position.Y, position.Z);
end

---update Player position
---@return table
function Player:updatePosition()
    local data = self:GetValue("data")
    local character = self:GetControlledCharacter();
    if (character) then
        local position = character:GetLocation();
        data.position = {
            X = jShared.utils.math:round(position.X, 2),
            Y = jShared.utils.math:round(position.Y, 2),
            Z = jShared.utils.math:round(position.Z, 2),
            Yaw = jShared.utils.math:round(character:GetRotation().Yaw, 2)
        };
        self:SetValue("data", data, true);
        return self:GetValue("data").position;
    end
    return {};
end

---@return Rotator
function Player:getHeading()
    return Rotator(0.0, 0.0, self:GetValue("data").position.Yaw);
end

function Player:getSkin()
    return self:GetValue("data").skin;
end

---@param skin string
---@return void
function Player:setSkin(skin)
    local data = self:GetValue("data");
    data.skin = skin;
    self:SetValue("data", data, true);
end