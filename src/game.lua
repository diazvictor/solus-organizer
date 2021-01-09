--[[--
 @package   Solus Frontend
 @filename  new_game.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      05.01.2021 09:52:11 -04
]]

-- botón de pruebas
ui.btn_test['on_clicked'] = function ()
	print(route, currentCollection)
end

clear_game_info = function ()
	ui.entry_title_game.text = ''
	ui.textbuffer_summary_game.text = ''
	ui.textbuffer_description_game.text = ''
	ui.entry_developer_game.text = ''
	ui.entry_genre_game.text = ''
	ui.file_chooser_game:set_filename('')
	ui.range_max_players:set_value(1)
	ui.range_ratings:set_value(0)
end

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

delete_game_info = function (id_row)
	metadata.collection[currentCollection]['files'][id_row] = nil
	config:save(collection_file, metadata)
	populate_gamelist()
	print('Delete row')
end

validate_game_info = function ()
	if ui.entry_title_game.text ~= ''
		and ui.file_chooser_game:get_filename() ~= ''
	then
		return true, 'Guardado correctamente!'
	else
		return false, 'Fallo al guardar!'
	end
end

set_game_info = function ()
	table.insert(metadata.collection[currentCollection]['files'], {
		title = ui.entry_title_game.text,
		file = ui.file_chooser_game:get_filename(),
		developer = ui.entry_developer_game.text or 'null',
		genre = ui.entry_genre_game.text or 'null',
		players = ui.range_max_players:get_value(),
		rating = ui.range_ratings:get_value(),
		description = ui.textbuffer_description_game.text or 'null',
		last_time = "00:00"
	})
end

save_game_info = function ()
	local ok,msg = validate_game_info()
	if ok then
		if route == 'edit_game' then
			set_edit_info()
		elseif route == 'new_game' then
			set_game_info()
		end

		config:save(collection_file, metadata)
		ui.section:set_visible_child_name('page_list')
		populate_gamelist()
		clear_game_info()
	end
	print(msg)
end

ui.btn_save_game['on_clicked'] = function ()
	save_game_info()
end

ui.btn_back_collection['on_clicked'] = function ()
	ui.section:set_visible_child_name('page_new_collection')
	update_collection_info(currentCollection)
	clear_game_info()
end
