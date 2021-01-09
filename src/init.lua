--[[--
 @package   Solus Frontend
 @filename  init.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      21.07.2020 20:01:41 -04
]]

package.path = package.path .. ';../lib/?.lua'

print("Loading libraries:")
lgi = require 'lgi'
print("| 'lgi' loaded successfully. (Thanks Pavouk!)")

GObject = lgi.GObject
GLib = lgi.GLib
Gtk = lgi.require('Gtk', '3.0')
GdkPixbuf = lgi.GdkPixbuf

require 'solus'
print("Libraries loaded!\n")

assert = lgi.assert
local builder = Gtk.Builder()

assert(builder:add_from_file('../data/gtk/main_window.ui'), "ERROR: el archivo no existe")

ui = builder.objects

require('gamelist') -- show game list
require('collection') -- new/edit collection
require('game') -- new/edit game

function ui.main_window:on_destroy()
	Gtk.main_quit()
end

ui.main_window:show_all()
Gtk.main()
