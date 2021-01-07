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

update_collection_info = function (collectionName)
	if collectionName ~= '' then
		ui.entry_name_collection.text = metadata.collection[collectionName]['name']
		ui.entry_shortened_collection.text = metadata.collection[collectionName]['shortened']
		ui.textbuffer_launch_collection.text = metadata.collection[collectionName]['launch']
		route = 'edit_collection'
		ui.header.subtitle = 'Edit Collection ' .. string.upper(currentCollection)
		return true
	end
	ui.entry_name_collection.text = ''
	ui.entry_shortened_collection.text = ''
	ui.textbuffer_launch_collection.text = ''
	route = 'new_collection'
	ui.header.subtitle = 'New Collection'
	return false
end

edit_collection_info = function ()
	metadata.collection[currentCollection]['name'] = ui.entry_name_collection.text
	metadata.collection[currentCollection]['shortened'] = ui.entry_shortened_collection.text
	metadata.collection[currentCollection]['launch'] = ui.textbuffer_launch_collection.text

	ui.section:set_visible_child_name('page_new_game')
	route = 'new_game'
	ui.header.subtitle = 'New Game'
end

set_collection_info = function ()
	metadata.collection[ui.entry_shortened_collection.text] = {
		name = ui.entry_name_collection.text,
		shortened = ui.entry_shortened_collection.text,
		launch = ui.textbuffer_launch_collection.text,
		files = {}
	}
	local i = get_position_table(metadata.collection) + 1
	ui.sidebar:insert(Gtk.ListBoxRow {
		id = ui.entry_shortened_collection.text,
		visible = true,
		Gtk.Label {
			id = ui.entry_shortened_collection.text .. '_label',
			label = ui.entry_shortened_collection.text,
			halign = 1,
			height_request = 30,
			margin_left = 10,
			margin_right = 10,
			visible = true
		}
	}, i)
	ui.section:set_visible_child_name('page_new_game')
	route = 'new_game'
	ui.header.subtitle = 'New Game'
end

validate_collection_info = function ()
	if route == 'edit_collection' then
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
	elseif route == 'new_collection' then
		if ui.entry_name_collection.text ~= ''
			and ui.entry_shortened_collection.text ~= ''
			and ui.textbuffer_launch_collection.text ~= ''
		then
			return true, 'Guardado correctamente!'
		else
			return false, 'Fallo al guardar!'
		end
	end
end

save_collection_info = function ()
	local ok, msg = validate_collection_info()
	if ok then
		if route == 'edit_collection' then
			edit_collection_info()
			update_collection_info(currentCollection)
			update_collection_name()
		elseif route == 'new_collection' then
			set_collection_info()
		end
		config:save(configdir, metadata)
	else
		ui.section:set_visible_child_name('page_new_game')
		route = 'new_game'
		ui.header.subtitle = 'New Game'
	end
	print(msg)
end

ui.btn_save_collection['on_clicked'] = function ()
	save_collection_info()
end

-- ir a page_new_collection
function ui.btn_new_info:on_clicked()
	ui.section:set_visible_child_name('page_new_collection')
	route = 'new_collection'
	ui.header.subtitle = 'New Collection'
	currentCollection = ''
	clear_collection_info()
end

-- volver a page_list
ui.btn_back_page_list['on_clicked'] = function ()
	ui.section:set_visible_child_name('page_list')
	clear_collection_info()
	populate_gamelist()
	ui.header.subtitle = 'Game list of ' .. string.upper(currentCollection)
end
