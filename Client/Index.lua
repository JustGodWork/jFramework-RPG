--[[
--Created Date: Thursday September 22nd 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Thursday September 22nd 2022 3:35:39 am
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

Events.Subscribe("jServer:modules:world:time:sync", function(hour, minute)
    World.SetTime(hour, minute)
end)

Events.Subscribe("jServer:modules:world:weather:sync", function(weather)
    World.SetWeather(weather)
end)