--[[
----
----Created Date: 5:36 Wednesday October 5th 2022
----Author: JustGod
----Made with ❤
----
----File: [UI]
----
----Copyright (c) 2022 JustGodWork, All Rights Reserved.
----This file is part of JustGodWork project.
----Unauthorized using, copying, modifying and/or distributing of this file
----via any medium is strictly prohibited. This code is confidential.
----
--]]

---@type MenuManager
local MenuManager = Class.new(function(class)

    ---@class MenuManager: BaseObject
    local self = class;

    function self:Constructor()
        self.menus = {};

        self.index = WebUI("MenuUI", "file://modules/Menu/web/index.html", false);

        return self;
    end

    ---@param Title string
    ---@param Subtitle string
    ---@param X number
    ---@param Y number
    ---@param TextureName string
    function self:CreateMenu(Title, Subtitle, X, Y, TextureName)
        local id = #self.menus + 1
        self.menus[id] = Menu:new(id, Title, Subtitle, X, Y, TextureName);
    end

    ---@param Parent Menu
    ---@param Title string
    ---@param Subtitle string
    ---@param X number
    ---@param Y number
    ---@param TextureName string
    function self:CreateSubMenu(Parent, Title, Subtitle, X, Y, TextureName)
        local id = #self.menus + 1
        self.menus[id] = Menu:new(id, Title, Subtitle, X, Y, TextureName, Parent);
    end

    return self;
end)

GM.Client.menuManager = MenuManager();

--todo modify this : _Client.menuManager.index:SetVisible(true);