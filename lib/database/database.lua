--[[
          _                     _     _
         | |   _   _  __ _  ___| |__ (_)
         | |  | | | |/ _` |/ __| '_ \| |
         | |__| |_| | (_| | (__| | | | |
         |_____\__,_|\__,_|\___|_| |_|_|
Copyright (c) 2020  Díaz  Víctor  aka  (Máster Vitronic)
<vitronic2@gmail.com>   <mastervitronic@vitronic.com.ve>
]]--

local database	= class('database')
local db,config,sql

------------------------------------------------------------------------
-- Clase minimalista de abstracción a la base de datos.
-- Esta clase de abstracción de base de datos contiene metodos para
-- la manipulacion facil de la base de datos
-- @classmod database
-- @author Máster Vitronic
-- @license GPL
-- @copyright 2020  Díaz  Víctor  aka  (Máster Vitronic)
------------------------------------------------------------------------

---conexion a la base de datos segun la configuracion
function database:open()
	db = require("database.sqlite");
	local ok,err = db:open()
	if (ok) then
		self.db = db
		return true
	end
	return false, err
end

------------------------------------------------------------------------
--- Retorna el objeto de la db
------------------------------------------------------------------------
function database:dump()
    return self.db:raw()
end

------------------------------------------------------------------------
--- Cierra la conexion
------------------------------------------------------------------------
function database:close()
    self.db:close()
end

------------------------------------------------------------------------
--- Inicia una transaccion
------------------------------------------------------------------------
function database:begin()
	return self.db:exec('begin;')
end

------------------------------------------------------------------------
--- Finaliza una transaccion
------------------------------------------------------------------------
function database:commit()
	return self.db:exec('commit;')
end

------------------------------------------------------------------------
--- Rolback a una transaccion
------------------------------------------------------------------------
function database:rollback()
	return self.db:exec('rollback;')
end

------------------------------------------------------------------------
--- Retorna la ultima sentencia SQL ejecutada
------------------------------------------------------------------------
function database:last_query()
	return sql
end

------------------------------------------------------------------------
--- Esta funcion retorna el ultimo rowid de la mas reciente
-- sentencia 'INSERT into' en la base de datos.
-- @return integer: el ultimo rowid
------------------------------------------------------------------------
function database:last_insert_rowid()
	return self.db:last_insert_rowid()
end

------------------------------------------------------------------------
--- Analiza un query y lo retorna saneado
------------------------------------------------------------------------
local function sanity_query(query)
	if ( string.find(query, "'") ) then
		return nil, 'Invalid query'
	end
	return ((query):gsub('%%s', "'%1'")):gsub('%%S','%%s')
end

------------------------------------------------------------------------
--- Crea un query
------------------------------------------------------------------------
unpack = unpack or table.unpack
local function query(...)
	local args={...}
	if ( #args == 0 or type(args[1]) ~= 'string' ) then
		return false, 'firts argument is not valid query'
	elseif ( type(args[2]) == 'table' ) then
		sql, err = sanity_query(args[1])
		if not sql then
			return false, err
		end
		for index,value in pairs(args[2]) do
			args[2][index] = database:escape(value)
		end
		sql = (sql):format(unpack(args[2]))
	else
		sql, err = sanity_query(args[1])
		if not sql then
			return false, err
		end
		table.remove(args,1)
		for index,value in pairs(args) do
			args[index] = database:escape(value)
		end
		sql = string.format(sql,unpack(args))
	end
	return sql
end

------------------------------------------------------------------------
--- Ejecuta una consulta y retorna toda la data en una tabla
-- @param sql string: el query a ser ejecutado
-- @return table: las columnas con el resultado
------------------------------------------------------------------------
function database:get_results(...)
	local args={...}
	sql, err = query(...)
	if not sql then
		return false, err
	end
	return self.db:get_results(sql)
end

------------------------------------------------------------------------
--- Ejecuta una consulta y retorna el primer valor
-- encontrado si no se le pasa la clausula where
-- @param sql string: la consulta a ejecutar
-- @return mixed: el resultado
------------------------------------------------------------------------
function database:get_var(...)
	local result
	local results, err = self:get_results(...)
	if not results then
		return false, err
	end
	if next(results) then
		for _,value in pairs(results[1]) do
			result = value
		end
	end
	return result
end

------------------------------------------------------------------------
--- Ejecuta una consulta y retorna el resultado
-- en un array asociativo campo=>valor
-- @param sql string: la consulta a ejecutar
-- @return table : el resultado
------------------------------------------------------------------------
function database:get_rows(...)
	local result = {}
	local results, err = self:get_results(...)
	if not results then
		return false, err
	end
	if next(results) then
		for index,value in pairs(results) do
			result[index] = value
		end
	end
	return result
end

------------------------------------------------------------------------
--- retorna una version limpia y desinfectada de la entrada
-- @param str string
-- @return string: la entrada escapada
------------------------------------------------------------------------
function database:escape(str)
	return self.db:escape(str)
end

------------------------------------------------------------------------
--- Ejecuta el query
------------------------------------------------------------------------
function database:execute(...)
	local args={...}
	sql, err = query(...)
	if not sql then
		return false, err
	end
	return self.db:exec(sql)
end

return database
