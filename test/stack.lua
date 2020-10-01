--[[--
 @package   Solus Frontend
 @filename  stack.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      21.07.2020 21:47:57 -04
]]

local new_section = function (widget,id,name)
	ui.section:add_titled(widget, id, name)
end

function ui.btn_new:on_clicked()
	ui.dialog_new_section:run()
	ui.dialog_new_section:hide()
end

function ui.dialog_new_section_cancel:on_clicked()
	ui.dialog_new_section:hide()
end

function ui.dialog_new_section_accept:on_clicked()
	if ui.dialog_new_section_entry_id ~= '' and ui.dialog_new_section_entry_name ~= ''  then
		new_section(Gtk.Box {
			Gtk.Label {
				label = ui.dialog_new_section_entry_name.text
			}
		},ui.dialog_new_section_entry_id.text,ui.dialog_new_section_entry_name.text)
	end
end
