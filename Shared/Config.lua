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

Config.disclaimer = false --Set to false after setup complete
Config.debug = false --Enabling debug mode will print all logs in the console
Config.lang = "en" --Language of the framework (Not available yet)

Config.Time = { -- Time config (Not finished yet)
    speed = 1, --seconds
    hourFormat = 24, --number of hours in a day
    startAt = { --time when the server starts
        hours = 12, 
        minutes = 0, 
        seconds = 0 
    }
}

Config.player = { --Player config
    accounts = { --Add accounts here
        {name = "bank", label = "Bank", money = 1000, shared = 0},
        {name = "cash", label = "Cash", money = 500, shared = 0}
    },
    inventories = { --Add inventories here
        {name = "main", label = "Main Inventory", maxWeight = 25, shared = 0},
        {name = "bag", label = "Bag", maxWeight = 40, shared = 1}
    },
    defaultPosition = { --Default position when the player spawns
        x = 799.400, 
        y = 1755.599, 
        z = 101.5
    },
    defaultHeading = { --Default heading when the player spawns
        Pitch = 0.0,
        Yaw = -92.521,
        Roll = 0.0
    },
    defaultSkin = "nanos-world::SK_Male" --Default skin when the player spawn
}