---
---Created Date: 22:19 26/09/2022
---Author: JustGod
---Made with ❤

---File: [Events]

---Copyright (c) 2022 JustGodWork, All Rights Reserved.
---This file is part of JustGodWork project.
---Unauthorized using, copying, modifying and/or distributing of this file
---via any medium is strictly prohibited. This code is confidential.
---

---@param self Vehicle
Vehicle.Subscribe("Destroy", function(self)
    local vehicleId = self:GetValue("vehicleId")
    if (vehicleId) then
        GM.Server.VehicleManager:DeleteById(vehicleId);
    end
end)