---
--- @author Azagal
--- Create at [25/09/2022] 22:41:35
--- Current project [jframework]
--- File name [VehicleManager]
---
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
    return eVEHICLES[modelName] ~= nil
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

---@param modelName string eVEHICLES[]
---@param location Vector
---@param rotation Rotator
---@return Vehicle
function VehicleManager:create(modelName, location, rotation)
    if (not self:modelExist(modelName)) then
        jShared.log:warn("VehicleManager:create(): The model ["..modelName.."] does not exist.")
        return
    end

    local vehicleId = (#self.vehicles + 1)
    self.vehicles[vehicleId] = eVEHICLES[modelName](location, rotation)
    self.vehicles[vehicleId]:SetValue("vehicleId", vehicleId)
    return self.vehicles[vehicleId]
end

---@param self Vehicle
Vehicle.Subscribe("Destroy", function(self)
    local vehicleId = self:GetValue("vehicleId")
    if (not vehicleId) then
        return
    end
    VehicleManager.vehicles[vehicleId] = nil
end)

jServer.commandManager:register("VehicleManager:spawnVehicle", function(player, args)
    local createdVehicle = VehicleManager:create(args[1] or "SUV", player:GetControlledCharacter():GetLocation(), player:GetControlledCharacter():GetRotation())
    player:GetControlledCharacter():EnterVehicle(createdVehicle)
end)

---@param player Player
jServer.commandManager:register("VehicleManager:deleteVehicle", function(player)
    local PLAYER_IN_VEHICLE = player:GetControlledCharacter():GetVehicle()
    if (PLAYER_IN_VEHICLE == nil or PLAYER_IN_VEHICLE:GetValue("vehicleId") == nil) then
        return
    end
    PLAYER_IN_VEHICLE:Destroy()
end)

jServer.vehicleManager = VehicleManager:new()
