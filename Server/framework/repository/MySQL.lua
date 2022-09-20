--[[
--Created Date: Monday September 19th 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Monday September 19th 2022 10:50:40 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

---@class _MySQL
local _MySQL = {}

---@param data table
---@return MySQL
function _MySQL:new(data)
    local class = {}
    setmetatable(class, {__index = _MySQL})

    local str = string.format("db=%s user=%s host=%s password=%s port=%s", data.database, data.user, data.host, data.password or "", tostring(data.port))
    if (not data.password) then
        str = string.format("db=%s user=%s host=%s port=%s", data.database, data.user, data.host, tostring(data.port))
    end
    self.db = Database(DatabaseEngine.MySQL, str)

    return self
end

---@param parameters table
function _MySQL:convert(query, parameters)
    if (parameters and #parameters > 0) then
        local execute = string.gsub(query, "?", "%%s")
        for i = 1, #parameters do
            if (type(parameters[i]) == "string") then
                parameters[i] = string.format('"%s"', parameters[i])
            end
        end
        return string.format(execute, table.unpack(parameters))
    end

    return query
end

---@param query string
---@param parameters table
---@param callback function
function _MySQL:insert(query, parameters, callback)
    self.db:Execute(self:convert(query, parameters), callback)
end

---@param query string
---@param parameters table
---@param callback fun(result:table)
function _MySQL:select(query, parameters, callback)
    self.db:Select(self:convert(query, parameters), callback)
end

---@param query string
---@param parameters table
---@param callback fun(result:table)
function _MySQL:execute(query, parameters, callback)
    self.db:Execute(self:convert(query, parameters), callback)
end

jServer.mysql = _MySQL:new({
    host = "localhost",
    port = 3307,
    user = "root",
    database = "jframework"
});