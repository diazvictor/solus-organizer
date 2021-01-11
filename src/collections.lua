--[[--
 @package   Solus Frontend
 @filename  collections.lua
 @version   1.0
 @author    Díaz Devera Víctor  aka  (Máster Vitronic) <vitronic2@gmail.com>
 @date      10.01.2021 03:41:53 -04
]]

--- Show all collections
solus['show_collections'] = function ()
	-- get info of game
	local sql = [[
		select id_collection,
			logo,shortname
		from collections
	]]
	local collections = db:get_rows(sql)

	for _, collection in pairs(collections) do
		local image_decode = base64.decode(collection.logo)
		local stream = Gio.MemoryInputStream.new_from_data(image_decode)
		local image	= GdkPixbuf.Pixbuf.new_from_stream(stream)

		ui.collection_logo:add_titled(Gtk.Image {
			pixbuf = image
		}, collection.id_collection, collection.shortname)

		ui.gamelist:add_titled(Gtk.FlowBox {
			id = collection.id_collection,
			column_spacing = 20,
			row_spacing = 20,
			max_children_per_line = 4,
			min_children_per_line = 2,
			activate_on_single_click = false,
			on_child_activated = function (self, flowboxchild)
				solus.show_game_info(flowboxchild.id)
			end
		}, collection.id_collection, collection.shortname)

		solus.show_games(collection.id_collection)
	end
end

--- Show a collection by id
-- @param id_collection number: collection id
solus['show_collection'] = function (id_collection)
	-- get info of game
	local sql = [[
		select id_collection,logo,shortname
			from collections
		where id_collection = %d
	]]
	local collection = db:get_rows(sql, id_collection)
	local ok = ui.collection_logo:get_child_by_name(id_collection) -- check collection

	if not ok then
		local image_decode = base64.decode(collection[1]['logo'])
		local stream = Gio.MemoryInputStream.new_from_data(image_decode)
		local image	= GdkPixbuf.Pixbuf.new_from_stream(stream)

		ui.collection_logo:add_titled(Gtk.Image {
			visible = true,
			pixbuf = image
		}, collection[1]['id_collection'], collection[1]['shortname'])

		ui.gamelist:add_titled(Gtk.FlowBox {
			id = collection[1]['id_collection'],
			visible = true,
			column_spacing = 20,
			row_spacing = 20,
			max_children_per_line = 4,
			min_children_per_line = 2,
			activate_on_single_click = false,
			on_child_activated = function (self, flowboxchild)
				solus.show_game_info(flowboxchild.id)
			end
		}, collection[1]['id_collection'], collection[1]['shortname'])
		solus.show_games(collection[1]['id_collection'])
	end
	ui.collection_logo:set_visible_child_name(collection[1]['id_collection'])
	ui.gamelist:set_visible_child_name(collection[1]['id_collection'])
end
