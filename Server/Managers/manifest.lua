--[[
--Created Date: Tuesday September 20th 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Tuesday September 20th 2022 3:04:31 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

--FRAMEWORK

--Enums
Package.Require("Enums/manifest.lua");

--Utils
Package.Require("Utils/manifest.lua");

--Database
Package.Require("Database/repository/entities/Repository.lua");
Package.Require("Database/repository/RepositoryManager.lua");

--Commands
Package.Require("Command/entities/Command.lua");
Package.Require("Command/CommandManager.lua");
Package.Require("Command/Events.lua");

--Items
Package.Require("Item/entities/Item.lua");
Package.Require("Item/entities/ItemStack.lua");
Package.Require("Item/ItemManager.lua");

--Inventories
Package.Require("Inventory/entities/Inventory.lua");
Package.Require("Inventory/InventoryManager.lua");
Package.Require("Inventory/Events.lua");

--Players
Package.Require("Player/entities/Player.lua");
Package.Require("Player/PlayerManager.lua");
Package.Require("Player/Events.lua");

--Vehicles
Package.Require("Vehicle/entities/Vehicle.lua");
Package.Require("Vehicle/VehicleManager.lua");