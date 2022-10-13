--[[
----
----Created Date: 7:27 Saturday October 8th 2022
----Author: JustGod
----Made with ❤
----
----File: [Utils]
----
----Copyright (c) 2022 JustGodWork, All Rights Reserved.
----This file is part of JustGodWork project.
----Unauthorized using, copying, modifying and/or distributing of this file
----via any medium is strictly prohibited. This code is confidential.
----
--]]

--Crédits: https://github.com/nanos-world/egui (MegaThorx)

Class = {};

---@param class BaseObject
---@return BaseObject | nil
function Class.super(class)
	local metatable = getmetatable(class);
	local metasuper = metatable.__super;
	if (metasuper) then
		return metasuper;
	end
	return nil;
end

---@param class BaseObject
local function build(class)
	if (class) then
		local metatable = getmetatable(class);
		return setmetatable( {}, {
			__index = class;
			__super = Class.super(class);
			__newindex = class.__newindex;
			__call = metatable.__call;
			__len = class.__len;
			__unm = class.__unm;
			__add = class.__add;
			__sub = class.__sub;
			__mul = class.__mul;
			__div = class.__div;
			__pow = class.__pow;
			__concat = class.__concat;
		});
	end
end

---@param from BaseObject
---@param callback fun(class: BaseObject): BaseObject
---@return BaseObject
function Class.extends(from, callback)
	assert(from, "Attempt to extends from a nil class value");
	local extend = from;
	local metatable = getmetatable(extend);
	return setmetatable(callback({}), {
		__index = extend;
		__super = extend;
		__newindex = metatable.__newindex;
		__call = metatable.__call;
		__len = metatable.__len;
		__unm = metatable.__unm;
		__add = metatable.__add;
		__sub = metatable.__sub;
		__mul = metatable.__mul;
		__div = metatable.__div;
		__pow = metatable.__pow;
		__concat = metatable.__concat;
	});
end

---@param callback fun(class: BaseObject): BaseObject
---@return BaseObject
function Class.new(callback)
	return Class.extends(BaseObject, callback);
end

---@param class BaseObject
---@param ... any
---@return BaseObject
function Class.instance(class, ...)
	if (class) then
		local instance = build(class);

		if (rawget(class, "Constructor")) then
			rawget(class, "Constructor")(instance, ...)
		end

		return instance;
	end
end

---@param class BaseObject
function Class.Delete(class, ...)
	if (not class) then error("Called delete without object"); end
	if (class.Destroy) then
		class:Destroy(...);
	end
end