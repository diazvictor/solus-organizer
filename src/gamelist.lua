--[[--
 @package   Solus Frontend
 @filename  gamelist.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      09.01.2021 15:10:32 -04
]]

pagination:new(ui.gamelist)
pagination:set_page('page_current')

pagination:new(ui.gamelist_logo)
pagination:set_page('page_current')

ui.btn_prev['on_clicked'] = function ()
	pagination:new(ui.gamelist)
	pagination:get_prev_page()

	pagination:new(ui.gamelist_logo)
	pagination:get_prev_page()
end

ui.btn_next['on_clicked'] = function ()
	pagination:new(ui.gamelist)
	pagination:get_next_page()

	pagination:new(ui.gamelist_logo)
	pagination:get_next_page()
end

--- Show game list and logo
-- @param shortname string: shortname of collection
-- @return boolean: true
solus['show_game_list'] = function (shortname)
	-- get info of game
	local sql = [[
		select games.id_game, games.name, games.rom
		from collections
		join games on (games.id_collection = collections.id_collection)
		where collections.shortname = %s
	]]
	local collection = db:get_rows(sql, shortname)

	sql = 'select logo from collections where shortname = %s'
	collection.logo = db:get_var(sql, shortname)

	local image_decode = base64.decode(collection.logo)
	local stream = Gio.MemoryInputStream.new_from_data(image_decode)
	local image	 = GdkPixbuf.Pixbuf.new_from_stream(stream)
	-- image = image:scale_simple(569, 100, 'BILINEAR')
	ui.gamelist_logo_current:set_from_pixbuf(image)

	for i, game in pairs(collection) do
		if type(game) == 'table' then
			ui.gamelist_current:insert(Gtk.FlowBoxChild {
				id = i,
				width = 200,
				height = 100,
				Gtk.Label {
					label = utils:truncate(game.name, 21)
				}
			}, i)
		end
	end
end
solus.show_game_list('snes')

ui.gamelist_current['on_child_activated'] = function (self, flowboxchild)
	solus.show_game_info(flowboxchild.id)
end
