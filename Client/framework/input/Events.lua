--[[
----
----Created Date: 2:25 Saturday October 1st 2022
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

---@param bindingName string
---@param keyName string
Events.Subscribe(SharedEnums.Events.input.register, function(bindingName, keyName)
    Input.Register(bindingName, keyName);
end);

---@param bindingName string
---@param keyName string
Events.Subscribe(SharedEnums.Events.input.unregister, function(bindingName, keyName)
    Input.Unregister(bindingName, keyName);
end);

---@param bindingName string
---@param inputEvent InputEvent[]
---@param callback function
Events.Subscribe(SharedEnums.Events.input.bind, function(bindingName, inputEvent, callback)
    Input.Bind(bindingName, inputEvent, callback);
end);

---@param bindingName string
---@param inputEvent InputEvent[]
Events.Subscribe(SharedEnums.Events.input.unbind, function(bindingName, inputEvent, callback)
    Input.Unbind(bindingName, inputEvent, callback);
end);