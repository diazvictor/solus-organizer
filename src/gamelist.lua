--[[--
 @package   Solus Frontend
 @filename  gamelist.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      09.01.2021 15:10:32 -04
]]

--- Show game list and logo
-- @param id number: id of collection
-- @return boolean: true
solus['show_games'] = function (id_collection)
	-- get info of game
	local sql = [[
		select id_collection, id_game, logo, name, rom
			from games
		where id_collection = %d
	]]
	local games = db:get_rows(sql, id_collection)

	local cover = nil
	for _, game in pairs(games) do
		if game.logo ~= nil and game.logo ~= '' then
			local image_decode = base64.decode(game.logo)
			local stream = Gio.MemoryInputStream.new_from_data(image_decode)
			local image = GdkPixbuf.Pixbuf.new_from_stream(stream)
			image = image:scale_simple(200, 150, 'BILINEAR')

			cover = Gtk.Overlay {
				id = 'overlay' .. game.id_game,
				visible = true,
				Gtk.Image {
					visible = true,
					pixbuf = image
				}
			}
			print(utils:truncate(game.name, 17) .. ' logo loading ... ', image)
		else
			cover = Gtk.Label {
				visible = true,
				label = utils:truncate(game.name, 21)
			}
			print(utils:truncate(game.name, 17) .. ' logo not found ...', image)
		end
		ui.gamelist.child[game.id_collection]:insert(Gtk.FlowBoxChild {
			id = game.id_game,
			visible = true,
			width = 200,
			height = 200,
			cover
		}, game.id_game)
	end
end
