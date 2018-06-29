local uni = require 'unicode'
local sleep = require 'sleep'

local table_unpack = table.unpack
local table_insert = table.insert
local table_sort   = table.sort
local pairs = pairs
local setmetatable = setmetatable

function io.load(file_path)
	local f, e = io.open(file_path:string(), 'rb')
	if not f then
		return nil, e
	end
	local buf = f:read 'a'
	f:close()
	return buf
end

function io.save(file_path, content)
	local f, e = io.open(file_path:string(), "wb")

	if f then
		f:write(content)
		f:close()
		return true
	else
		return false, e
	end
end

function task(f, ...)
	for i = 1, 100 do
		if i == 100 then
			f(...)
			return
		end
		if pcall(f, ...) then
			return
		end
		sleep(10)
	end
end

local function remove_then_create_dir(dir)
	if fs.exists(dir) then
		task(fs.remove_all, dir)
	end
	task(fs.create_directories, dir)
end
