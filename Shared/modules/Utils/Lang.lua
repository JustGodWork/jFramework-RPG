--[[
--Created Date: Tuesday September 20th 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Tuesday September 20th 2022 3:25:34 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

---@class Lang
Lang = {}

---@return Lang
function Lang:new()
    local class = {}
    setmetatable(class, {__index = Lang})
    self.langs = {}

    return class
end

function Lang:loadLocales()
    local dirs = Package.GetFiles("Shared/locales")
    for i = 1, #dirs do
        local lang = string.gsub(dirs[i], "Shared", ".")
        Package.Require(lang)
    end
end

---@param langName string Name of the language
---@param data table
function Lang:create(langName, data)
    print(JSON.stringify(data))
    self.langs[string.upper(langName)] = data
    for k, v in pairs(self.langs) do
        print(k, v)
    end
    print(JSON.stringify(self.langs["FR"]))
end

---@param str string
---@param ... any
function Lang:_(str, ...)  -- Translate string
	if (self.langs[string.upper(Config.lang)] ~= nil) then
		
		if (self.langs[string.upper(Config.lang)][string.upper(str)] ~= nil) then
			return string.format(self.langs[string.upper(Config.lang)][string.upper(str)], ...)
		else
			return 'Missing entry for [~r~'..string.upper(str)..'~s~]'
		end

	else
		return 'Locale [~r~' .. string.upper(Config.lang) .. '~s~] does not exist, Please set it in the Config.lua'
	end

end

---@param str string
---@param ... any
function Lang:addEntry(str, ...) -- Translate string first char uppercase
    if (not Config.lang) then
        return Package.Error('Please set the language in the Config.lua. EX: Config.lang = "en"')
    end
	return tostring(self:_(str, ...):gsub("^%l", string.upper))
end