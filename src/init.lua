--[[--
 @package   Solus Frontend
 @filename  init.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      21.07.2020 20:01:41 -04
]]
package.path = package.path .. ';../?.lua'

require 'lib.middleclass'
json = require 'lib.json'
utils = require 'lib.utils'
config = require 'lib.configuration'

lgi = require 'lgi'

GObject = lgi.GObject
GLib = lgi.GLib
Gtk = lgi.require('Gtk', '3.0')
GdkPixbuf = lgi.GdkPixbuf

assert = lgi.assert
local builder = Gtk.Builder()

assert(builder:add_from_file('main_window.ui'), "ERROR: el archivo no existe")

ui = builder.objects

require('test.stack') -- esto es una prueba
require('test.collections') -- esto es una prueba

function ui.main_window:on_destroy()
	Gtk.main_quit()
end

ui.main_window:show_all()
Gtk.main()
