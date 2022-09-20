--FRAMEWORK
jServer:loadFrameworkModule("Database/MySQL.lua");
jServer:loadFrameworkModule("Database/repository/entities/Repository.lua");
jServer:loadFrameworkModule("Database/repository/RepositoryManager.lua");
jServer:loadFrameworkModule("Account/entities/Account.lua");
jServer:loadFrameworkModule("Account/AccountManager.lua");
-- jServer:loadFrameworkModule("Inventory/entities/Inventory.lua");
-- jServer:loadFrameworkModule("Inventory/InventoryManager.lua");
-- jServer:loadFrameworkModule("Storage/entities/Storage.lua");
-- jServer:loadFrameworkModule("Storage/StorageManager.lua");
jServer:loadFrameworkModule("Player/entities/Player.lua");
jServer:loadFrameworkModule("Player/PlayerManager.lua");

--MODULES
jServer:loadModule("test.lua");