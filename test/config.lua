package.path = package.path .. ';../?.solus.txt'

gba = require 'metadata'

for i, v in pairs(gba) do
    print(i, v)
end
