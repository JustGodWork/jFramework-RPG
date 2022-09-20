--FRAMEWORK
jServer:loadFrameworkModule("repository/MySQL.lua");
jServer:loadFrameworkModule("repository/Repository.lua");
jServer:loadFrameworkModule("repository/RepositoryManager.lua");
jServer:loadFrameworkModule("Accounts/entities/Account.lua");
jServer:loadFrameworkModule("Accounts/AccountManager.lua");
jServer:loadFrameworkModule("Inventory/entities/Inventory.lua");
jServer:loadFrameworkModule("Inventory/InventoryManager.lua");
jServer:loadFrameworkModule("Storage/entities/Storage.lua");
jServer:loadFrameworkModule("Storage/StorageManager.lua");
jServer:loadFrameworkModule("Player/entities/Player.lua");
jServer:loadFrameworkModule("Player/PlayerManager.lua");

--MODULES
jServer:loadModule("test.lua");