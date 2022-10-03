--
--Created Date: 10:54 30/09/2022
--Author: JustGod
--Made with ❤
--
--File: [Bind]
--
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
--

Input.Register("[jFramework]: No Clip", "B");

Input.Bind("[jFramework]: No Clip", InputEvent.Pressed, function()
    jClient.utils:executeCommand("noclip");
end);