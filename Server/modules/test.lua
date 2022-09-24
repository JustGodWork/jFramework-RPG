
---@param location Vector
---@param rotation Rotator
---@param model string
---@return Vehicle
local function SpawnVehicle(location, rotation, model, data)
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

--Spawning WTF pickup
jServer.commandManager:register("diable", function(player, args)
    local location = player:GetControlledCharacter():GetLocation();
    local vehicle = SpawnVehicle(location, player:GetControlledCharacter():GetRotation(), nil, {
        torque = tonumber(args[1]),
        rpm = tonumber(args[2])
    })
    player:GetControlledCharacter():EnterVehicle(vehicle)
end)

--Temporary add Items here for testing
--[[jServer.itemManager:addItem("1", "bread", "Bread", {}, "food", 1, false);

--Waiting for player connection before testing inventories, items and accounts :)
Events.Subscribe("onPlayerConnecting", function(player) 
    --Testing accounts
    local id = player:getCharacterId();
    local account = jServer.accountManager:getByOwner(id, "bank")
    jShared.log:info("Player bank: ", account:getMoney());

    --Testing inventories
    local inventory = jServer.inventoryManager:getByOwner(id, "main");
    inventory:addItem("bread", 1);
    jShared.log:info("Player inventory: ", inventory:getItems());
    Timer.SetTimeout(function()
        inventory:getItem("bread"):use(player);
        jShared.log:info("Player inventory after: ", inventory:getItems());
    end, 2000);
end);

jServer.itemManager:setItemCallback("bread", function(player, item)
    -- Remove the item from the player inventory
    -- You can trigger this in an event with the inventory id to remove item in.
    local inventory = jServer.inventoryManager:getByOwner(player:getCharacterId(), "main");
    if (inventory:removeItem(item:getName(), 1)) then
        Server.SendChatMessage(player, "You have eaten a bread!");
    end

    --Do stuff here like adding hunger
end);]]--