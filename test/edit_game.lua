--[[--
 @package   Solus Frontend
 @filename  edit_game.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      05.01.2021 18:34:32 -04
]]

set_edit_info = function ()
	local id_row = get_row_id()
	for key,value in pairs(metadata.collection[currentCollection].files) do
		if key == id_row then
			value.title = ui.entry_title_game.text
			value.file = ui.file_chooser_game:get_filename()
			value.developer = ui.entry_developer_game.text or 'null'
			value.genre = ui.entry_genre_game.text or 'null'
			value.players = ui.range_max_players:get_value() or 0
			value.rating = ui.range_ratings:get_value() or 0
			value.description = ui.textbuffer_description_game.text or 'null'
			value.last_time = "00:00"
		end
	end
end

edit_game_info = function (id_row)
	ui.entry_title_game.text = metadata.collection[currentCollection]['files'][id_row]['title'] or 'null'
	ui.textbuffer_summary_game.text = metadata.collection[currentCollection]['files'][id_row]['summary'] or 'null'
	ui.textbuffer_description_game.text = metadata.collection[currentCollection]['files'][id_row]['description'] or 'null'
	ui.entry_developer_game.text = metadata.collection[currentCollection]['files'][id_row]['developer'] or 'null'
	ui.entry_genre_game.text = metadata.collection[currentCollection]['files'][id_row]['genre'] or 'null'
	ui.file_chooser_game:set_filename(metadata.collection[currentCollection]['files'][id_row]['file'] or 'null')
	ui.range_max_players:set_value(metadata.collection[currentCollection]['files'][id_row]['players'] or 0)
	ui.range_ratings:set_value(metadata.collection[currentCollection]['files'][id_row]['rating'] or 0)

	ui.section:set_visible_child_name('page_new_game')
	route = 'edit_game'
	ui.header.subtitle = 'Edit Game #' .. id_row .. ' of ' .. string.upper(currentCollection)
end
