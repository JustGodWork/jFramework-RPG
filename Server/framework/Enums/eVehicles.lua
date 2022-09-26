--[[
--Created Date: Friday September 23rd 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Friday September 23rd 2022 10:13:08 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

---THIS CODE IS JUST FOR TESTING PURPOSES
---THIS WILL BE REMOVED IN THE FUTURE (VehicleManager will be added)
---Big thanks to https://github.com/nanos-world/nanos-world-vehicles/blob/main/Server/Index.lua
Enums.Vehicles = {
	SUV = function(location, rotation)
		local vehicle = Vehicle(location or Vector(), rotation or Rotator(), "nanos-world::SK_SUV", CollisionType.Normal, true, false, true, "nanos-world::A_Vehicle_Engine_14")

		vehicle:SetEngineSetup(800, 4500)
		vehicle:SetAerodynamicsSetup(2000, 0.3, 500, 210, 0.5)
		vehicle:SetSteeringWheelSetup(Vector(0, 20, 131), 26)

		vehicle:SetWheel(0, "Wheel_Front_Left", 34, 20, 50, Vector(), false, true, false, false, false, 1500, 3000, 1200, 1, 2, 20, 20, 150, 30, 6, 10, 0, 0.5, 0.7)
		vehicle:SetWheel(1, "Wheel_Front_Right", 34, 20, 50, Vector(), false, true, false, false, false, 1500, 3000, 1200, 1, 2, 20, 20, 150, 30, 6, 10, 0, 0.5, 0.7)
		vehicle:SetWheel(2, "Wheel_Rear_Left", 34, 20, 0, Vector(0, 0, 0), true, true, true, false, false, 1500, 3000, 1200, 1, 5, 20, 20, 150, 30, 6, 10, 0, 0.5, 0.7)
		vehicle:SetWheel(3, "Wheel_Rear_Right", 34, 20, 0, Vector(0, 0, 0), true, true, true, false, false, 1500, 3000, 1200, 1, 5, 20, 20, 150, 30, 6, 10, 0, 0.5, 0.7)

		vehicle:SetDoor(0, Vector( 22, -80, 120), Vector(-18, -47, 110), Rotator(0, 0, 15), 75, -150)
		vehicle:SetDoor(1, Vector( 22,  80, 120), Vector( 5,   47, 105), Rotator(0, 0,  0), 60,  150)
		vehicle:SetDoor(2, Vector(-80, -80, 120), Vector(-60, -39,  90), Rotator(0, 0,  0), 60, -150)
		vehicle:SetDoor(3, Vector(-80,  80, 120), Vector(-60,  39,  90), Rotator(0, 0,  0), 60,  150)

		vehicle:RecreatePhysics()
		return vehicle
	end,
	Hatchback = function(location, rotation)
		local vehicle = Vehicle(location or Vector(), rotation or Rotator(), "nanos-world::SK_Hatchback", CollisionType.Normal, true, false, true, "nanos-world::A_Vehicle_Engine_01")

		vehicle:SetEngineSetup(1200, 6500, 1200, 0.03, 6, 600)
		vehicle:SetAerodynamicsSetup(1200, 0.3, 500, 200, 0.3)
		vehicle:SetSteeringWheelSetup(Vector(0, 27, 130), 24)
		vehicle:SetHeadlightsSetup(Vector(270, 0, 70))

		vehicle:SetWheel(0, "Wheel_Front_Left",  26, 17, 42, Vector(), false, true, false, false, false, 2200, 3000, 1500, 1, 2.9, 20, 20, 100, 25, 4, 4, 0, 0.5, 0.6)
		vehicle:SetWheel(1, "Wheel_Front_Right", 26, 17, 42, Vector(), false, true, false, false, false, 2200, 3000, 1500, 1, 2.9, 20, 20, 100, 25, 4, 4, 0, 0.5, 0.6)
		vehicle:SetWheel(2, "Wheel_Rear_Left",   26, 17,  0, Vector(), true, true,  true, false, false, 2200, 3000, 1500, 1, 4, 20, 20, 100, 25, 4, 4, 0, 0.5, 0.6)
		vehicle:SetWheel(3, "Wheel_Rear_Right",  26, 17,  0, Vector(), true, true,  true, false, false, 2200, 3000, 1500, 1, 4, 20, 20, 100, 25, 4, 4, 0, 0.5, 0.6)

		vehicle:SetDoor(0, Vector(25, -80, 100), Vector( 0, -47, 80), Rotator(0, 0, 10), 60, -150)
		vehicle:SetDoor(1, Vector(25,  80, 100), Vector(12,  47, 80), Rotator(0, 0,  0), 60,  150)

		vehicle:RecreatePhysics()
		return vehicle
	end,
	Pickup = function(location, rotation)
		local vehicle = Vehicle(location or Vector(), rotation or Rotator(), "nanos-world::SK_Pickup", CollisionType.Normal, true, false, true, "nanos-world::A_Vehicle_Engine_10")
        vehicle:SetEngineSetup(550, 5000)
        vehicle:SetAerodynamicsSetup(2000, 0.4, 500, 200, 0.4)
        vehicle:SetSteeringWheelSetup(Vector(0, 27, 120), 24)
        vehicle:SetHeadlightsSetup(Vector(270, 0, 70))

        vehicle:SetWheel(0, "Wheel_Front_Left",  30, 18, 45, Vector(), true, true, false, false, false, 1800, 3500, 1500, 1, 2, 20, 20, 350, 60, 6, 10, 0, 0.4, 0.6)
        vehicle:SetWheel(1, "Wheel_Front_Right", 30, 18, 45, Vector(), true, true, false, false, false, 1800, 3500, 1500, 1, 2, 20, 20, 350, 60, 6, 10, 0, 0.4, 0.6)
        vehicle:SetWheel(2, "Wheel_Rear_Left",   30, 18,  0, Vector(), true, true,  true, false, false, 1800, 3500, 1500, 1, 2, 20, 20, 350, 60, 6, 10, 0, 0.4, 0.6)
        vehicle:SetWheel(3, "Wheel_Rear_Right",  30, 18,  0, Vector(), true, true,  true, false, false, 1800, 3500, 1500, 1, 2, 20, 20, 350, 60, 6, 10, 0, 0.4, 0.6)

		vehicle:SetDoor(0, Vector(  50, -75, 105), Vector(   8, -32.5,  95), Rotator(0,  0,  10), 70, -150)
		vehicle:SetDoor(1, Vector(  50,  75, 105), Vector(  25,    50,  90), Rotator(0,  0,   0), 70,  150)
		vehicle:SetDoor(2, Vector( -90, -75, 130), Vector( -90,  -115, 155), Rotator(0,  90, 20), 60, -150)
		vehicle:SetDoor(3, Vector( -90,  75, 130), Vector( -90,   115, 155), Rotator(0, -90, 20), 60,  150)
		vehicle:SetDoor(4, Vector(-195, -75, 130), Vector(-195,  -115, 155), Rotator(0,  90, 20), 60, -150)
		vehicle:SetDoor(5, Vector(-195,  75, 130), Vector(-195,   115, 155), Rotator(0, -90, 20), 60,  150)

		vehicle:RecreatePhysics()
		return vehicle
	end,
	SportsCar = function(location, rotation)
		local vehicle = Vehicle(location or Vector(), rotation or Rotator(), "nanos-world::SK_SportsCar", CollisionType.Normal, true, false, true, "nanos-world::A_Vehicle_Engine_05")

		vehicle:SetEngineSetup(1600, 7500, 2000, 0.05, 10, 600)
		vehicle:SetAerodynamicsSetup(1200, 0.2, 520, 240, 0.4)
		vehicle:SetTransmissionSetup(3.5, 6000, 3000, 0.1, 0.97)
		vehicle:SetSteeringWheelSetup(Vector(0, 38, 115), 17)

		vehicle:SetWheel(0, "Wheel_Front_Left", 31, 27, 50, Vector(), false, true, false, false, false, 4000, 4500, 1000, 1, 2.7, 20, 20, 70, 10, 6, 6, 0, 0.5, 0.4)
		vehicle:SetWheel(1, "Wheel_Front_Right", 31, 27, 50, Vector(), false, true, false, false, false, 4000, 4500, 1000, 1, 2.7, 20, 20, 70, 10, 6, 6, 0, 0.5, 0.4)
		vehicle:SetWheel(2, "Wheel_Rear_Left", 35, 37, 0, Vector(0, 0, 0), true, true, true, false, false, 4000, 4500, 1500, 1, 4, 20, 20, 70, 10, 6, 6, 0, 0.5, 0.4)
		vehicle:SetWheel(3, "Wheel_Rear_Right", 35, 37, 0, Vector(0, 0, 0), true, true, true, false, false, 4000, 4500, 1500, 1, 4, 20, 20, 70, 10, 6, 6, 0, 0.5, 0.4)

		vehicle:SetDoor(0, Vector(25, -95, 100), Vector(35, -42, 55), Rotator(0, 0, -10), 75, -150)
		vehicle:SetDoor(1, Vector(25,  95, 100), Vector(35,  42, 60), Rotator(0, 0, -15), 75,  150)

		vehicle:RecreatePhysics()
		return vehicle
	end,
	TruckBox = function(location, rotation)
		local vehicle = Vehicle(location or Vector(), rotation or Rotator(), "nanos-world::SK_Truck_Box", CollisionType.Normal, true, false, true, "nanos-world::A_Vehicle_Engine_08")

		vehicle:SetEngineSetup(600, 5700)
		vehicle:SetAerodynamicsSetup(3500, 0.6, 740, 240, 0.3)
		vehicle:SetSteeringWheelSetup(Vector(0, 41, 120), 26)
		vehicle:SetHeadlightsSetup(Vector(360, 0, 100))


		vehicle:SetWheel(0, "Wheel_Front_Left",    43, 20, 40, Vector(), false, true, false, true, false, 3500, 4500, 1000, 1, 1, 20, 20, 400, 100, 10, 10, 0, 0.5, 0.3)
		vehicle:SetWheel(1, "Wheel_Front_Right",   43, 20, 40, Vector(), false, true, false, true, false, 3500, 4500, 1000, 1, 1, 20, 20, 400, 100, 10, 10, 0, 0.5, 0.3)
		vehicle:SetWheel(2, "Wheel_Rear_Left", 43, 40, 0, Vector(0, 0, 0), true, true, true, true, false, 3500, 4500, 2000, 1, 2, 20, 20, 800, 120, 10, 5, 0, 0.5, 0.3)
		vehicle:SetWheel(3, "Wheel_Rear_Right",43, 40, 0, Vector(0, 0, 0), true, true, true, true, false, 3500, 4500, 2000, 1, 2, 20, 20, 800, 120, 10, 5, 0, 0.5, 0.3)

		vehicle:SetDoor(0, Vector(235, -100, 132), Vector(210, -56, 150), Rotator(0, 0, 20), 100, -150)
		vehicle:SetDoor(1, Vector(235,  100, 132), Vector(225,  60, 147), Rotator(0, 0, 10), 100,  150)

		vehicle:RecreatePhysics()
		return vehicle
	end,
	TruckChassis = function(location, rotation)
		local vehicle = Vehicle(location or Vector(), rotation or Rotator(), "nanos-world::SK_Truck_Chassis", CollisionType.Normal, true, false, true, "nanos-world::A_Vehicle_Engine_08")

		vehicle:SetEngineSetup(600, 5700)
		vehicle:SetAerodynamicsSetup(2000, 0.4, 650, 220, 0.3)
		vehicle:SetSteeringWheelSetup(Vector(0, 41, 120), 26)
		vehicle:SetHeadlightsSetup(Vector(360, 0, 100))

		vehicle:SetWheel(0, "Wheel_Front_Left",    43, 20, 40, Vector(), false, true, false, true, false, 3500, 4500, 1000, 1, 1, 20, 20, 400, 100, 10, 10, 0, 0.5, 0.3)
		vehicle:SetWheel(1, "Wheel_Front_Right",   43, 20, 40, Vector(), false, true, false, true, false, 3500, 4500, 1000, 1, 1, 20, 20, 400, 100, 10, 10, 0, 0.5, 0.3)
		vehicle:SetWheel(2, "Wheel_Rear_Left", 43, 40, 0, Vector(0, 0, 0), true, true, true, true, false, 3500, 4500, 2000, 1, 2, 20, 20, 800, 120, 10, 5, 0, 0.5, 0.3)
		vehicle:SetWheel(3, "Wheel_Rear_Right",43, 40, 0, Vector(0, 0, 0), true, true, true, true, false, 3500, 4500, 2000, 1, 2, 20, 20, 800, 120, 10, 5, 0, 0.5, 0.3)

		vehicle:SetDoor(0, Vector(235, -100, 132), Vector(210, -56, 150), Rotator(0, 0, 20), 100, -150)
		vehicle:SetDoor(1, Vector(235,  100, 132), Vector(225,  60, 147), Rotator(0, 0, 10), 100,  150)

		vehicle:RecreatePhysics()
		return vehicle
	end,
}