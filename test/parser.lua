-- package.path = package.path .. ';../?.solus.txt'

-- metadata.gba = require 'metadata'
metadata = {
	collection = {
		gba = {
			name = "GAME BOY ADVANCE",
			shortened = "gba",
			launch = "/home/victor/Proyectos/GIT/mgba/sdl/mgba",
			files = {
				{},
				{}
			}
		}
	}
}
print(#metadata['collection']['gba']['files'])
-- print(id_row)

-- for i, v in pairs(metadata.gba) do
    -- print(i, v)
-- end

-- return config