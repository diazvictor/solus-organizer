--[[--
 @package   Solus Frontend
 @filename  pagination.lua
 @version   1.0
 @author    Díaz Devera Víctor  aka  (Máster Vitronic) <vitronic2@gmail.com>
 @date      09.01.2021 23:54:15 -04
]]

------------------------------------------------------------------------
-- Pagination Luachi.
-- Esta clase permite la paginacion de lotes de datos
-- @classmod pagination
-- @author Máster Vitronic
-- @license GPL
-- @copyright 2020  Díaz  Víctor  aka  (Máster Vitronic)
------------------------------------------------------------------------

local pagination	= class('pagination')

---Setea la pagina actual, si no se le pasan
-- parametros sera seteado en la pagina 1
--@param page integer el numero de pagina
function pagination:set_page(page)
	self.page = tonumber(page) or 1
	return self.page
end

---Retorna el total de paginas
function pagination:get_pages()
	return math.ceil(self.records/self.limit)
end

---Retorna la pagina siguiente
function pagination:get_next_page()
	return (self.page + 1)
end

---Retorna la pagina anterior
function pagination:get_prev_page()
	return (self.page - 1)
end

---Inicializa la clase seteando los parametros de inicio
--@param config tabla con la configuración
-- {records=1000,limit=10,show_links=4}
--
-- 'records' es el total de registros a paginar, 'limit' es
-- el limite de registros a mostrar por pagina, y 'show_links'
-- es la cantidad de botones que se mostraran en el paginador
-- a la derecha e izquerda
--@usage
--      local records = db:get_var('select count(id_account) from accounts')
--
--@usage
--	pagination:new({
--		records		= records,
--		limit		= 2,
--		show_links	= 1,
--		template	= {
--			current = 'class="active"',
--			link 	= '<li><a %s href="/accounts/page/%s">%s</a></li>'
--		}
--	})
function pagination:new(config)
	self.records	= tonumber(config.records)
	self.limit	= tonumber(config.limit)
	self.show_links	= tonumber(config.show_links)
	self.template	= config.template
	if (not config.template) then
		self.template	= {}
	end
	self.offset	= (self.limit*(self.page-1))
	self.pages	= self:get_pages()
	self.next_page 	= self:get_next_page()
	self.prev_page 	= self:get_prev_page()
	if ( self.page >= self.pages ) then
		self.next_page = self.pages
	end
	if ( self.page == 1 ) then
		self.prev_page = nil
	end
	if ( self.offset > self.records ) then
		self.offset = self.records --@FIXME, esto esta mal
	end
	if ( self.page > self.pages ) then
		self.page = self.pages
	end
end

---Retorna los links de paginas
--@usage
-- local links = pagination:get_links()
-- common:print_r(links)
-- table: 0x55e998589280 {
--     [1] => "<li><a  href="/accounts/page/1">1</a></li>"
--     [2] => "<li><a  href="/accounts/page/2">2</a></li>"
--     [3] => "<li><a class="active" href="/accounts/page/3">3</a></li>"
--     [4] => "<li><a  href="/accounts/page/4">4</a></li>"
--     [5] => "<li><a  href="/accounts/page/5">5</a></li>"
-- }
function pagination:get_links()
	if (not self.template.link) then
		return {}, 'no template was found'
	end
	local begin,ending
	if((self.page-self.show_links) >= 1) then
		begin = (self.page-self.show_links)
		ending= (self.page+self.show_links)
	else
		begin = 1
		ending= (self.show_links*2)
	end
	local links = {}
	for page=begin,ending do
		local template,current = '',''
		if(page == self.page)then
			current = self.template.current or ''
		end
		template = (self.template.link):format(current,page,page)
		table.insert(links,template)
		if(page == self.pages) then
			break
		end
	end
	return links
end

---Retorna toda la informacion sobre la paginacion en curso
--@usage
-- pages = pagination:get_pagination()
-- common:print_r(pages)
-- table: 0x55e6c06a97a0 {
--   [offset] => 2
--   [prev_page] => 1
--   [limit] => 2
--   [pages] => 343
--   [next_page] => 3
--   [page] => 2
--   [links] => table: 0x55e6c06a97a0 {
--                [1] => "<li><a  href="/accounts/page/1">1</a></li>"
--                [2] => "<li><a class="active" href="/accounts/page/2">2</a></li>"
--                [3] => "<li><a  href="/accounts/page/3">3</a></li>"
--                [4] => "<li><a  href="/accounts/page/4">4</a></li>"
--              }
-- }
function pagination:get_pagination()
	return {
		page	   = self.page,
		pages	   = self.pages,
		prev_page  = self.prev_page,
		next_page  = self.next_page,
		links	   = self:get_links(),
		limit	   = self.limit,
		offset	   = self.offset
	}
end


return pagination

