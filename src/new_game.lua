--[[--
 @package   Solus Frontend
 @filename  new_game.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      17.01.2021 21:01:18 -04
]]

--- I show the games of a collection in a table
-- @param name string: the collection name
function populate_games (name)
	local sql = [[
		select games.name
			from collections
		join games on (collections.id_collection = games.id_collection)
		where collections.name = %s order by games.id_game desc;
	]]
	local games = db:get_rows(sql, name)

	for _, item in ipairs(games) do
		ui.games_liststore:append({
			item.name or 'No Games Found'
		})
	end
end

--- Clear fields
function clear_game_info ()
	ui.game_logo_preview.stock = 'gtk-missing-image'
	ui.btn_logo_game:unselect_all()
	ui.game_name.text = ''
	ui.game_desc_buffer.text = ''
	ui.btn_file_rom:unselect_all()
end

--- Edit game by name
-- @param name string: the game name
function edit_game (name)
	local sql = [[
		select games.id_game, games.logo, games.name,
		games.description, games.rom
			from collections
		join games on (games.id_collection = collections.id_collection)
		where games.name = %s;
	]]
	local game = db:get_rows(sql, name)[1]

	if game.logo ~= nil and game.logo ~= '' then
		local logo = solus:decode_image(game.logo)
		ui.game_logo_preview.pixbuf = logo
	else
		ui.game_logo_preview.stock = 'gtk-missing-image'
	end
	ui.game_name.text = game.name
	ui.game_desc_buffer.text = game.description or 'nil'
	ui.btn_file_rom:set_filename(game.rom)
end

-- @FIXME: esto no va aqui
--- Encode image file to base64
-- @param filename string: the file name
function solus:encode_image (filename)
	if (not filename) then
		return false, 'ERROR: filename not found'
	end
	local dir_img = filename
	local file = io.open(dir_img, 'rb')
	local image_file = file:read('*a')
	local image_b64 = base64.encode(image_file)
	return image_b64
end

-- @FIXME: esto no va aqui
--- Decode image base64
-- @param image_b64 string: the image base64
-- @param width number: width size
-- @param height number: height size
function solus:decode_image (image_b64, width, height)
	if (not image_b64) then
		return false, 'ERROR: image_b64 not found'
	end
	local width, height = width or 200, height or 150

	local image_decode = base64.decode(image_b64)
	local stream = Gio.MemoryInputStream.new_from_data(image_decode)
	local image	= GdkPixbuf.Pixbuf.new_from_stream(stream)
	image = image:scale_simple(width, height, 'BILINEAR')
	return image
end

function ui.btn_logo_game:on_selection_changed ()
	if ui.btn_logo_game:get_filename() then
		local image_b64 = solus:encode_image(ui.btn_logo_game:get_filename())
		local image = solus:decode_image(image_b64)
		ui.game_logo_preview:set_from_pixbuf(image)
	end
end

--- Validation of the fields
-- @return boolean: true whether the validation was successful
-- or false in the opposite case
-- @return msg string: response message
function validate_game ()
	local msg
	if (utils:trim(ui.game_name.text) == '') then
		msg = 'The name of the game is a required field.'
		ui.game_name:grab_focus()
	elseif (utils:trim(ui.game_desc_buffer.text) == '') then
		msg = 'The description is a required field.'
		ui.game_desc:grab_focus()
	elseif (ui.btn_file_rom:get_filename() == nil) then
		-- @TODO: buscar una manera de enfocar btn_file_rom
		msg = 'The game rom is a required field.'
	end
	if (msg) then
		return false, msg
	end
	return true
end

--- Save game, if the argument name exists
-- the game is updated
-- @param name string: the game name
-- @return boolean: true if the query was executed or
-- false in the opposite case
-- @return msg string: response message
function save_game ()
	local sql, msg, logo_default, logo

	local collection_name = solus:get_row_name(ui.collections_view)
	local game_name = solus:get_row_name(ui.games_view)

	if game_name then
		sql = "select logo from games where name = %s"
		logo_default = db:get_var(sql, game_name)
	end
	logo = solus:encode_image(
		ui.btn_logo_game:get_filename()
	) or logo_default or ''

	local values = {
		logo,
		ui.game_name.text,
		ui.game_desc_buffer.text,
		ui.btn_file_rom:get_filename()
	}

	sql = 'select id_collection from collections where name = %s'
	local id_collection = db:get_var(sql, collection_name)

	local validate, err = validate_game()
	if (not validate) then
		return false, err
	end

	if (collection_name) and (game_name) then
		sql = [[
			update games set logo = %s, name = %s, description = %s, rom = %s
			where name = %s
		]]
		table.insert(values, game_name)
		msg = 'Successfully updated game!'
	elseif (collection_name) then
		sql = [[
			insert into games (
				logo, name, description, rom, id_collection
			) values (%s, %s, %s, %s, %d)
		]]
		table.insert(values, id_collection)
		msg = 'Successfully registered game!'
	end

	local ok, err = db:execute(sql, values)
	if (not ok) then
		return false, err
	end

	ui.games_liststore:clear()
	populate_games(collection_name)
	return true, msg
end

--- By clicking on a column
function ui.games_view:on_row_activated ()
	local game_name = solus:get_row_name(ui.games_view)
	ui.forms:set_visible_child_name('new_game')
	edit_game(game_name)
end

--- When doing a search
function ui.search_games:on_changed ()
	local search = ui.search_games.text
end

--- By pressing the button (new game)
function ui.btn_new_game:on_clicked ()
	local selection = ui.games_view:get_selection()
	selection.mode = 'SINGLE'
	selection:unselect_all()
	clear_game_info()
	ui.forms:set_visible_child_name('new_game')
end
