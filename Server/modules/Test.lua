--[[
----
----Created Date: 12:05 Saturday October 1st 2022
----Author: JustGod
----Made with ❤
----
----File: [Test]
----
----Copyright (c) 2022 JustGodWork, All Rights Reserved.
----This file is part of JustGodWork project.
----Unauthorized using, copying, modifying and/or distributing of this file
----via any medium is strictly prohibited. This code is confidential.
----
--]]

local trigger = Trigger(Vector(6301, 1171, 998), Rotator(), Vector(250, 250, 250), TriggerType.Box, true, Color(0, 0, 1))

trigger:Subscribe("BeginOverlap", function (self, entity)
    local player = jServer.utils.entity:isPlayerAndOfType(entity, Character);
    if (player) then
        player:ToggleNoClip();
    end
end);

trigger:Subscribe("EndOverlap", function (self, entity)
    local player = jServer.utils.entity:isPlayerAndOfType(entity, Character);
    if (player) then
        player:ToggleNoClip();
    end
end)


--[[
local function sabre()
    local crowbar = Melee(
        Vector(-900, 185, 215),
        Rotator(0, 90, 90),
        "stwr-sabre::SM_sabrelasergreen",
        CollisionType.Normal,
        true,
        HandlingMode.SingleHandedMelee,
        "", 
        true
    );

    crowbar:SetScale(Vector(1.5, 1.5, 1.5))
    crowbar:AddAnimationCharacterUse("nanos-world::AM_Mannequin_Melee_Slash_Attack", AnimationSlotType.UpperBody)
    crowbar:SetDamageSettings(0.3, 0.5)
    crowbar:SetCooldown(1.0)
    crowbar:SetBaseDamage(40)
    return crowbar;
end
]]