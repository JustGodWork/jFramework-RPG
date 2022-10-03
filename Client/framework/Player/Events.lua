--[[
----
----Created Date: 1:37 Monday October 3rd 2022
----Author: JustGod
----Made with ❤
----
----File: [Events]
----
----Copyright (c) 2022 JustGodWork, All Rights Reserved.
----This file is part of JustGodWork project.
----Unauthorized using, copying, modifying and/or distributing of this file
----via any medium is strictly prohibited. This code is confidential.
----
--]]

-- This event is called when the player is loaded
-- You can use it to load modules only when player is loaded
Events.Subscribe(SharedEnums.Player.loaded, function(playerData)
    jShared.log:success("Client data initialized.");
    jShared.log:info(playerData);
    Client.SendChatMessage("All your data have been loaded !");
end);