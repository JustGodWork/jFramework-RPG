---
---Created Date: 22:41 25/09/2022
---Author: Azagal
---Made with ❤

---File: [VehicleManager]

---Copyright (c) 2022 JustGodWork, All Rights Reserved.
---This file is part of JustGodWork project.
---Unauthorized using, copying, modifying and/or distributing of this file
---via any medium is strictly prohibited. This code is confidential.
---

---@type VehicleManager
VehicleManager = Class.new(function(class)

    ---@class VehicleManager: BaseObject
    local self = class;

    function self:Constructor()
        self.vehicles = {}
        GM.Log:debug("[ VehicleManager ] initialized.");
    end
    
    ---@return boolean
    function self:ModelExist(modelName)
        return Enums.Vehicles[modelName] ~= nil
    end
    
    ---@return Vehicle[]
    function self:GetVehicles()
        return self.vehicles
    end
    
    ---@param vehicleId number
    ---@return Vehicle
    function self:GetVehicleFromId(vehicleId)
        return self.vehicles[vehicleId]
    end
    
    ---@param modelName string Enums.Vehicles[modelName]
    ---@param location Vector
    ---@param rotation Rotator
    ---@return Vehicle
    function self:Create(modelName, location, rotation)
        if (not self:ModelExist(modelName)) then
            GM.Log:warn("VehicleManager:create(): The model ["..modelName.."] does not exist.")
            return
        end
    
        local vehicleId = (#self.vehicles + 1)
        self.vehicles[vehicleId] = Enums.Vehicles[modelName](location, rotation)
        self.vehicles[vehicleId]:SetValue("vehicleId", vehicleId)
        return self.vehicles[vehicleId]
    end
    
    ---@param id number
    ---@return boolean
    function self:DeleteById(id)
        if (self.vehicles[id]) then
            self.vehicles[id] = nil
            return true
        else
            GM.Log:warn("VehicleManager:deleteById(): Vehicle [".. id .."] not found")
            return false
        end
    end

    return self;
end);