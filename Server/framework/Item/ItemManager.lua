--[[
--Created Date: Wednesday September 21st 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Wednesday September 21st 2022 12:23:40 am
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

---@class ItemManager
local ItemManager = {}

---@return ItemManager
function ItemManager:new()
    ---@type ItemManager
    local self = {}
    setmetatable(self, { __index = ItemManager});

    ---@type Item[]
    self.items = {};

    return self;
end

---@param id string
---@param name string
---@param label string
---@param data table
---@param type string
---@param weight number
---@param unique boolean
---@return void
function ItemManager:addItem(id, name, label, data, type, weight, unique)
    self.items[id] = Item:new(id, name, label, data or {}, type, weight, unique);
end

---@param id string id or name of item
---@return Item
function ItemManager:getItem(id)
    for itemId, _ in pairs(self.items) do
        local item = self.items[itemId]
        if (item ~= nil and item:getId() == id or item:getName() == id) then
            return item;
        end
    end
end

---@param id string
---@return void
function ItemManager:removeItem(id)
    self.items[id] = nil;
end

---@param id string
---@param data table
---@return void
function ItemManager:setItemData(id, data)
    self.items[id]:setData(data);
end

---@param id string
---@return table
function ItemManager:getItemData(id)
    return self.items[id]:getData();
end

---@param id string
---@return string
function ItemManager:getItemName(id)
    return self.items[id]:getName();
end

---@param id string
---@return string
function ItemManager:getItemId(id)
    return self.items[id]:getId();
end

---@param id string
---@return string
function ItemManager:getItemType(id)
    return self.items[id]:getType();
end

---@param name string
---@param callback fun(player: Player, item: Item)
function ItemManager:setItemCallback(name, callback)
    for itemId, _ in pairs(self.items) do
        local item = self.items[itemId]
        if (item ~= nil and item:getName() == name) then
            item:setCallback(function(player)
                callback(player, item)
            end);
            return;
        end
    end
end

jServer.itemManager = ItemManager:new();