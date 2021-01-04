--[[--
 @package   Solus Frontend
 @filename  configuration.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      03.01.2021 22:52:11 -04
]]

local configuration = class('configuration')

function configuration:load(filename)
	local fd = io.open(filename, "r")
	local config = fd:read("*all")
	fd:close()
	return json:decode(config) or {}
end

function configuration:save(filename, data)
	data = json:encode_pretty(data) or {}
	file = assert(io.open(filename,'w'), 'Error loading file : ' .. filename)
	file:write(data)
	file:close()
end

return configuration
