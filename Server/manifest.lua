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
Package.Require("framework/Enums/manifest.lua");

--Utils
Package.Require("framework/Utils/manifest.lua");

--Database
Package.Require("framework/Database/repository/entities/Repository.lua");
Package.Require("framework/Database/repository/RepositoryManager.lua");

--Commands
Package.Require("framework/Command/entities/Command.lua");
Package.Require("framework/Command/CommandManager.lua");
Package.Require("framework/Command/Commands.lua");
Package.Require("framework/Command/Events.lua");

--Items
Package.Require("framework/Item/entities/ItemStack.lua");
--Package.Require("Item/entities/ItemMeta.lua");
--Package.Require("Item/entities/Item.lua");
Package.Require("framework/Item/ItemManager.lua");
Package.Require("framework/Item/ItemRegister.lua");

--Accounts
--Package.Require("Account/entities/Account.lua");
--Package.Require("Account/AccountManager.lua");

--Inventories
Package.Require("framework/Inventory/entities/Inventory.lua");
Package.Require("framework/Inventory/InventoryManager.lua");
Package.Require("framework/Inventory/Events.lua");

--Storages
--Package.Require("Storage/entities/Storage.lua");
--Package.Require("Storage/StorageManager.lua");

--Players
Package.Require("framework/Player/entities/Player.lua");
Package.Require("framework/Player/PlayerManager.lua");
Package.Require("framework/Player/Events.lua");
Package.Require("framework/Player/Commands.lua");

--Vehicles
Package.Require("framework/Vehicle/entities/Vehicle.lua");
Package.Require("framework/Vehicle/VehicleManager.lua");
Package.Require("framework/Vehicle/Commands.lua");

--MODULES
Package.Require("modules/Modules.lua");