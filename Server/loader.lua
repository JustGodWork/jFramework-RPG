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
jServer:loadFrameworkModule("Enums/loader.lua");

--Utils
jServer:loadFrameworkModule("Utils/Utils.lua");

--Database
jServer:loadFrameworkModule("Database/repository/entities/Repository.lua");
jServer:loadFrameworkModule("Database/repository/RepositoryManager.lua");

--Commands
jServer:loadFrameworkModule("Command/entities/Command.lua");
jServer:loadFrameworkModule("Command/CommandManager.lua");
jServer:loadFrameworkModule("Command/Commands.lua");
jServer:loadFrameworkModule("Command/Events.lua");

--Items
jServer:loadFrameworkModule("Item/entities/ItemStack.lua");
--jServer:loadFrameworkModule("Item/entities/ItemMeta.lua");
--jServer:loadFrameworkModule("Item/entities/Item.lua");
jServer:loadFrameworkModule("Item/ItemManager.lua");
jServer:loadFrameworkModule("Item/ItemRegister.lua");

--Accounts
--jServer:loadFrameworkModule("Account/entities/Account.lua");
--jServer:loadFrameworkModule("Account/AccountManager.lua");

--Inventories
jServer:loadFrameworkModule("Inventory/entities/Inventory.lua");
jServer:loadFrameworkModule("Inventory/InventoryManager.lua");
jServer:loadFrameworkModule("Inventory/Events.lua");

--Storages
--jServer:loadFrameworkModule("Storage/entities/Storage.lua");
--jServer:loadFrameworkModule("Storage/StorageManager.lua");

--Players
jServer:loadFrameworkModule("Player/entities/Player.lua");
jServer:loadFrameworkModule("Player/PlayerManager.lua");
jServer:loadFrameworkModule("Player/Events.lua");
jServer:loadFrameworkModule("Player/Commands.lua");

--Vehicles
jServer:loadFrameworkModule("Vehicle/entities/Vehicle.lua");
jServer:loadFrameworkModule("Vehicle/VehicleManager.lua");
jServer:loadFrameworkModule("Vehicle/Commands.lua");

--MODULES
jServer:loadModule("World/World.lua");
jServer:loadModule("Test.lua");