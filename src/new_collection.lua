--[[--
 @package   Solus Frontend
 @filename  new_collection.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      17.01.2021 01:58:40 -04
]]

--- I show the collections in a table
-- if name exists I show the similarities, if not I show all
-- @param name string: the collection name
function populate_collections (name)
	local sql, collections
	if name then
		sql = [[
			select name
				from collections
			where name like %s order by id_collection desc
		]]
		collections = db:get_rows(sql, ('%%%s%%'):format(utils:trim(name)))
	else
		sql = "select name from collections order by id_collection desc"
		collections = db:get_rows(sql)
	end

	for _, item in ipairs(collections) do
		ui.collections_liststore:append({
			item.name
		})
	end
end

--- I return the name of a selected column
-- @param treeview userdata: GtkTreeView widget
-- @return string
function solus:get_row_name (treeview)
	local selection = treeview:get_selection()
	selection.mode = 'SINGLE'
	local model, iter = selection:get_selected()
	if model and iter then
		-- local id_row = model:get_value(iter, 0):get_int()
		local row_name = model:get_value(iter, 0):get_string()
		return row_name
	end
end

--- Clear fields
function clear_collection_info ()
	ui.collection_logo_preview.stock = 'gtk-missing-image'
	ui.btn_logo_collection:unselect_all()
	ui.collection_name.text = ''
	ui.collection_shortname.text = ''
	ui.collection_desc_buffer.text = ''
	ui.collection_launch_buffer.text = ''
end

--- Show collection info by name
-- @param name string: the collection name
function solus:show_collection_info (name)
	local sql = [[
		select *
			from collections
		where name = %s;
	]]
	local collection = db:get_rows(sql, name)[1]

	if collection.logo ~= nil and collection.logo ~= '' then
		local logo = solus:decode_image(collection.logo, 420, 100)
		ui.collection_logo_preview.pixbuf = logo
	else
		ui.collection_logo_preview.stock = 'gtk-missing-image'
	end

	ui.collection_name.text = collection.name or 'nil'
	ui.collection_shortname.text = collection.shortname or 'nil'
	ui.collection_desc_buffer.text = collection.description or 'nil'
	ui.collection_launch_buffer.text = collection.launch or 'nil'
end

--- Validation of the fields
-- @return boolean: true whether the validation was successful
-- or false in the opposite case
-- @return msg string: response message
function validate_collection ()
	local msg
	if (utils:trim(ui.collection_name.text) == '') then
		msg = 'The name of the collection is a required field.'
		ui.collection_name:grab_focus()
	elseif (utils:trim(ui.collection_launch_buffer.text) == '') then
		msg = 'The collection launcher is a required field.'
		ui.collection_launch:grab_focus()
	end
	if (msg) then
		return false, msg
	end
	return true
end

--- Save collection, if the argument name exists
-- the collection is updated
-- @param name string: the collection name
-- @return boolean: true if the query was executed or
-- false in the opposite case
-- @return msg string: response message
function save_collection (name)
	local sql, msg, logo_default, logo

	if name then
		sql = "select logo from collections where name = %s"
		logo_default = db:get_var(sql, name)
	end
	logo = solus:encode_image(
		ui.btn_logo_collection:get_filename()
	) or logo_default or ''

	local values = {
		logo,
		ui.collection_name.text,
		ui.collection_shortname.text,
		ui.collection_desc_buffer.text,
		ui.collection_launch_buffer.text
	}

	local validate, err = validate_collection()
	if ( not validate ) then
		return false, err
	end

	if (name) then
		sql = [[
			update collections set logo = %s, name = %s, shortname = %s,
			description = %s, launch = %s
			where name = %s
		]]
		table.insert(values, name)
		msg = 'Successfully updated collection!'
	else
		sql = [[
			insert into collections (
				logo, name, shortname, description, launch
			) values (%s, %s, %s, %s, %s)
		]]
		msg = 'Successfully registered collection!'
	end

	local ok, err = db:execute(sql, values)
	if (not ok) then
		return false, err
	end

	ui.collections_liststore:clear()
	populate_collections()
	return true, msg
end

--- By clicking on a column
function ui.collections_view:on_row_activated ()
	local row_name = solus:get_row_name(ui.collections_view)
	ui.games_liststore:clear()
	populate_games(row_name)
	ui.forms:set_visible_child_name('new_collection')
	solus:show_collection_info(row_name)
end

--- When doing a search
function ui.search_collections:on_changed ()
	local search = ui.search_collections.text
	ui.collections_liststore:clear()
	populate_collections(search)
end

--- By pressing the button (new collection)
function ui.btn_new_collection:on_clicked ()
	local selection = ui.collections_view:get_selection()
	selection.mode = 'SINGLE'
	selection:unselect_all()
	clear_collection_info()
	ui.games_liststore:clear()
	ui.forms:set_visible_child_name('new_collection')
end
