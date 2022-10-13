---
---Created Date: 23:31 26/09/2022
---Author: JustGod
---Made with ❤

---File: [Vehicle]

---Copyright (c) 2022 JustGodWork, All Rights Reserved.
---This file is part of JustGodWork project.
---Unauthorized using, copying, modifying and/or distributing of this file
---via any medium is strictly prohibited. This code is confidential.
---

---@param plate string
---@param syncWithClient boolean
function Vehicle:SetPlate(plate, syncWithClient)
    self:SetValue("plate", plate, syncWithClient)
end

---@return string
function Vehicle:GetPlate()
    return self:GetValue("plate")
end