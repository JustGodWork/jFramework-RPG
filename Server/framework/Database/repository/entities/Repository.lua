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

---@class Repository 
Repository = {}

---@param name string
---@param Object table
---@return Repository
function Repository:new(name, Object)
    ---@type Repository
    local self = {}
    setmetatable(self, { __index = Repository});

    self.name = name;
    self.constructor = Object;
    self.data = {};

    jShared.log:debug("[ Repository: ".. name .." ] initialized.");

    self:initialize();

    return self;
end

---Create the repository table if not exists
function Repository:initialize()
    self:create();
end

---@param id number
function Repository:find(id)
    if (self.data[id] and self.data[id]) then
        return self.data[id];
    end
end

---@param id number
function Repository:exist(id)
    return self.data[id] ~= nil;
end

---@param Object table
---@return string
function Repository:convertArgs(Object)
    local args = {};
    local request = "";
    for key, data in pairs(Object) do
        if (type(data) ~= "function" and key ~= "id" and key ~= "characterId") then
            if (next(Object, key)) then
                request = string.format("%s %s %s", request, key,"= ?, ");
            else
                request = string.format("%s %s %s", request, key,"= ? ");
            end
            if (type(data) == "table") then
                args[#args + 1] = JSON.stringify(data);
            else
                args[#args + 1] = data;
            end
        end
    end
    return request, args;
end

---@param condition string | table
---@param value string | table
function Repository:prepareTable(condition, value)
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

---@param condition string | table
---@param value string | table
---@param callback? fun(result: table | nil, success: boolean)
function Repository:prepare(condition, value, callback)
    local request, params = self:prepareTable(condition, value);
    local paramsConverted = {};
    if (type(params) == "table") then
        paramsConverted = { table.unpack(params) };
    else
        paramsConverted = { params };
    end
    jServer.mysql:select("SELECT * FROM " .. self.name .. " WHERE " .. request, paramsConverted, function (result)
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
                jShared.log:debug(("[ Repository: ".. self.name .." ] loaded [%s]."):format(result[1].id));
            end
        else
            jShared.log:debug(("[ Repository: ".. self.name .." ] no result found."));
        end
        if (callback) then callback(result, #result > 0); end
    end)
end

---Create table into database
---@param callback? function
function Repository:create(callback)
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
    jServer.mysql:query("CREATE TABLE IF NOT EXISTS " .. self.name .. " (id INT(11)  NOT NULL AUTO_INCREMENT, " .. request .. ");", {}, function()
        if (callback) then callback(); end
    end)
end

---@param Object table
---@return string, string, table
function Repository:convertInsertArgs(Object)
    local part1 = "";
    local part2 = "";
    local args = {};
    for i = 1, #self.constructor do
        if (next(self.constructor, i)) then
            part1 = string.format("%s %s %s", part1, self.constructor[i].name,",");
            part2 = string.format("%s %s", part2, "?, ");
        else
            part1 = string.format("%s %s", part1, self.constructor[i].name);
            part2 = string.format("%s %s", part2, "?");
        end
        if (type(Object[self.constructor[i].name]) == "table") then
            args[#args + 1] = JSON.stringify(Object[self.constructor[i].name]);
        else
            args[#args + 1] = Object[self.constructor[i].name];
        end
    end
    return part1, part2, args;
end

---@param Object table
---@param callback? function
function Repository:insert(Object, callback)
    local part1, part2, args = self:convertInsertArgs(Object);
    jServer.mysql:query("INSERT INTO " .. self.name .. " (".. part1 ..")  VALUES (" .. part2 .. ")", { table.unpack(args) }, function (result)
        if (result) then
            if (callback) then callback(); end
        end
    end)
end

---Save database
---@param Object table
---@param callback? function
function Repository:save(Object, callback)
    local request , args = self:convertArgs(Object);
    if (not Object.id or not self.data[Object.id]) then
        self:insert(Object, callback);
    else
        jServer.mysql:query("UPDATE " .. self.name .. " SET ".. request .." WHERE id = ?", { 
            table.unpack(args),
            Object.id 
        }, function()
            if (callback) then callback(); end
            jShared.log:debug(("[ Repository: ".. self.name .." ] saved object [ Id: %s ]."):format(Object.id));
        end);
    end
end

---@param name string
---@param Object table
function Repository:saveData(name, Object)
    jServer.mysql:query("UPDATE " .. self.name .. " SET ".. name .." = ? WHERE id = ?", {
        Object[name], 
        Object.id 
    }, function()
        jShared.log:debug(("[ Repository: ".. self.name .." ] saved object [ Id: %s, Data: %s ]."):format(Object.id, name));
    end);
end