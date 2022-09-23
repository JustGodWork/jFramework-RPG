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
    ---@type MySQL
    local self = {}
    setmetatable(self, { __index = MySQL});

    self.params = connectionParameters;
    self.connected = false;

    jShared.log:debug("[ MySQL ] initialized.");

    return self;
end

function MySQL:onClose()
    Server.Subscribe("Stop", function()
        self.database:Close()
        jShared.log:info("[ MySQL ] => Connection closed.")
    end)
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
            return jShared.log:error(string.format("MySQL: %s is not defined", param))
        end
    end
    if (self.params.password) then
        self.connected, self.database = pcall(Database, DatabaseEngine.MySQL, ("db=%s user=%s host=%s port=%s password=%s"):format(
                self.params.db,
                self.params.user, 
                self.params.host, 
                self.params.port,
                self.params.password
            )
        )
    else
        self.connected, self.database = pcall(Database, DatabaseEngine.MySQL, ("db=%s user=%s host=%s port=%s"):format(
            self.params.db, 
            self.params.user, 
            self.params.host, 
            self.params.port
        ))
    end
    self:handlerConnectError()
    self:onClose()
    return self;
end

function MySQL:handlerConnectError()
    if (not self.connected) then
        jShared.log:error(string.format("[ MySQL ] => Connection failed. %s", self.database));
        Timer.SetTimeout(os.exit, 0);
    else
        jShared.log:success("[ MySQL ] => Connection established.");
    end
end

---@param query string
---@param parameters table
function MySQL:convert(query, parameters)
    if (parameters and #parameters > 0) then
        local execute = string.gsub(query, "?", "%%s")
        local params_converted = {}
        for i = 0, #parameters - 1 do
            params_converted[#params_converted + 1] = string.format(':%s', tostring(i))
        end
        return string.format(execute, table.unpack(params_converted))
    end
    return query;
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
    end, table.unpack(params));
end

---@param query string
---@param params table
function MySQL:querySync(query, params)
    local converted_query = self:convert(query, params);
    local result = self.database:ExecuteSync(converted_query, table.unpack(params));
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
    end, table.unpack(params));
end

---@param query string
---@param params table
function MySQL:selectSync(query, params)
    local converted_query = self:convert(query, params);
    local result = self.database:SelectSync(converted_query, table.unpack(params));
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