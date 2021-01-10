--[[--
 @package   Solus Frontend
 @filename  pagination.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      09.01.2021 23:54:15 -04
]]

local pagination = class('pagination')

function pagination:new (widget)
	self.widget = widget
end

function pagination.get_pages ()
	local t = {}
	local sql = 'select shortname from collections'
	local pages = db:get_rows(sql)
	for id_collection, shortname in pairs(pages) do
		for _, v in pairs(shortname) do
			table.insert(t, v)
		end
	end
	return t
end

function pagination:set_page (page)
	self.page = tostring(page)
	return self.widget:set_visible_child_name(page)
end
function pagination:get_page ()
	return self.widget:get_visible_child_name()
end

function pagination:get_next_page()
	local current_page = pagination:get_page()
	if (current_page == 'page_current') then
		self.widget:set_visible_child_name('page_next')
	elseif (current_page == 'page_next') then
		self.widget:set_visible_child_name('page_prev')
	elseif (current_page == 'page_prev') then
		self.widget:set_visible_child_name('page_current')
	end
end

function pagination:get_prev_page()
	local current_page = pagination:get_page()
	if (current_page == 'page_current') then
		self.widget:set_visible_child_name('page_prev')
	elseif (current_page == 'page_prev') then
		self.widget:set_visible_child_name('page_next')
	elseif (current_page == 'page_next') then
		self.widget:set_visible_child_name('page_current')
	end
end

return pagination
