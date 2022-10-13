--[[
--Created Date: Monday September 26th 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Monday September 26th 2022 12:01:33 am
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

--Set default rich presence
Client.SetDiscordActivity(Config.discord.CURRENT_ACTIVITY, 
    Config.discord.CURRENT_ACTIVITY_DETAILS, 
    Config.discord.LOGO, 
    Config.discord.LOGO_TEXT, 
    false
);