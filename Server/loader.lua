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
jServer:loadFrameworkModule("Database/MySQL.lua");
jServer:loadFrameworkModule("Database/repository/entities/Repository.lua");
jServer:loadFrameworkModule("Database/repository/RepositoryManager.lua");
jServer:loadFrameworkModule("Account/entities/Account.lua");
jServer:loadFrameworkModule("Account/AccountManager.lua");
jServer:loadFrameworkModule("Item/entities/Item.lua");
jServer:loadFrameworkModule("Item/ItemManager.lua");
jServer:loadFrameworkModule("Inventory/entities/Inventory.lua");
jServer:loadFrameworkModule("Inventory/InventoryManager.lua");
jServer:loadFrameworkModule("Storage/entities/Storage.lua");
jServer:loadFrameworkModule("Storage/StorageManager.lua");
jServer:loadFrameworkModule("Player/entities/Player.lua");
jServer:loadFrameworkModule("Player/PlayerManager.lua");
jServer:loadFrameworkModule("Player/ConnexionHandler.lua");

--MODULES
jServer:loadModule("test.lua");