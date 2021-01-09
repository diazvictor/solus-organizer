--[[--
 @package   Solus Frontend
 @filename  gamelist.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      09.01.2021 15:10:32 -04
]]

local collections = {
	{
		name = 'Super Nintendo',
		shortname = 'snes',
		launch = 'snes9x-gtk',
		games = {
			{name = 'Super Mario World'},
			{name = 'Castlevania Dracula X'},
			{name = 'Contra III The Alien Wars'},
			{name = 'Donkey Kong Country 3 - Dixie Kong\'s Double Trouble'},
			{name = 'EarthBound'},
			{name = 'Kirby Super Star'},
			{name = 'Metal Warriors'},
			{name = 'The Legend of Zelda A Link to the Past'},
			{name = 'Super Ghouls\'N Ghost'}
		}
	}
}

populate_collection = function ()
	for _, collection in pairs(collections) do
		for i, game in pairs(collection.games) do
			ui.gamelist:insert(Gtk.FlowBoxChild {
				id = i,
				width = 100,
				height = 80,
				-- Gtk.Image {
					-- file = v.cover
				-- }
				Gtk.Label {
					label = utils:truncate(game.name, 21)
				}
			}, i)
		end
	end
end
populate_collection()

ui.gamelist['on_child_activated'] = function (self, flowboxchild)
	ui.section:set_visible_child_name('gameinfo')
end
