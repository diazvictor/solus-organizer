-- package.path = package.path .. ';../?.solus.txt'

-- metadata.gba = require 'metadata'
metadata = {
	collection = {
		gba = {
			name = "null",
			shortened = "null",
			launch = "null",
			files = {
				{},
				{}
			}
		},
		snes = {
			name = "null",
			shortened = "null",
			launch = "null",
			files = {
				{},
				{}
			}
		},
		md = {
			name = "null",
			shortened = "null",
			launch = "null",
			files = {
				{},
				{}
			}
		}
	}
}
-- metadata.collection['md'] = {
	-- name = "SEGA GENESIS",
	-- shortened = "md",
	-- launch = "ss",
	-- files = {}
-- }
local i = 0
for k,v in pairs(metadata.collection) do
	i = i + 1
	print(i)
end