--[[--
 @package   Solus Frontend
 @filename  init.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      07.01.2021 19:33:02 -04
]]

package.path = package.path .. ';../lib/?.lua'

print("Loading libraries:")
lgi = require 'lgi'
print("| 'lgi' loaded successfully. (Thanks Pavouk!)")

GObject = lgi.GObject
print("|----- 'GObject' loaded successfully.")
Gtk = lgi.require('Gtk', '3.0')
print("|----- 'Gtk' loaded successfully.")
Gdk = lgi.Gdk
print("|----- 'Gdk' loaded successfully.")
GLib = lgi.GLib
print("|----- 'GLib' loaded successfully.")
Gio = lgi.Gio
print("|----- 'Gio' loaded successfully.")
GdkPixbuf = lgi.GdkPixbuf
print("|----- 'GdkPixbuf' loaded successfully.")

require 'solus'
print("Libraries loaded!\n")

assert = lgi.assert
local builder = Gtk.Builder()
assert(builder:add_from_file('../data/gtk/main_window.ui'), 'ERROR: the file does not exist')
ui = builder.objects

ui.head:pack_end(Gtk.Box {
	orientation = 'HORIZONTAL',
	spacing = 6,
	Gtk.Button {
		on_clicked = function ()
		end
	},
	Gtk.Separator {},
	Gtk.MenuButton {
		id = 'btn_menu',
		Gtk.Image {
			icon_name = 'open-menu-symbolic'
		}
	}
}, false, false, 0)

ui.head.child.btn_menu:set_popover(ui.menu)

require 'gamelist'
require 'collections'
require 'gameinfo'

solus['set_page'] = function (page)
	local sql = [[
		select count (id_collection) from collections
	]]
	local records = db:get_var(sql)

	pagination:set_page(page)
	pagination:new({
		records	= records,
		limit = 1
	})
	solus.show_collection(page)
end

solus.set_page(1)
local pages = pagination:get_pagination()

ui.btn_prev['on_clicked'] = function ()
	solus.set_page(pages.prev_page)
end

ui.btn_next['on_clicked'] = function ()
	solus.show_collection(pages.next_page)
end

function ui.main_window:on_destroy()
	db:close()
	Gtk.main_quit()
end

ui.main_window:show_all()
Gtk.main()
