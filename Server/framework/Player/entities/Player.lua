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

    self:SetValue("characterId", data.id);
    self:SetValue("firstname", data.firstname);
    self:SetValue("lastname", data.lastname);
    self:SetValue("position", self:initPosition(data));
    self:SetValue("skin", self:initSkin(data.skin));

    self:initialize(); --Spawn the player when all data are loaded

    Events.CallRemote(SharedEnums.Player.loaded, self, {
        characterId = data.id,
        firstname = data.firstname,
        lastname = data.lastname,
        skin = self:initSkin(data.skin),
        position = self:initPosition(data)
    });

    jShared.log:debug("[ Player: ".. self:getFullName() .." ] initialized.");
end

---@private
function Player:initialize()
    local position = self:GetValue("position");
    local playerCharacter = Character(Vector(position.X, position.Y, position.Z), Rotator(0, position.Yaw, 0), self:getSkin());
    self:Possess(playerCharacter);
    local weapon = Enums.Weapons.AK74U_CUSTOM();
    weapon:SetAutoReload(false);
    weapon:SetAmmoBag(10000);
    weapon:SetAmmoClip(0);
    playerCharacter:PickUp(weapon);
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
---Handle Respawning player
function Player:handleRespawn()
    local playerCharacter = self:GetControlledCharacter();
    Timer.SetTimeout(function()
        if (playerCharacter and playerCharacter:IsValid()) then
            jShared.log:info(string.format("Respawning Player [%s] %s...", self:GetSteamID(), self:getFullName()));
            if (playerCharacter:GetHealth() ~= 0) then return end
            local position, rotation = self:getPosition(true);
            playerCharacter:Respawn(position, Rotator(0, rotation.Yaw, 0));
        else
            jShared.log:warn(string.format("Player [%s] %s character is not valid, cannot respawn.", self:GetSteamID(), self:getFullName()));
        end
    end, Config.player.respawnTimer * 1000);
end

---@return number
function Player:getCharacterId()
    return self:GetValue("characterId");
end

---@return string
function Player:getFirstName()
    return self:GetValue("firstname");
end

---@param name string
---@return void
function Player:setFirstName(name)
    self:SetValue("firstname", name);
end

---@return string
function Player:getLastName()
    return self:GetValue("lastname");
end

---@param name string
---@return void
function Player:setLastName(name)
    self:SetValue("lastname", name);
end

---@return string
function Player:getFullName()
    local firstname = self:GetValue("firstname");
    local lastname = self:GetValue("lastname");
    if  (firstname == nil or lastname == nil) then
        return self:GetName();
    end
    return string.format("%s %s", firstname, lastname);
end

---@param hasVector boolean
---@return table<X, Y, Z, Yaw> | Vector, nil | Rotator
function Player:getPosition(hasVector)
    local character = self:GetControlledCharacter();
    if (character and character:IsValid()) then
        local characterPosition = character:GetLocation();
        local characterRotation = character:GetRotation();
        local formatedPos = {
            X = jShared.utils.math:round(characterPosition.X, 2),
            Y = jShared.utils.math:round(characterPosition.Y, 2),
            Z = jShared.utils.math:round(characterPosition.Z, 2),
            Yaw = jShared.utils.math:round(characterRotation.Yaw, 2)
        };
        if (hasVector) then
            return characterPosition, characterRotation;
        end
        return formatedPos;
    end
end

function Player:getSkin()
    return self:GetValue("skin");
end

---@param skin string
---@return void
function Player:setSkin(skin)
    self:SetValue("skin", skin);
end

---@return boolean | nil
function Player:isInNoClip()
    return self:GetValue("NoClip");
end

---@private
---@param state boolean | nil
function Player:setInNoClip(state)
    self:SetValue("NoClip", state);
end

---Enable player no clip
function Player:enableNoClip()
    local character = self:GetControlledCharacter();
    if (not self:isInNoClip()) then
        self:SetValue("LastViewMode", character:GetViewMode());
        character:SetViewMode(ViewMode.FPS);
        self:setInNoClip(true);
        character:SetCollision(CollisionType.NoCollision);
        character:SetFlyingMode(true);
        character:SetInvulnerable(true);
        character:SetVisibility(false);
        character:SetRagdollMode(false);
    end
end

---Disable player no clip
function Player:disableNoClip()
    local character = self:GetControlledCharacter();
    if (self:isInNoClip()) then
        character:SetCollision(CollisionType.Auto);
        character:SetFlyingMode(false);
        character:SetHighFallingTime(-1);
        character:SetFallDamageTaken(0);
        self:onDisablingNoClip();
    end
end

---Toggle player no clip
function Player:toggleNoClip()
    if (self:isInNoClip()) then
        self:disableNoClip();
    else
        self:enableNoClip();
    end
end

function Player:onDisablingNoClip()
    local this = self;
    ---@param character Character
    local function run(character, old_state, new_state)
        if (new_state == FallingMode.None) then
            local player = jServer.utils.entity:isPlayerAndOfType(character, Character);
            if (player) then
                if (player:isInNoClip()) then
                    character:SetInvulnerable(false);
                    character:SetVisibility(true);
                    character:SetHighFallingTime(1);
                    character:SetFallDamageTaken(10);
                    character:SetViewMode(player:GetValue("LastViewMode"));
                    character:Unsubscribe("FallingModeChanged", run);
                    player:setInNoClip(false);
                end
            end
        end
    end
    this:GetControlledCharacter():Subscribe("FallingModeChanged", run);
end
