--[[--
 @package   Solus Frontend
 @filename  new_collection.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      05.01.2021 01:12:31 -04
]]

clear_collection_info = function ()
	ui.entry_name_collection.text = ''
	ui.entry_shortened_collection.text = ''
	ui.textbuffer_launch_collection.text = ''
end

update_collection_info = function ()
	ui.entry_name_collection.text = metadata.collection[currentCollection]['name']
	ui.entry_shortened_collection.text = metadata.collection[currentCollection]['shortened']
	ui.textbuffer_launch_collection.text = metadata.collection[currentCollection]['launch']
end

set_collection_info = function ()
	metadata.collection[currentCollection]['name'] = ui.entry_name_collection.text
	metadata.collection[currentCollection]['shortened'] = ui.entry_shortened_collection.text
	metadata.collection[currentCollection]['launch'] = ui.textbuffer_launch_collection.text

	ui.section:set_visible_child_name('page_new_game')
	route = 'new_game'
	ui.header.title = 'Solus Frontend - New Game'
end

-- @TODO: validando los campos, si no hay campos cambiados cambio a la siguiente pagina
-- sino guardo los cambios y cambiao a la siguiente pagina
validate_collection_info = function ()
	if ui.entry_name_collection.text == metadata.collection[currentCollection]['name']
		and ui.entry_shortened_collection.text == metadata.collection[currentCollection]['shortened']
		and ui.textbuffer_launch_collection.text == metadata.collection[currentCollection]['launch']
	then
		return false, 'ERROR: las entradas son iguales, cambio a la siguiente pagina!'
	elseif ui.entry_name_collection.text ~= metadata.collection[currentCollection]['name']
		or ui.entry_shortened_collection.text ~= metadata.collection[currentCollection]['shortened']
		or ui.textbuffer_launch_collection.text ~= metadata.collection[currentCollection]['launch']
	then
		return true, 'Guardado correctamente!'
	end
end

save_collection_info = function ()
	local ok, msg = validate_collection_info()
	if ok then
		set_collection_info()
		config:save(configdir, metadata)
		update_collection_name()
		update_collection_info()
	else
		ui.section:set_visible_child_name('page_new_game')
		route = 'new_game'
		ui.header.title = 'Solus Frontend - New Game'
	end
	print(msg)
end

ui.btn_save_collection['on_clicked'] = function ()
	save_collection_info()
end

-- ir a page_new_collection
function ui.btn_new_info:on_clicked()
	update_collection_info()
	ui.section:set_visible_child_name('page_new_collection')
end

-- volver a page_list
ui.btn_back_page_list['on_clicked'] = function ()
	ui.section:set_visible_child_name('page_list')
	populate_gamelist()
end