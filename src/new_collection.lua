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
	ui.collection_name.text = ''
	ui.collection_shortname.text = ''
	ui.collection_desc_buffer.text = ''
	ui.collection_launch_buffer.text = ''
end

--- Edit collection by name
-- @param name string: the collection name
function edit_collection (name)
	local sql = [[
		select *
			from collections
		where name = %s;
	]]
	local collection = db:get_rows(sql, name)[1]

	ui.collection_name.text = collection.name or 'nil'
	ui.collection_shortname.text = collection.shortname or 'nil'
	ui.collection_desc_buffer.text = collection.description or 'nil'
	ui.collection_launch_buffer.text = collection.launch or 'nil'
end

--- By clicking on a column
function ui.collections_view:on_row_activated ()
	local row_name = solus:get_row_name(ui.collections_view)
	ui.games_liststore:clear()
	populate_games(row_name)
	ui.forms:set_visible_child_name('new_collection')
	edit_collection(row_name)
end

--- When doing a search
function ui.search_collections:on_changed ()
	local search = ui.search_collections.text
	ui.collections_liststore:clear()
	populate_collections(search)
end

--- By pressing the button (new collection)
function ui.btn_new_collection:on_clicked ()
	clear_collection_info()
	ui.forms:set_visible_child_name('new_collection')
end
