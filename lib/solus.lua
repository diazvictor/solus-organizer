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

base64 = require 'base64'
print("| 'base64' loaded successfully.")

utils = require 'utils'
print("| 'utils' loaded successfully.")

config = require 'configuration'
print("| 'configuration' loaded successfully.")

local config_dir = ('%s/solus-frontend'):format(GLib.get_user_config_dir())
if not utils:isfile(('%s/solus.db'):format(config_dir)) then
	os.execute(('mkdir -p %s'):format(config_dir))
end
db_file	= ('%s/solus.db'):format(config_dir)
db = require("database.database")
print("| 'database' loaded successfully.")
db:open()

local provider = Gtk.CssProvider()
provider:load_from_path('../data/styles/custom.css')
print("| 'style css' loaded successfully.")
local screen = Gdk.Display.get_default_screen(Gdk.Display:get_default())
local GTK_STYLE_PROVIDER_PRIORITY_APPLICATION = 600
Gtk.StyleContext.add_provider_for_screen(
	screen, provider,
	GTK_STYLE_PROVIDER_PRIORITY_APPLICATION
)

solus = class('solus')
pagination = require 'pagination'
