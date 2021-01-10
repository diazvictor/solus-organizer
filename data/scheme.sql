/**!
 * @package		Solus Frontend
 * @filename	scheme.sql
 * @version		1.0
 * @autor		Díaz Urbaneja Víctor Diex Gamar <Sirkennov@outlook.com>
 * @contributor	Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 * @date		08.01.2021 19:25:59 -04
 */

pragma foreign_keys = on;

create table vendors (
	id_vendor 	integer primary key autoincrement,
	vendor		varchar not null
);

create table collections (
	id_collection 	integer primary key autoincrement,
	name			varchar not null,
	logo			text,
	shortname		varchar not null,
	description		varchar,
	launch			varchar,
	company			varchar
);

create table games (
	id_game 		integer primary key autoincrement,
	name			varchar not null,
	description		varchar,
	logo			text,
	id_collection 	integer not null,
	rom				varchar not null,
	last_time		datetime default (datetime('now','localtime')),
	id_vendor		integer default null,
	favorite		boolean not null default false,
	foreign key		(id_collection) references collections (id_collection ),
	foreign key		(id_vendor) references vendors (id_vendor ),
	unique 			(name, id_vendor)
);

create table average (
	id_game 	integer,
	created_at	datetime default (datetime('now','localtime'))
);
