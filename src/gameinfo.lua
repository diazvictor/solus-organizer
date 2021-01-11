--[[--
 @package   Solus Frontend
 @filename  gameinfo.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      09.01.2021 17:14:18 -04
]]

--- Get the info game
-- @param id_game number: id of game
-- @return table: the info
solus['get_game_info'] = function (id_game)
	local sql = [[
		select games.id_game, games.name, games.rom, collections.launch
		from collections
		join games on (games.id_collection = collections.id_collection)
		where games.id_game = %d;
	]]
	local game = db:get_rows(sql, id_game)
	return game[1]
end

--- Show game info and go to "gameinfo"
-- @return boolean: true
solus['show_game_info'] = function (iid_game)
	local game = solus.get_game_info(id_game)
	local command = ('"%s" "%s" &'):format(game.launch, game.rom)

	ui.gameinfo_title.label = game.name
	ui.gameinfo_desc.label = game.description or 'null'

	ui.gameinfo_btn_launch['on_clicked'] = function ()
		os.execute(command)
	end

	ui.section:set_visible_child_name('gameinfo')
	return true
end

ui.gameinfo_sidebar['on_row_activated'] = function ()
	if ui.btn_info_desc:is_selected() == true then
		ui.gameinfo_pages:set_visible_child_name('gameinfo_page_desc')
	elseif ui.btn_info_screen:is_selected() == true then
		ui.gameinfo_pages:set_visible_child_name('gameinfo_page_screen')
	elseif ui.btn_info_others:is_selected() == true then
		ui.gameinfo_pages:set_visible_child_name('gameinfo_page_others')
	end
end

ui.gameinfo_btn_back['on_clicked'] = function ()
	ui.section:set_visible_child_name('gamelist')
end
