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
    GM.Log:success("Client data initialized.");
    GM.Log:debug(playerData);
    Events.CallRemote(SharedEnums.Events.inventory.get, "main");
    Client.SendChatMessage("All your data have been loaded !");
end);

Events.Subscribe(SharedEnums.Events.inventory.receive, function(items, slots)
    GM.Log:debug(items, slots);
end);