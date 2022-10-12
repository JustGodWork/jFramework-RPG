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

---@type MySQL
local MySQL = Class.new(function(class)

    ---@class MySQL: BaseObject
    local self = class;

    ---@param connectionParameters table[ db: string, user: string, host: string, port: number, password: string ]
    function self:Constructor(connectionParameters)
        self.params = connectionParameters;
        self.connected = false;
        self.database = nil;

        self:CreateConnection();

        GM.Server.log:debug("[ MySQL ] initialized.");
    end

    ---Connect to database
    function self:CreateConnection()
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

        self:OnClose();
        self:HandleConnectError();
        return self;
    end

    function self:OnClose()
        Server.Subscribe("Stop", function()
            if (self.connected) then
                self:Close();
            end
            GM.Server.log:info("[ MySQL ] => Connection closed.")
        end)
    end

    function self:HandleConnectError()
        if (not self.connected) then
            GM.Server.log:error(string.format("[ MySQL ] => Connection failed. %s", self.database));
            Server.Stop();
        else
            GM.Server.log:success("[ MySQL ] => Connection established.");
        end
    end

    ---Check if connection is open
    ---@return boolean
    function self:IsOpen()
        return self.connected;
    end

    ---@param query string
    ---@param parameters table
    function self:Convert(query, parameters)
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
    function self:Query(query, params, callback)
        local converted_query = self:Convert(query, params);
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
    function self:QuerySync(query, params)
        local converted_query = self:Convert(query, params);
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
    function self:Select(query, params, callback)
        local converted_query = self:Convert(query, params);
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
    function self:SelectSync(query, params)
        local converted_query = self:Convert(query, params);
        local result;
        if (params) then
            result = self.database:SelectSync(converted_query, table.unpack(params));
        else
            result = self.database:SelectSync(converted_query);
        end
        return result;
    end

    ---Close connection
    function self:Close()
        self.database:Close();
    end

    return self;
end);

---@type MySQL
GM.Server.mysql = MySQL(GM.Server.database);