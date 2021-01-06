--[[--
 @package   Solus Frontend
 @filename  new_game.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      05.01.2021 09:52:11 -04
]]

-- botón de pruebas
ui.btn_test['on_clicked'] = function ()
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

clear_game_info = function ()
	ui.entry_title_game.text = ''
	ui.textbuffer_summary_game.text = ''
	ui.textbuffer_description_game.text = ''
	ui.file_chooser_game:set_filename('')
	ui.range_max_players:set_value(0)
	ui.range_ratings:set_value(0)
end

delete_game_info = function (id_row)
	metadata.collection[currentCollection]['files'][id_row] = nil
	config:save(configdir, metadata)
	populate_gamelist()
	print('Delete row')
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

		config:save(configdir, metadata)
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
