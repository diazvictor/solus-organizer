--[[--
 @package   Solus Frontend
 @filename  collections.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      05.01.2021 01:12:31 -04
]]

-- botón de pruebas
ui.btn_test['on_clicked'] = function ()
	print('Click!')
end

local set_collection_info = function ()
	metadata.collection[currentCollection]['name'] = ui.entry_name_collection.text
	metadata.collection[currentCollection]['shortened'] = ui.entry_shortened_collection.text
	metadata.collection[currentCollection]['launch'] = ui.textbuffer_launch_collection.text

	config:save(configdir, metadata)
	update_collection_name()
end

ui.btn_save_collection_game['on_clicked'] = function ()
	set_collection_info()
end

-- ir a page_new_collections
function ui.btn_new_collections:on_clicked()
	ui.entry_name_collection.text = metadata.collection[currentCollection]['name']
	ui.entry_shortened_collection.text = metadata.collection[currentCollection]['shortened']
	ui.textbuffer_launch_collection.text = metadata.collection[currentCollection]['launch']

	ui.section:set_visible_child_name('page_new_collections')
end

-- volver a page_list
ui.btn_back_collections['on_clicked'] = function ()
	ui.section:set_visible_child_name('page_list')
	populate_gamelist()
end