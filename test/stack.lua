--[[--
 @package   Solus Frontend
 @filename  stack.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      21.07.2020 21:47:57 -04
]]

configdir = '../test/metadata.json'
metadata = config:load(configdir)
-- intento cargar/guardar información en un archivo json, ademas de
-- buscar un nombre para el archivo de metadatos (donde se guardara la información de las roms)

-- if metadata.collection == 'gba' then
	-- metadata.name = 'GAME BOY ADVANCE'
-- end
-- print(ui.sidebar:get_activate_on_single_click())
for controller,_ in pairs(metadata.collection) do
	for console,name in pairs(metadata.collection[controller]) do
		if console == 'name' then
			ui.sidebar:prepend(
				Gtk.ListBoxRow {
					id = controller,
					Gtk.Label {
						label = name,
						halign = 1,
						height_request = 20,
					}
				}
			)
		end
	end
end

local populate_gamelist = function ()
	ui.gamelist:clear()
	for controller,_ in pairs(metadata.collection) do
		if ui.sidebar.child[controller]:is_selected() == true then
			for _,item in pairs(metadata.collection[controller]['files']) do
				ui.gamelist:append({
					item.game,
					-- @TODO: variable para mostrar la ultima vez que se ejecuto
					os.date('%H:%M:%S')
				})
			end
		end
	end
end

ui.sidebar['on_row_activated'] = function ()
	-- ui.section:set_visible_child_name('page_information')
	populate_gamelist()
end
-- @TODO: hacer un metodo para volver a la pagina anterior
ui.btn_back['on_clicked'] = function ()
	ui.section:set_visible_child_name('page_list')
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

-- function ui.btn_new_metadata:on_clicked()
	-- ui.dialog_new_metadata:show_all()
-- end

-- function ui.btn_cancel_metadata:on_clicked()
	-- ui.dialog_new_metadata:hide()
-- end

-- function ui.btn_save_metadata:on_clicked()
	-- if ui.entry_aftername_metadata.text ~= '' and ui.entry_firstname_metadata.text ~= '' then
		-- config:save(configdir, {
			-- aftername = ui.entry_aftername_metadata.text,
			-- firstname = ui.entry_firstname_metadata.text
		-- })
	-- end
-- end