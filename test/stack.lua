--[[--
 @package   Solus Frontend
 @filename  stack.lua
 @version   1.6
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      04.01.2021 20:54:35 -04
]]

configdir = '../test/metadata.json'
metadata = config:load(configdir)

-- añado los items al sidebar
populate_collection = function ()
	for shortened,value in pairs(metadata.collection) do
		for _,name in pairs(metadata.collection[shortened]) do
			if _ == 'name' then
				ui.sidebar:prepend(
					Gtk.ListBoxRow {
						id = shortened,
						Gtk.Label {
							id = shortened .. '_label',
							label = name,
							halign = 1,
							height_request = 20,
						}
					}
				)
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
local populate_gamelist = function ()
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
	local id = tostring(get_row_id())
	local info = {}
	info.collection, info.name, info.launch = metadata.collection[currentCollection]['shortened'], metadata.collection[currentCollection]['name'], metadata.collection[currentCollection]['launch']
	for key,value in pairs(metadata.collection[currentCollection]['files'][id]) do
		info[key] = value
	end
	return info
end

-- al hacer click en una columna
ui.gamelist_view['on_row_activated'] = function ()
	local info = get_row_info()
	ui.info_name.label = utils:truncate(info.title) or 'null'
	ui.info_developer.label = info.developer or 'null'
	ui.info_genre.label = info.genre or 'null'
	ui.info_players.label = info.players or 'null'
	ui.info_rating.label = info.rating or 'null'
	ui.section:set_visible_child_name('page_information')
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
	ui.section:set_visible_child_name('page_list')
	populate_gamelist()
end

-- @TODO: hacer un metodo para volver a la pagina anterior
ui.btn_back_information['on_clicked'] = function ()
	ui.section:set_visible_child_name('page_list')
	populate_gamelist()
end

ui.btn_back_game['on_clicked'] = function ()
	ui.section:set_visible_child_name('page_new_collections')
	populate_gamelist()
end

-- @TODO: con esto hare un bucle interador para la lista de juegos
-- ui.section:add_titled(Gtk.FlowBox {
	-- max_children_per_line = 3,
	-- margin_top = 2,
	-- margin_left = 2,
	-- margin_right = 2,
	-- margin_bottom = 2,

	-- Gtk.FlowBoxChild {
		-- tooltip_text = metadata.game,
		-- on_activate = function ()
			-- print(('%s'):format(metadata.launch))
		-- end,
		-- Gtk.Image {
			-- icon_name = 'application-x-gameboy-rom'
		-- }
	-- }
-- }, metadata.collection, metadata.name)

-- local new_section = function (widget,id,name)
	-- ui.section:add_titled(widget, id, name)
-- end

function ui.btn_new_game:on_clicked()
	ui.section:set_visible_child_name('page_new_game')
end

-- function ui.btn_save_metadata:on_clicked()
	-- if ui.entry_aftername_metadata.text ~= '' and ui.entry_firstname_metadata.text ~= '' then
		-- config:save(configdir, {
			-- aftername = ui.entry_aftername_metadata.text,
			-- firstname = ui.entry_firstname_metadata.text
		-- })
	-- end
-- end