resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX Door Lock'

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
