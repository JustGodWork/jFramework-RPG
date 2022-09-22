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
        x = 799.400, 
        y = 1755.599, 
        z = 101.5,
    },
    defaultHeading = {
        Pitch = 0.0,
        Yaw = -92.521,
        Roll = 0.0
    },
    defaultSkin = "nanos-world::SK_Male"
}