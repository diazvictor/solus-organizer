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

ui.header:pack_end(Gtk.Box {
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
})
ui.header.child.btn_menu:set_popover(ui.menu)

require 'gamelist'
require 'collections'
require 'gameinfo'

pages = solus:get_pages(1)
solus.show_collections()

function ui.btn_new:on_clicked ()
	ui.nav:set_visible_child_name('nav_new')
	ui.body:set_visible_child_name('new')
	ui.collections_liststore:clear()
	populate_collections()
end

function ui.btn_back:on_clicked ()
	ui.nav:set_visible_child_name('nav_collection')
	ui.body:set_visible_child_name('collections')
end

function ui.btn_prev:on_clicked()
	pages = solus:get_pages(pages.prev_page)
	solus.show_collections()
end

function ui.btn_next:on_clicked()
	pages = solus:get_pages(pages.next_page)
	solus.show_collections()
end

function ui.main_window:on_destroy()
	db:close()
	Gtk.main_quit()
end

ui.main_window:show_all()
Gtk.main()
