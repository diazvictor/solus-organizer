--[[--
 @package   Solus Frontend
 @filename  gamelist.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      09.01.2021 15:10:32 -04
]]

--- Show game list and logo
-- @param shortname string: shortname of collection
-- @return boolean: true
solus['show_games'] = function (id_collection)
	-- get info of game
	local sql = [[
		select games.id_collection,id_game,
		games.name,games.rom
			from games
		where id_collection = %d order by games.id_game asc
	]]
	local games = db:get_rows(sql, id_collection)
	for _, game in pairs(games) do
		ui.gamelist.child[game.id_collection]:insert(Gtk.FlowBoxChild {
			id = game.id_game,
			width = 200,
			height = 100,
			Gtk.Label {
				label = utils:truncate(game.name, 21)
			}
		}, game.id_game)
	end
end

--ui.gamelist_current['on_child_activated'] = function (self, flowboxchild)
	--solus.show_game_info(flowboxchild.id)
--end
