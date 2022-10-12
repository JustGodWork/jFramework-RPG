---
---Created Date: 22:20 26/09/2022
---Author: JustGod
---Made with ❤

---File: [Commands]

---Copyright (c) 2022 JustGodWork, All Rights Reserved.
---This file is part of JustGodWork project.
---Unauthorized using, copying, modifying and/or distributing of this file
---via any medium is strictly prohibited. This code is confidential.
---

GM.Server.commandManager:Register("car", function(player, args)
    local character = player:GetControlledCharacter()
    local vehicle = GM.Server.vehicleManager:Create(args[1] or "SUV", character:GetLocation(), character:GetRotation())
    if (vehicle) then
        character:EnterVehicle(vehicle)
    end
    return true;
end)

GM.Server.commandManager:Register("dv", function(player)
    local vehicle = player:GetControlledCharacter():GetVehicle()
    if (vehicle and vehicle:GetValue("vehicleId")) then
        vehicle:Destroy()
    end
    return true;
end)
