--[[
--Created Date: Monday September 19th 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Monday September 19th 2022 9:06:46 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

--jFramework Config
Config = {}

Config.debug = true
Config.lang = "fr"

Config.player = {
    accounts = {
        {name = "bank", label = "Banque", money = 1000},
        {name = "cash", label = "Cash", money = 500},
    },
    inventory = {
        {name = "main", label = "Inventaire", maxWeight = 50},
    },
    defaultPosition = {
        x = 0, 
        y = 0, 
        z = 0, 
        heading = 0
    },
}