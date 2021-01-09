--[[--
 @package   Solus Frontend
 @filename  gameinfo.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      09.01.2021 17:14:18 -04
]]

ui.gameinfo_sidebar['on_row_activated'] = function ()
	if ui.btn_info_desc:is_selected() == true then
		ui.gameinfo_pages:set_visible_child_name('gameinfo_page_desc')
	elseif ui.btn_info_screen:is_selected() == true then
		ui.gameinfo_pages:set_visible_child_name('gameinfo_page_screen')
	elseif ui.btn_info_others:is_selected() == true then
		ui.gameinfo_pages:set_visible_child_name('gameinfo_page_others')
	end
end

ui.gameinfo_btn_back['on_clicked'] = function ()
	ui.section:set_visible_child_name('gamelist')
end
