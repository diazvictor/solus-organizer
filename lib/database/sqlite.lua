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
-- SQLite Luachi.
-- Esta clase de abstracción de base de datos contiene metodos para
-- la manipulacion facil de SQLite
-- @classmod sqlite
-- @author Máster Vitronic
-- @license GPL
-- @copyright 2020  Díaz  Víctor  aka  (Máster Vitronic)
------------------------------------------------------------------------

local db	= class('db')
--@see http://lua.sqlite.org/index.cgi/doc/tip/doc/lsqlite3.wiki
local sqlite3   = require('lsqlite3')

---Abre una nueva conexion, si ya existe entonces
-- devuelve la existente
function db:open()
	if self.db and self.db:isopen() then
		return self.db
	else
		local db = ('%s'):format(db_file)
		self.db = assert(sqlite3.open(db))
		local sql = 'PRAGMA foreign_keys = on'
		local connect = self.db:exec(sql)
		return (connect == 0)
	end
end

---retorna todo el objeto db
function db:raw()
    return self.db
end

---cierra la conexion
function db:close()
    self.db:close()
end

------------------------------------------------------------------------
--- Ejecuta un query
-- @param sql el query a ser ejecutado
-- @param func
-- @param udata
-- @return boolean: true si fue exitoso, false en caso contrario
------------------------------------------------------------------------
function db:exec(sql,func,udata)
	return (self.db:exec(sql,func,udata) == 0)
end

------------------------------------------------------------------------
--- Esta funcion retorna el ultimo rowid de la mas reciente
-- sentencia 'INSERT into' en la base de datos.
-- @return integer: el ultimo rowid
------------------------------------------------------------------------
function db:last_insert_rowid()
	return self.db:last_insert_rowid()
end

------------------------------------------------------------------------
--- Ejecuta una consulta y retorna toda la data en una tabla
-- @param sql string: el query a ser ejecutado
-- @return table: las columnas con el resultado
------------------------------------------------------------------------
function db:get_results(sql)
    local result = {}
    local stmt = self.db:prepare(sql)
    if (stmt) then
	    for row in stmt:nrows() do
		table.insert(result,row)
	    end
	    stmt:finalize()
    end
    return result
end

------------------------------------------------------------------------
--- retorna una version limpia y desinfectada de la entrada
-- (version para la base de datos)
-- @param s string
-- @return string: desinfectados
------------------------------------------------------------------------
function db:escape(str)
	if (type(str) == 'number' ) then
		return str
	end
	return (string.gsub (
		string.gsub (str:gsub("'", "''"),"%s+$", ""), "^%s+", "")
	)
end

------------------------------------------------------------------------
--- This function creates a callback function
--@param name is a string with the name of the callback
-- function as given in an SQL statement
--@param nargs is the number of arguments this call will provide
--@param func is the actual Lua function that gets
-- called once for every row
------------------------------------------------------------------------
function db:create_function(name, nargs, func)
	return self.db:create_function(name,nargs,func)
end

return db
