

-- @return boolean: true
solus['show_collections'] = function ()
	-- get info of game
	local sql = [[
		select id_collection,
			logo,shortname
		from collections
	]]
	local collections = db:get_rows(sql)

	for _,value in pairs(collections) do
		--if (value.logo) then
			local image_decode = base64.decode(value.logo)
			local stream 	   = Gio.MemoryInputStream.new_from_data(image_decode)
			local image	   = GdkPixbuf.Pixbuf.new_from_stream(stream)
		--end
		
		ui.collection_logo:add_titled(Gtk.Image {
			pixbuf = image
		}, value.id_collection, value.shortname)

		---
		ui.gamelist:add_titled(Gtk.FlowBox {
			id = value.id_collection
		}, value.id_collection, value.shortname)

		solus.show_games(value.id_collection)
		print(value.id_collection,value.shortname)
	end
end
solus.show_collections()





