
---@param location Vector
---@param rotation Rotator
---@param model string
---@return Vehicle
function SpawnVehicle(location, rotation, model, data)
    -- Spawns a Pickup Vehicle
    local vehicle = Vehicle(location or Vector(), rotation or Rotator(), model or "nanos-world::SK_Pickup", CollisionType.Normal, true, false, true, "nanos-world::A_Vehicle_Engine_10")
    -- Configure it's Engine power and Aerodynamics
    vehicle:SetEngineSetup(data.torque or 5000, data.rpm or 11000, 2000)
    vehicle:SetAerodynamicsSetup(5500, 0.3, 100, nil, 50)

    -- Configure it's Steering Wheel and Headlights location
    vehicle:SetSteeringWheelSetup(Vector(0, 27, 120), 24)
    vehicle:SetHeadlightsSetup(Vector(270, 0, 70))

    -- Configures each Wheel
    vehicle:SetWheel(0, "Wheel_Front_Left",  27, 18, 45, Vector(), false,  true, false, false, false, 1500, 3000, 1000, 1, 6, 20, 20, 250, 50, 10, 10, 0, 0.5, 0.5)
    vehicle:SetWheel(1, "Wheel_Front_Right", 27, 18, 45, Vector(), false,  true, false, false, false, 1500, 3000, 1000, 1, 6, 20, 20, 250, 50, 10, 10, 0, 0.5, 0.5)
    vehicle:SetWheel(2, "Wheel_Rear_Left",   27, 18,  0, Vector(), true, true,  true, false, false, 1500, 10000, 1000, 1, 4, 20, 20, 250, 50, 10, 10, 0, 0.5, 0.5)
    vehicle:SetWheel(3, "Wheel_Rear_Right",  27, 18,  0, Vector(), true, true,  true, false, false, 1500, 10000, 1000, 1, 4, 20, 20, 250, 50, 10, 10, 0, 0.5, 0.5)

    -- Adds 6 Doors/Seats
    vehicle:SetDoor(0, Vector(  50, -75, 105), Vector(   8, -32.5,  95), Rotator(0,  0,  10), 70, -150)
    vehicle:SetDoor(1, Vector(  50,  75, 105), Vector(  25,    50,  90), Rotator(0,  0,   0), 70,  150)
    vehicle:SetDoor(2, Vector( -90, -75, 130), Vector( -90,  -115, 155), Rotator(0,  90, 20), 60, -150)
    vehicle:SetDoor(3, Vector( -90,  75, 130), Vector( -90,   115, 155), Rotator(0, -90, 20), 60,  150)
    vehicle:SetDoor(4, Vector(-195, -75, 130), Vector(-195,  -115, 155), Rotator(0,  90, 20), 60, -150)
    vehicle:SetDoor(5, Vector(-195,  75, 130), Vector(-195,   115, 155), Rotator(0, -90, 20), 60,  150)

    -- Make it ready (so clients only create Physics once and not for each function call above)
    vehicle:RecreatePhysics()
    return vehicle
end

--jServer.accountManager:register("testId", "testName", "testLabel", "testOwner", 1000, 0)
--jServer.accountManager:register("testId2", "testName2", "testLabel2", "testOwner2", 1200, 0)

--[[local acc = jServer.accountManager:getByOwner("testOwner", "testName")
print(acc:getId(), acc:getName(), acc:getLabel(), acc:getOwner(), acc:getMoney(), acc:getType())
local acc2 = jServer.accountManager:getByOwner("testOwner2", "testName2")
print(acc2:getId(), acc2:getName(), acc2:getLabel(), acc2:getOwner(), acc2:getMoney(), acc2:getType())]]

--print(jServer.modules.world.time:getHour(), jServer.modules.world.time:getMinute())