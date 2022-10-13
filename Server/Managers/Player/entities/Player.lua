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
---GameMode Overload
---@param data table
function Player:OnConnect(data)

    self:SetValue("characterId", data.id);
    self:SetValue("firstname", data.firstname);
    self:SetValue("lastname", data.lastname);
    self:SetValue("position", self:InitPosition(data));
    self:SetValue("rotation", self:InitRotation(data));
    self:SetValue("skin", self:InitSkin(data.skin));

    self:Initialize(); --Spawn the player when all data are loaded

    Events.CallRemote(SharedEnums.Player.loaded, self, {
        characterId = data.id,
        firstname = data.firstname,
        lastname = data.lastname,
        skin = self:InitSkin(data.skin),
        position = self:InitPosition(data),
        rotation = self:InitRotation(data)
    });

    GM.Log:debug("[ Player: ".. self:GetFullName() .." ] initialized.");
end

---@private
---GameMode Overload
function Player:Initialize()
    local position = self:GetValue("position");
    local rotation = self:GetValue("rotation");
    local playerCharacter = self:AddCharacter(self:GetSkin(), position, rotation);
    local weapon = Enums.Weapons.AK74U_CUSTOM();
    weapon:SetAutoReload(false);
    weapon:SetAmmoBag(10000);
    weapon:SetAmmoClip(0);
    playerCharacter:PickUp(weapon);
    if (Config.player.firstPersonOnly) then
        playerCharacter:SetCameraMode(CameraMode.FPSOnly);
    end
end

---GameMode Overload
---@private
---@param playerPosition table
---@return Vector
function Player:InitPosition(playerPosition)
    local position = Config.player.defaultPosition;
    if (
        playerPosition.posX 
        and playerPosition.posY 
        and playerPosition.posZ 
        and playerPosition.posX ~= ""
        and playerPosition.posY ~= ""
        and playerPosition.posZ ~= ""
    ) then
        return Vector(
            playerPosition.posX,
            playerPosition.posY,
            playerPosition.posZ
        );
    end
    return Vector(
        position.X, 
        position.Y, 
        position.Z
    )
end

---GameMode Overload
---@param playerRotation number
---@private
---@return Rotator
function Player:InitRotation(playerRotation)
    if (playerRotation.Yaw and playerRotation.Yaw ~= "") then
        return Rotator(0, playerRotation.Yaw, 0);
    end
    return Rotator(0, Config.player.defaultPosition.Yaw, 0);
end

---GameMode Overload
---@private
---@param playerSkin string
---@return string
function Player:InitSkin(playerSkin)
    local skin = Config.player.defaultSkin;
    if (playerSkin) then
        skin = playerSkin;
    end
    return skin
end

---GameMode Overload
---Handle Respawning player
---@private
function Player:HandleRespawn()
    local playerCharacter = self:GetControlledCharacter();
    Timer.SetTimeout(function()
        if (playerCharacter and playerCharacter:IsValid()) then
            GM.Log:info(string.format("Respawning Player [%s] %s...", self:GetSteamID(), self:GetFullName()));
            if (playerCharacter:GetHealth() ~= 0) then return end
            local position, rotation = self:GetPosition(), self:GetRotation();
            playerCharacter:Respawn(position, Rotator(0, rotation.Yaw, 0));
        else
            GM.Log:warn(string.format("Player [%s] %s character is not valid, cannot respawn.", self:GetSteamID(), self:GetFullName()));
        end
    end, Config.player.respawnTimer * 1000);
end

---GameMode Overload
---@return number
function Player:GetCharacterId()
    return self:GetValue("characterId");
end

---GameMode Overload
---@return string
function Player:GetFirstName()
    return self:GetValue("firstname");
end

---GameMode Overload
---@param name string
---@return void
function Player:SetFirstName(name)
    self:SetValue("firstname", name);
end

---GameMode Overload
---@return string
function Player:GetLastName()
    return self:GetValue("lastname");
end

---GameMode Overload
---@param name string
---@return void
function Player:SetLastName(name)
    self:SetValue("lastname", name);
end

