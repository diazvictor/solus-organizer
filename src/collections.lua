--[[--
 @package   Solus Frontend
 @filename  collections.lua
 @version   1.0
 @author    Díaz Devera Víctor  aka  (Máster Vitronic) <vitronic2@gmail.com>
 @date      10.01.2021 03:41:53 -04
]]

function solus:get_pages(page)
	local sql 	= [[select count(id_collection) from collections]]
	local records 	= db:get_var(sql);
	if records == '0' then
		records = 1
	end
	pagination:set_page(page)
	pagination:new({
		records		= records,
		limit		= 1
	})
	return pagination:get_pagination()
end

--- Show all collections
function solus:show_collections()
	--La consulta Sql
	sql = [[
		select id_collection,logo,shortname
			from collections
		order by id_collection asc limit %d offset %d
	]]
	local collections = db:get_results(sql,pages.limit,pages.offset)

	for _, collection in pairs(collections) do
		local exist = ui.collection_logo:get_child_by_name(collection.id_collection) -- check collection
		if not exist then
			local image_decode = base64.decode(collection.logo)
			local stream = Gio.MemoryInputStream.new_from_data(image_decode)
			local image	= GdkPixbuf.Pixbuf.new_from_stream(stream)

			ui.collection_logo:add_titled(Gtk.Image {
				visible=true,
				pixbuf = image
			}, collection.id_collection, collection.shortname)

			ui.gamelist:add_titled(Gtk.FlowBox {
				id = collection.id_collection,
				visible=true,
				column_spacing = 20,
				row_spacing = 20,
				max_children_per_line = 4,
				min_children_per_line = 2,
				activate_on_single_click = false,
				on_child_activated = function (self, flowboxchild)
					solus.show_game_info(flowboxchild.id)
				end
			}, collection.id_collection, collection.shortname)
		end
		ui.collection_logo:set_visible_child_name(collection.id_collection)
		ui.gamelist:set_visible_child_name(collection.id_collection)
		solus:show_games(collection.id_collection, exist)
	end
end
