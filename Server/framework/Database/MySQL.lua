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
    ---@type Database
    self.database = nil;

    jShared.log:debug("[ MySQL ] initialized.");

    return self;
end

---Connect to database
function MySQL:createConnection()
    local connexionString;
    if (self.params.password) then
        connexionString = "db=%s user=%s host=%s port=%s password=%s";
    else
        connexionString = "db=%s user=%s host=%s port=%s";
    end

    self.connected, self.database = pcall(Database, DatabaseEngine.MySQL, (connexionString):format(
        self.params.db, 
        self.params.user, 
        self.params.host, 
        self.params.port, 
        self.params.password
    ));

    self:onClose();
    self:handlerConnectError();
    return self;
end

function MySQL:onClose()
    Server.Subscribe("Stop", function()
        if (self.connected) then
            self.database:Close();
        end
        jShared.log:info("[ MySQL ] => Connection closed.");
    end)
end

function MySQL:handlerConnectError()
    if (not self.connected) then
        jShared.log:error(string.format("[ MySQL ] => Connection failed. %s", self.database));
        Server.Stop();
    else
        jShared.log:success("[ MySQL ] => Connection established.");
    end
end

---Check if connection is open
---@return boolean
function MySQL:isOpen()
    return self.connected;
end

---@param query string
---@param parameters table
function MySQL:convert(query, parameters)
    if (parameters and #parameters > 0) then
        local execute = string.gsub(query, "?", "%%s")
        local params_converted = {}
        for i = 0, #parameters - 1 do
            params_converted[#params_converted + 1] = string.format(":%s", tostring(i))
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
    local function callbackQuery(result)
        if (callback) then
            callback(result);
        end
    end
    if (params) then
        self.database:Execute(converted_query, callbackQuery, table.unpack(params));
    else
        self.database:Execute(converted_query, callbackQuery);
    end
end

---@param query string
---@param params table
function MySQL:querySync(query, params)
    local converted_query = self:convert(query, params);
    local result;
    if (params) then
        result = self.database:ExecuteSync(converted_query, table.unpack(params));
    else
        result = self.database:ExecuteSync(converted_query);
    end
    return result;
end

---@param query string
---@param params table
---@param callback fun(result: table)
function MySQL:select(query, params, callback)
    local converted_query = self:convert(query, params);
    local function callbackQuery(result)
        if (callback) then
            callback(result);
        end
    end
    if (params) then
        self.database:Select(converted_query, callbackQuery, table.unpack(params));
    else
        self.database:Select(converted_query, callbackQuery);
    end
end

---@param query string
---@param params table
function MySQL:selectSync(query, params)
    local converted_query = self:convert(query, params);
    local result;
    if (params) then
        result = self.database:SelectSync(converted_query, table.unpack(params));
    else
        result = self.database:SelectSync(converted_query);
    end
    return result;
end

---Close connection
function MySQL:close()
    self.database:Close();
end

jServer.mysql = MySQL:new(jServer.database):createConnection();