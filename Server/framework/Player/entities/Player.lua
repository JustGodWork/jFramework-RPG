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

function Player:onCreate(data)
    local position = Config.player.defaultPosition;
    local heading = Config.player.defaultHeading;

    self:SetValue("character_id", data.id);
    self:SetValue("identifier", self:GetSteamID());
    self:SetValue("firstname", data.firstname);
    self:SetValue("lastname", data.lastname);
    self:SetValue("position", 
        (data.position ~= "" and JSON.parse(data.position))
        or Vector(position.x, position.y, position.z)
    );
    self:SetValue("heading", 
        (data.heading ~= "" and JSON.parse(data.heading))
        or Rotator(heading.x, heading.y, heading.z)
    );
    self:SetValue("skin", (data.skin ~= "" and data.skin or Config.player.defaultSkin));
    self:SetValue("accounts", {});
    self:SetValue("inventories", {});

    self:onConnect()

    if (Config.debug) then
        Package.Log("Server: [Player: ".. self:getFullName() .."] initialized.");
    end
end

function Player:onConnect()
    local playerCharacter = Character(self:getPosition(), self:getHeading(), self:getSkin())
    self:Possess(playerCharacter)

    local character = self:GetControlledCharacter()
    character:Subscribe("Death", function(chara, last_damage_taken, last_bone_damaged, damage_reason, hit_from, instigator)
        if (instigator) then
            if (instigator == self) then
                Server.BroadcastChatMessage("<cyan>" .. instigator:GetName() .. "</> committed suicide")
            else
                Server.BroadcastChatMessage("<cyan>" .. instigator:GetName() .. "</> killed <cyan>" .. self:GetName() .. "</>")
            end
        else
            Server.BroadcastChatMessage("<cyan>" .. self:GetName() .. "</> died")
        end
    
        -- Respawns the Character after 5 seconds, we Bind the Timer to the Character, this way if the Character gets destroyed in the meanwhile, this Timer never gets destroyed
        Timer.Bind(Timer.SetTimeout(function(character)
            self:SetValue("position", character:GetLocation())
            self:SetValue("heading", character:GetRotation())
            -- If he is not dead anymore after 5 seconds, ignores it
            if (character:GetHealth() ~= 0) then return end
            -- Respawns the Character at a random point
            character:Respawn(self:getPosition(), self:getHeading())
        end, 5000, chara), chara)
    end)
end

---@return number
function Player:getCharacterId()
    return self:GetValue("character_id");
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

---@return Vector
function Player:getPosition()
    return self:GetValue("position");
end

---@return Rotator
function Player:getHeading()
    return self:GetValue("heading");
end

---@return Account[]
function Player:getAccounts()
    return self:GetValue("accounts");
end

---@param name string
---@return Account
function Player:getAccount(name)
    return self:GetValue("accounts")[name];
end

---@return Inventory[]
function Player:getInventories()
    return self:GetValue("inventories");
end

---@param name string
---@return Inventory
function Player:getInventory(name)
    return self:GetValue("inventories")[name];
end

function Player:getSkin()
    return self:GetValue("skin");
end

---@param skin string
---@return void
function Player:setSkin(skin)
    self:SetValue("skin", skin);
end