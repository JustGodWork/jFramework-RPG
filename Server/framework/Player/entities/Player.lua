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
            playerCharacter:Respawn(self:getPosition(), Rotator());
        else
            jShared.log:warn(string.format("Player [%s] %s character is not valid, cannot respawn.", self:GetSteamID(), self:getFullName()));
        end
    end, Config.player.respawnTimer * 1000);
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

---@param position Vector
---@param rotation Rotator
function Player:setPosition(position, rotation)
    local character = self:GetControlledCharacter();
    local data = self:GetValue("data");
    local pos = position or character:GetLocation();
    local rot = rotation or character:GetRotation();
    data.position = {
        X = pos.X,
        Y = pos.Y,
        Z = pos.Z,
        Yaw = rot.Yaw
    }
    self:SetValue("data", data, true);
end

---update Player position
---@return table
function Player:updatePosition()
    local data = self:GetValue("data")
    local character = self:GetControlledCharacter();
    if (character and character:IsValid()) then
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
    local pos = self:GetValue("data").position;
    return Rotator(0.0, 0.0, pos.Yaw);
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

---@param inventoryName string
---@return number | nil
function Player:getInventoryId(inventoryName)
    local inventories = self:GetValue("inventories");
    if (inventories) then
        return inventories[inventoryName];
    end
    return nil;
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
    local player = self;
    ---@param character Character
    local function run(character, old_state, new_state)
        if (new_state == FallingMode.None) then
            if (NanosUtils.IsA(character:GetPlayer(), Player)) then
                if (character:GetPlayer():isInNoClip()) then
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
    player:GetControlledCharacter():Subscribe("FallingModeChanged", run);
end
