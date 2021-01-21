fx_version 'cerulean'
games { 'gta5' }

description 'thelindat esx_doorlock'
version '1.0.2'

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
