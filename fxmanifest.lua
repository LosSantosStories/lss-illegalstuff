
fx_version   'cerulean'
lua54        'yes'
game         'gta5'

name 'lss-illegalstuff'

shared_script {
  '@es_extended/imports.lua',
  '@ox_lib/init.lua', 
  'config.lua'
}

server_script {
  '@oxmysql/lib/MySQL.lua',
  'server/*.lua'
}

client_scripts {
  'client/*.lua',
}

files {
    'locales/*.json'
}
