package.path = package.path .. ';../?.solus.txt'

local metadata = {}
metadata.gba = require 'metadata'

for i, v in pairs(metadata.gba) do
    print(i, v)
end

return config