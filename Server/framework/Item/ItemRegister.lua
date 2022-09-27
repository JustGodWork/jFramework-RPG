--[[
--Created Date: Saturday September 24th 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Saturday September 24th 2022 2:03:19 am
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

jServer.itemManager:addItem("water", "Water", "drink", 0.5, 64, {
    description = "A bottle of water",
    durability = 100, -- todo remove this (just for testing)
}, {});

jServer.itemManager:addItem("bread", "Bread", "food", 0.5, 64, {
    description = "A loaf of bread"
}, {});