---GameMode Overload
---@return string
function Player:GetFullName()
    local firstname = self:GetValue("firstname");
    local lastname = self:GetValue("lastname");
    if  (firstname == nil or lastname == nil) then
        return self:GetName();
    end
    return string.format("%s %s", firstname, lastname);
end

---GameMode Overload
---@return Vector
function Player:GetPosition()
    local character = self:GetControlledCharacter();
    if (character) then
        return character:GetLocation();
    end
    return Vector();
end

---GameMode Overload
---@param vector Vector
function Player:SetPosition(vector)
    local character = self:GetControlledCharacter();
    if (character) then
        character:SetLocation(vector or Vector());
    end
end

---GameMode Overload
---@return Rotator
function Player:GetRotation()
    local character = self:GetControlledCharacter();
    if (character) then
        return character:GetRotation();
    end
    return Rotator();
end

---GameMode Overload
---@param rotator Rotator
function Player:SetRotation(rotator)
    local character = self:GetControlledCharacter();
    if (character) then
        character:SetRotation(rotator or Rotator());
    end
end

---GameMode Overload
function Player:GetSkin()
    return self:GetValue("skin");
end

---GameMode Overload
---@param skin string
---@return void
function Player:SetSkin(skin)
    self:SetValue("skin", skin);
end

---GameMode Overload
---@param skin string
---@param vector? Vector
---@param rotator? Rotator
---@return Character
function Player:AddCharacter(skin, vector, rotator)
    local oldCharacter = self:GetControlledCharacter();
    local position = vector or self:GetPosition();
    local rotation = rotator or self:GetRotation();

    if (oldCharacter) then self:RemoveCharacter(); end
    local newCharacter = Character(position, rotation, skin or "nanos-world::SK_Mannequin");
    self:Possess(newCharacter);
    return newCharacter;
end

---GameMode Overload
---@return boolean
function Player:RemoveCharacter()
    local character = self:GetControlledCharacter();
    if (character) then
        self:UnPossess();
        character:Destroy();
        return true;
    end
    return false;
end

---GameMode Overload
---@return boolean | nil
function Player:IsInNoClip()
    return self:GetValue("NoClip");
end

---@private
---GameMode Overload
---@param state boolean | nil
function Player:SetInNoClip(state)
    self:SetValue("NoClip", state);
end

---GameMode Overload
---Enable player no clip
function Player:EnableNoClip()
    local character = self:GetControlledCharacter();
    if (not self:IsInNoClip()) then
        self:SetValue("LastViewMode", character:GetViewMode());
        character:SetViewMode(ViewMode.FPS);
        self:SetInNoClip(true);
        character:SetCollision(CollisionType.NoCollision);
        character:SetFlyingMode(true);
        character:SetInvulnerable(true);
        character:SetVisibility(false);
        character:SetRagdollMode(false);
    end
end

---Disable player no clip
function Player:DisableNoClip()
    local character = self:GetControlledCharacter();
    if (self:IsInNoClip()) then
        character:SetCollision(CollisionType.Auto);
        character:SetFlyingMode(false);
        character:SetHighFallingTime(-1);
        character:SetFallDamageTaken(0);
        self:onDisablingNoClip();
    end
end

---Toggle player no clip
function Player:ToggleNoClip()
    if (self:IsInNoClip()) then
        self:DisableNoClip();
    else
        self:EnableNoClip();
    end
end

function Player:OnDisablingNoClip()
    local this = self;
    ---@param character Character
    local function run(character, old_state, new_state)
        if (new_state == FallingMode.None) then
            local player = GM.Server.utils.Entity:IsPlayerAndOfType(character, Character);
            if (player) then
                if (player:IsInNoClip()) then
                    character:SetInvulnerable(false);
                    character:SetVisibility(true);
                    character:SetHighFallingTime(1);
                    character:SetFallDamageTaken(10);
                    character:SetViewMode(player:GetValue("LastViewMode"));
                    character:Unsubscribe("FallingModeChanged", run);
                    player:SetInNoClip(false);
                end
            end
        end
    end
    this:GetControlledCharacter():Subscribe("FallingModeChanged", run);
end
