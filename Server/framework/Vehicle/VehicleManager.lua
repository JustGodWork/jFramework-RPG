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

---@class VehicleManager
local VehicleManager = {}

function VehicleManager:new()
    ---@type VehicleManager
    local self = {}
    setmetatable(self, { __index = VehicleManager});

    self.vehicles = {}

    jShared.log:debug("[ VehicleManager ] initialized.");

    return self;
end

---@return boolean
function VehicleManager:modelExist(modelName)
    return Enums.Vehicles[modelName] ~= nil
end

---@return Vehicle[]
function VehicleManager:getVehicles()
    return self.vehicles
end

---@param vehicleId number
---@return Vehicle
function VehicleManager:getVehicleFromId(vehicleId)
    return self.vehicles[vehicleId]
end

---@param modelName string Enums.Vehicles[modelName]
---@param location Vector
---@param rotation Rotator
---@return Vehicle
function VehicleManager:create(modelName, location, rotation)
    if (not self:modelExist(modelName)) then
        jShared.log:warn("VehicleManager:create(): The model ["..modelName.."] does not exist.")
        return
    end

    local vehicleId = (#self.vehicles + 1)
    self.vehicles[vehicleId] = Enums.Vehicles[modelName](location, rotation)
    self.vehicles[vehicleId]:SetValue("vehicleId", vehicleId)
    return self.vehicles[vehicleId]
end

---@param id number
---@return boolean
function VehicleManager:deleteById(id)
    if (self.vehicles[id]) then
        self.vehicles[id] = nil
        return true
    else
        jShared.log:warn("VehicleManager:deleteById(): Vehicle [".. id .."] not found")
        return false
    end
end

jServer.vehicleManager = VehicleManager:new()
