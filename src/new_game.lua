--[[--
 @package   Solus Frontend
 @filename  new_game.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      17.01.2021 21:01:18 -04
]]

--- I show the games of a collection in a table
-- @param name string: the collection name
function populate_games (name)
	local sql = [[
		select games.name
			from collections
		join games on (collections.id_collection = games.id_collection)
		where collections.name = %s order by games.id_game desc;
	]]
	local games = db:get_rows(sql, name)

	for _, item in ipairs(games) do
		ui.games_liststore:append({
			item.name or 'No Games Found'
		})
	end
end

--- Clear fields
function clear_game_info ()
	ui.game_name.text = ''
	ui.game_desc_buffer.text = ''
	ui.btn_file_rom:set_filename(GLib.get_home_dir())
end

--- Edit game by name
-- @param name string: the game name
function edit_game (name)
	local sql = [[
		select games.id_game, games.name,
		games.description, games.rom
			from collections
		join games on (games.id_collection = collections.id_collection)
		where games.name = %s;
	]]
	local game = db:get_rows(sql, name)[1]

	ui.game_name.text = game.name or 'nil'
	ui.game_desc_buffer.text = game.description or 'nil'
	ui.btn_file_rom:set_filename(game.rom or 'nil')
end

--- By clicking on a column
function ui.games_view:on_row_activated ()
	local row_name = solus:get_row_name(ui.games_view)
	ui.forms:set_visible_child_name('new_game')
	edit_game(row_name)
end

--- When doing a search
function ui.search_games:on_changed ()
	local search = ui.search_games.text
end

--- By pressing the button (new game)
function ui.btn_new_game:on_clicked ()
	clear_game_info()
	ui.forms:set_visible_child_name('new_game')
end
