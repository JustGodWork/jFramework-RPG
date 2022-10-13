--
--Created Date: 17:06 29/09/2022
--Author: JustGod
--Made with ❤
--
--File: [Events]
--
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
--

---@param player Player
---@param inventoryName string
Events.Subscribe(SharedEnums.Events.inventory.get, function(player, inventoryName)
    local inventory = GM.Server.InventoryManager:GetByOwner(player:GetSteamID(), inventoryName);
    if (inventory) then
        Events.CallRemote(SharedEnums.Events.inventory.receive, player, inventory:GetItems(), inventory:GetNumberOfSlots());
    end
end);

---@param player Player
---@param inventoryName string
---@param item table
Events.Subscribe(SharedEnums.Events.inventory.addItem, function(player, inventoryName, item)
    local inventory = GM.Server.InventoryManager:GetByOwner(player:GetCharacterId(), inventoryName)
    if (inventory) then
        inventory:AddItem(item);
    end
end);

---@param player Player
---@param inventoryName string
---@param slot number
---@param amount number
Events.Subscribe(SharedEnums.Events.inventory.removeItem, function(player, inventoryName, slot, amount)
    local inventory = GM.Server.InventoryManager:GetByOwner(player:GetCharacterId(), inventoryName)
    if (inventory) then
        inventory:RemoveItem(slot, amount);
    end
end);