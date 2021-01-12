--[[
          _                     _     _
         | |   _   _  __ _  ___| |__ (_)
         | |  | | | |/ _` |/ __| '_ \| |
         | |__| |_| | (_| | (__| | | | |
         |_____\__,_|\__,_|\___|_| |_|_|
Copyright (c) 2020  Díaz  Víctor  aka  (Máster Vitronic)
<vitronic2@gmail.com>   <mastervitronic@vitronic.com.ve>
]]--

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
function pagination:get_netx_page()
	return (self.page + 1)
end

---Retorna la pagina anterior
function pagination:get_prev_page()
	return (self.page - 1)
end

---Inicializa la clase seteando los parametros de inicio
--@param config tabla con la configuración
-- {records=1000,limit=10}
--
-- 'records' es el total de registros a paginar, 'limit' es
-- el limite de registros a mostrar por pagina
--@usage
--      local records = db:get_var('select count(id_account) from accounts')
--
--@usage
--	pagination:new({
--		records		= records,
--		limit		= 2,
--	})
function pagination:new(config)
	self.records	= tonumber(config.records)
	self.limit	= tonumber(config.limit)
	self.template	= config.template
	if (not config.template) then
		self.template	= {}
	end
	self.offset	= (self.limit*(self.page-1))
	self.pages	= self:get_pages()
	self.next_page 	= self:get_netx_page()
	self.prev_page 	= self:get_prev_page()
	if ( self.page >= self.pages ) then
		self.next_page = 1
	end
	if ( self.page == 1 ) then
		self.prev_page = self.pages
	end
	if ( self.offset > self.records ) then
		self.offset = self.records --@FIXME, esto esta mal
	end
	if ( self.page > self.pages ) then
		self.page = self.pages
	end
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
-- }
function pagination:get_pagination()
	return {
		page	   = self.page,
		pages	   = self.pages,
		prev_page  = self.prev_page,
		next_page  = self.next_page,
		limit	   = self.limit,
		offset	   = self.offset
	}
end

return pagination