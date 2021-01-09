--[[--
 @package   Solus Frontend
 @filename  stack.lua
 @version   1.6
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      04.01.2021 20:54:35 -04
]]

currentCollection = ''

get_position_table = function (t)
	local i = 0
	for k,v in pairs(t) do
		i = i + 1
	end
	return i
end

-- añado los items al sidebar
populate_collection = function ()
	local i = get_position_table(metadata.collection)
	for shortened,value in pairs(metadata.collection) do
		for _,name in pairs(metadata.collection[shortened]) do
			if _ == 'name' then
				ui.sidebar:insert(Gtk.ListBoxRow {
					id = shortened,
					Gtk.Label {
						id = shortened .. '_label',
						label = name,
						halign = 1,
						height_request = 30,
						margin_left = 10,
						margin_right = 10
					}
				}, i)
			end
		end
	end
end
populate_collection()

-- actulizo el nombre y el id de los items del sidebar
update_collection_name = function ()
	for shortened,value in pairs(metadata.collection) do
		for _,name in pairs(metadata.collection[shortened]) do
			local id = ('%s_label'):format(shortened)
			ui.sidebar.child[shortened] = metadata.collection[shortened]
			ui.sidebar.child[shortened]['child'][id]['label'] = metadata.collection[shortened]['name']
		end
	end
end

-- añado los items al treeview (gamelist)
populate_gamelist = function ()
	ui.gamelist:clear()
	for shortened,_ in pairs(metadata.collection) do
		if ui.sidebar.child[shortened]:is_selected() == true then
			-- @TODO: variable global mal situada
			currentCollection = shortened -- aprovecho y guardo la collection el que estoy actualmente situado
			for num,item in pairs(metadata.collection[shortened]['files']) do
				ui.gamelist:append({
					num, -- ID
					item.title, -- NAME
					item.last_time
				})
			end
		end
	end
end

-- retorno el id de una columna seleccionada
get_row_id = function ()
	local selection = ui.gamelist_view:get_selection()
	selection.mode = 'SINGLE'
	local model, iter = selection:get_selected()
	if model and iter then
		id_row = model:get_value(iter, 0):get_int()
		-- local item_name = model:get_value(iter, 1):get_string()
		return id_row
	end
end

-- retorno una tabla con la información de la columna seleccionada
get_row_info = function ()
	local id_row = get_row_id()
	local info = {}
	info.collection, info.name, info.launch = metadata.collection[currentCollection]['shortened'], metadata.collection[currentCollection]['name'], metadata.collection[currentCollection]['launch']
	for key,value in pairs(metadata.collection[currentCollection]['files'][id_row]) do
		info[key] = value
	end
	return info
end

-- al hacer click en una columna
ui.gamelist_view['on_row_activated'] = function ()
	local info = get_row_info()
	ui.info_name.label = info.title or 'null'
	ui.info_developer.label = info.developer or 'null'
	ui.info_desc.label = info.description or 'null'
	ui.info_genre.label = info.genre or 'null'
	ui.info_players.label = info.players or 'null'
	ui.info_rating.label = info.rating .. '%' or 'null'
	ui.section:set_visible_child_name('page_information')
	ui.header.subtitle = 'Information of ' .. ui.info_name.label
end

-- al hacer click en el botón LAUNCH!
ui.btn_launch['on_clicked'] = function ()
	local info = get_row_info()
	local command = ('"%s" "%s" &'):format(info.launch, info.file)
	os.execute(command)
end

-- actualizo el treeview (gamelist) por cada click
-- que le haga a un item del sidebar
ui.sidebar['on_row_activated'] = function ()
	if ui.section:get_visible_child_name() == 'page_list'
		or ui.section:get_visible_child_name() == 'page_information'
	then
		ui.section:set_visible_child_name('page_list')
		populate_gamelist()
		ui.header.subtitle = 'Game list of ' .. string.upper(currentCollection)
	elseif ui.section:get_visible_child_name() == 'page_new_collection' then
		for shortened,_ in pairs(metadata.collection) do
			if ui.sidebar.child[shortened]:is_selected() == true then
				currentCollection = shortened
			end
		end
		update_collection_info(currentCollection)
		ui.header.subtitle = 'Edit Collection ' .. string.upper(currentCollection)
	elseif ui.section:get_visible_child_name() == 'page_new_game' then
		for shortened,_ in pairs(metadata.collection) do
			if ui.sidebar.child[shortened]:is_selected() == true then
				currentCollection = shortened
			end
		end
		print(currentCollection)
		ui.header.subtitle = 'New Game'
	end
end

function ui.gamelist_view:on_button_press_event(event)
	local x = tonumber(event.x)
	local y = tonumber(event.y)
	local pthinfo = self:get_path_at_pos(x, y)
	if (pthinfo and event.type == 'BUTTON_PRESS' and event.button == 3) then
		local id_row = get_row_id()
		local menu = Gtk.Menu {
			Gtk.ImageMenuItem {
				id = "edit",
				label = "Editar",
				image = Gtk.Image {
					stock = "gtk-edit"
				},
				on_activate = function()
					edit_game_info(id_row)
				end
			},
			Gtk.SeparatorMenuItem {},
			Gtk.ImageMenuItem {
				id = "delete",
				label = "Borrar",
				image = Gtk.Image {
					stock = "gtk-delete"
				},
				on_activate = function()
					delete_game_info(id_row)
				end
			}
		}
		if id_row then
			menu:attach_to_widget(ui.gamelist_view, null)
			menu:show_all()
			menu:popup(nil, nil, nil, event.button, event.time)
		end
	end
end

-- @TODO: hacer un metodo para volver a la pagina anterior
ui.btn_back_information['on_clicked'] = function ()
	ui.section:set_visible_child_name('page_list')
	populate_gamelist()
	ui.header.subtitle = 'Game list of ' .. string.upper(currentCollection)
end

ui.btn_back_page_list['on_clicked'] = function ()
	ui.section:set_visible_child_name('page_list')
	populate_gamelist()
	ui.header.subtitle = 'Game list of ' .. string.upper(currentCollection)
end