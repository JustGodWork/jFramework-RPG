--[[
--Created Date: Tuesday September 20th 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Tuesday September 20th 2022 7:54:42 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

---@type Repository
Repository = Class.new(function(class)

    ---@class Repository: BaseObject
    local self = class;

    ---@param name string
    ---@param Object table
    ---@return Repository
    function self:Constructor(name, Object)
        self.name = name;
        self.constructor = Object;
        self.data = {};

        GM.Log:debug("[ Repository: ".. name .." ] initialized.");

        ---@param Object table
        ---@return string
        function self:ConvertArgs(Object)
            local args = {};
            local request = "";
            for i = 1, #self.constructor do
                local arg = self.constructor[i];
                if (next(self.constructor, i)) then
                    if (Object[arg.name] ~= nil and Object[self.constructor[i + 1].name] ~= nil) then
                        request = string.format("%s %s %s", request, arg.name, "= ?, ");
                    end
                else
                    if (Object[arg.name] ~= nil) then
                        request = string.format("%s %s %s", request, arg.name, "= ? ");
                    end
                end
                if (type(Object[arg.name]) == "table") then
                    args[#args + 1] = JSON.stringify(Object[arg.name]);
                elseif (Object[arg.name] ~= nil) then
                    args[#args + 1] = Object[arg.name];
                end
            end
            return request, args;
        end

        ---@param condition string | table
        ---@param value string | table
        function self:PrepareTable(condition, value)
            local request;
            local args = value;
            if (type(condition) == "table") then
                request = ""; 
                for key, cond in pairs(condition) do
                    if (next(condition, key)) then
                        request = string.format("%s %s %s", request, cond,"= ? AND ");
                    else
                        request = string.format("%s %s %s", request, cond,"= ? ");
                    end
                    args[#args + 1] = value[cond];
                end 
            else 
                request = condition .. " = ?";
            end
            return request, args;
        end

        ---@param Object table
        ---@return string, string, table
        function self:ConvertInsertArgs(Object)
            local part1 = "";
            local part2 = "";
            local args = {};
            for i = 1, #self.constructor do
                if (next(self.constructor, i) and Object[self.constructor[i + 1].name] ~= nil) then
                    if (Object[self.constructor[i].name] ~= nil) then
                        part1 = string.format("%s %s %s", part1, self.constructor[i].name,",");
                        part2 = string.format("%s %s", part2, "?, ");
                    end
                else
                    if (Object[self.constructor[i].name] ~= nil) then
                        part1 = string.format("%s %s", part1, self.constructor[i].name);
                        part2 = string.format("%s %s", part2, "?");
                    end
                end
                if (type(Object[self.constructor[i].name]) == "table") then
                    args[#args + 1] = JSON.stringify(Object[self.constructor[i].name]);
                elseif (Object[self.constructor[i].name] ~= nil) then
                    args[#args + 1] = Object[self.constructor[i].name];
                end
            end
            return part1, part2, args;
        end

        self:Initialize();

        return self;
    end

    ---Create the repository table if not exists
    function self:Initialize()
        self:create();
    end

    ---@param id string
    function self:Find(id)
        if (self.data[id] and self.data[id]) then
            return self.data[id];
        end
    end

    ---@param id string
    function self:Exist(id)
        return self.data[id] ~= nil;
    end

    ---@param condition string | table
    ---@param value string | table
    ---@param callback fun(result: table | nil, success: boolean)
    function self:Prepare(condition, value, callback)
        local request, params = self:PrepareTable(condition, value);
        local paramsConverted = {};
        if (type(params) == "table") then
            paramsConverted = { table.unpack(params) };
        else
            paramsConverted = { params };
        end
        GM.Server.MySQL:Select("SELECT * FROM " .. self.name .. " WHERE " .. request, paramsConverted, function (result)
            if (#result > 0) then
                for i = 1, #result do
                    for j = 1, #self.constructor do
                        local value = self.constructor[j];
                        if (result[i][value.name] == "") then
                            result[i][value.name] = nil;
                        elseif (string.find(value.type, "LONGTEXT") and result[i][value.name]) then
                            result[i][value.name] = JSON.parse(result[i][value.name]);
                        end
                    end
                    self.data[result[i].id] = result[i];
                    GM.Log:debug(("[ Repository: ".. self.name .." ] loaded [%s]."):format(result[1].id));
                end
            else
                GM.Log:debug(("[ Repository: ".. self.name .." ] no result found."));
            end
            if (callback) then callback(result, #result > 0); end
        end)
    end

    ---Create table into database
    ---@param callback? function
    function self:Create(callback)
        local request = "";
        for key, data in pairs(self.constructor) do
            if (data.name ~= "id") then
                if (next(self.constructor, key)) then
                    request = string.format("%s `%s` %s%s", request, data.name, data.type,", ");
                else
                    request = string.format("%s `%s` %s%s", request, data.name, data.type,", PRIMARY KEY (`id`)");
                end
            end
        end
        GM.Server.MySQL:Query("CREATE TABLE IF NOT EXISTS " .. self.name .. " (id VARCHAR(255) NOT NULL DEFAULT ".. jShared:uuid("x2xxxxxx") ..", " .. request .. ");", {}, function()
            if (callback) then callback(); end
        end)
    end

    ---@param Object table
    ---@param callback? function
    function self:Insert(Object, callback)
        local part1, part2, args = self:ConvertInsertArgs(Object);
        GM.Server.MySQL:Query("INSERT INTO " .. self.name .. " (".. part1 ..")  VALUES (" .. part2 .. ")", { table.unpack(args) }, function (result)
            if (result) then
                if (callback) then callback(); end
            end
        end)
    end

    ---Save database
    ---@param Object table
    ---@param callback function
    function self:Save(Object, callback)
        local request, args = self:ConvertArgs(Object);
        if (Object._id == nil and self.data[Object._id] == nil) then
            self:Insert(Object, callback);
        else
            GM.Server.MySQL:Query("UPDATE " .. self.name .. " SET ".. request .." WHERE id = ?", { 
                table.unpack(args),
                Object._id
            }, function()
                if (callback) then callback(); end
                GM.Log:debug(("[ Repository: ".. self.name .." ] saved object [ Id: %s ]."):format(Object._id));
            end);
        end
    end

    ---@param name string
    ---@param Object table
    function self:SaveData(name, Object)
        GM.Server.MySQL:Query("UPDATE " .. self.name .. " SET ".. name .." = ? WHERE id = ?", {
            Object[name],
            Object._id
        }, function()
            GM.Log:debug(("[ Repository: ".. self.name .." ] saved object [ Id: %s, Data: %s ]."):format(Object._id, name));
        end);
    end

    return self;
end);