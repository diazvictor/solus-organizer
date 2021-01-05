--[[--
 @package   Solus Frontend
 @filename  truncate.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      04.01.2021 19:53:44 -04
]]
local str = "Donkey Kong Country 3 - Dixie Kong's Double Trouble.sfc"

-- make in 34min
function string.truncate(str)
	local t,s = {}, str
	if #str > 21 then
		for w in string.gmatch(str, ".") do
			table.insert(t, w)
			if #t > 20 then
				break
			end
		end
		s = ('%s...'):format(table.concat(t))
		return s
	else
		return s
	end
end
print(string.truncate(str))
