--[[
--Created Date: Tuesday September 20th 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Tuesday September 20th 2022 12:51:34 am
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
---@param ClassConstructor table
---@return Repository
function Repository:new(name, ClassConstructor)
    local class = {}
    setmetatable(class, {__index = Repository})
    self.name = name
    self.class = self:clearObjectFunctions(ClassConstructor, true)

    return self
end

---@return table
function Repository:clearObjectFunctions(Object, removeIds)
    local obj = Object
    if (obj == nil or type(obj) ~= "table") then Package.Log("There was an error in Repository:clearObjectFunctions()") return {} end
    local data = {}
    for entry, val in pairs(obj) do
        if ((removeIds and entry ~= "id") and val ~= nil) then
            if (type(val) ~= "function") then
                data[entry] = val
            end
        end
    end
    return data
end

---Create Repository from Class
---@return void
function Repository:createTable()
    local query = "CREATE TABLE IF NOT EXISTS ".. self.name .." (id varchar(25) PRIMARY KEY,"
    for key, value in pairs(self.class) do
        local template = query .. " `%s` %s '%s'"
        if (type(value) == "table") then
            query = string.format(template, 
                key, "longtext NOT NULL DEFAULT", 
                JSON.stringify(value)
            )
        elseif (type(value) == "number") then
            query = string.format(template, 
                key, "int(11) NOT NULL DEFAULT", 
                value
            )
        elseif (type(value) == "string") then
            query = string.format(template, 
                key, "varchar(255) NOT NULL DEFAULT", 
                value
            )
        else
            query = string.format(template, 
                key, "varchar(255) NOT NULL DEFAULT", 
                JSON.stringify(value)
            )
        end
        if next(self.class, key) then
            query = query .. ","
        else
            query = query .. " )"
        end
    end
    jServer.mysql.db:Execute(query)
end

function Repository:save(Object)
    if (Object and Object.id) then
        jServer.mysql:select("SELECT * FROM ".. self.name .." WHERE id = ?", { Object.id }, function(result)
            if (result[1]) then
                local query = "UPDATE ".. self.name .." SET "
                for key, _ in pairs(self.class) do
                    if (Object[key] ~= nil and key ~= "id") then
                        local template = query .. " `%s` = '%s'"
                        if (type(Object[key]) == "table") then
                            query = string.format(template, 
                                key, JSON.stringify(Object[key])
                            )
                        elseif (type(Object[key]) == "number") then
                            query = string.format(template, 
                                key, Object[key]
                            )
                        elseif (type(Object[key]) == "string") then
                            query = string.format(template, 
                                key, Object[key]
                            )
                        else
                            query = string.format(template, 
                                key, JSON.stringify(Object[key])
                            )
                        end
                        if next(self.class, key) then
                            query = query .. ","
                        else
                            query = query .. " WHERE id = '".. Object.id .. "'"
                        end
                    end
                end
                jServer.mysql.db:Execute(query)
            end
        end)
    else
        self:createEntry(Object)
    end
end

function Repository:createEntry(data)
    local query = "INSERT INTO ".. self.name .." ( `id`,"
    for key, _ in pairs(self.class) do
        local template = query .. " `%s`"
        query = string.format(template, key)
        if next(self.class, key) then
            query = query .. ","
        else
            query = query .. " ) VALUES ("
        end
    end
    query = query .. "'" .. jShared:uuid("xx6x-xxxx-xx3x") .. "',"
    for key, _ in pairs(self.class) do
        if (data[key] ~= nil) then
            local template = query .. " '%s'"
            if (type(data[key]) == "table") then
                query = string.format(template, JSON.stringify(data[key]))
            elseif (type(data[key]) == "number") then
                query = string.format(template, data[key])
            elseif (type(data[key]) == "string") then
                query = string.format(template, data[key])
            else
                query = string.format(template, JSON.stringify(data[key]))
            end
            if next(self.class, key) then
                query = query .. ","
            else
                query = query .. " )"
            end
        end
    end
    jServer.mysql.db:Execute(query)
end

function Repository:delete(Object)
    if (not Object.id) then return end
    jServer.mysql.db:Execute("DELETE FROM ".. self.name .." WHERE id = ?", { Object.id })
end

---@param key string
---@param value any
---@param callback fun(result: table)
function Repository:find(key, value, callback)
    jServer.mysql:select('SELECT * FROM `'.. self.name ..'` WHERE '.. key ..' = "'.. value .. '"', {}, function(result)
        if (result and result[1]) then
            callback(result[1])
        else
            callback(false)
        end
    end)
end

