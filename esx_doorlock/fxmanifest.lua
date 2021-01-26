fx_version 'cerulean'
games { 'gta5' }

version '1.2.0'
description 'https://github.com/thelindat/esx_doorlock'

server_scripts {
	'@es_extended/locale.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'config.lua',
	'client/main.lua'
}

dependency 'es_extended'
