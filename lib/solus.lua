--[[--
 @package   Solus Frontend
 @filename  solus.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      08.01.2021 00:45:51 -04
]]

require 'middleclass'
print("| 'middleclass' loaded successfully.")

json = require 'json'
print("| 'json' loaded successfully.")

utils = require 'utils'
print("| 'utils' loaded successfully.")

config = require 'configuration'
print("| 'configuration' loaded successfully.")

collection_file = '../data/collections.json'
metadata = config:load(collection_file)
