--[[
--Created Date: Tuesday September 20th 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Tuesday September 20th 2022 7:05:02 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

---@class MySQL
local MySQL = {}

---@param connectionParameters table[ db: string, user: string, host: string, port: number, password: string ]
function MySQL:new(connectionParameters)
    local self = {}
    setmetatable(self, { __index = MySQL});

    self.params = connectionParameters;

    if (Config.debug) then
        Package.Log("Server: [ MySQL ] initialized.");
    end
    
    return self;
end

---Connect to database
function MySQL:createConnection()
    local default = {
        db = "",
        user = "",
        host = "",
        port = 3306,
    }
    for param, _ in pairs(default) do
        if ((not self.params[param] or self.params[param] == nil) and self.params[param] ~= "password") then
            return Package.Error("MySQL: %s is not defined", param)
        end
    end
    if (self.params.password) then
        self.database = Database(DatabaseEngine.MySQL, ("db=%s user=%s host=%s port=%s password=%s"):format(
                self.params.db, 
                self.params.user, 
                self.params.host, 
                self.params.port,
                self.params.password
            )
        )
    else
        self.database = Database(DatabaseEngine.MySQL, ("db=%s user=%s host=%s port=%s"):format(
                self.params.db, 
                self.params.user, 
                self.params.host, 
                self.params.port
            )
        )
    end
    return self;
end

---@param parameters table
function MySQL:convert(query, parameters)
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
---@param params table
---@param callback fun(result: table)
function MySQL:query(query, params, callback)
    local converted_query = self:convert(query, params);
    self.database:Execute(converted_query, function(result)
        if (callback) then
            callback(result);
        end
    end);
end

---@param query string
---@param params table
function MySQL:querySync(query, params)
    local converted_query = self:convert(query, params);
    local result = self.database:ExecuteSync(converted_query);
    return result;
end

---@param query string
---@param params table
---@param callback fun(result: table)
function MySQL:select(query, params, callback)
    local converted_query = self:convert(query, params);
    self.database:Select(converted_query, function(result)
        if (callback) then
            callback(result);
        end
    end);
end

---@param query string
---@param params table
function MySQL:selectSync(query, params)
    local converted_query = self:convert(query, params);
    local result = self.database:SelectSync(converted_query);
    return result;
end

---Close connection
function MySQL:close()
    self.database:Close();
end

jServer.mysql = MySQL:new({
    db = "jframework",
    user = "root",
    host = "localhost",
    port = 3307
}):createConnection();