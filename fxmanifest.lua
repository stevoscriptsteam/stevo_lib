fx_version 'cerulean'
game 'gta5'
use_experimental_fxv2_oal 'yes'
lua54 'yes'

author "Stevo Scripts | steve"
description 'A library of functions & a bridge for Stevo Scripts resources.'
version '1.7.3'

shared_script {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'modules/init/client.lua',
    'modules/functions/client.lua',
    'customize.lua'
}

server_scripts {
    'modules/init/server.lua',
    'modules/functions/server.lua',
    '@oxmysql/lib/MySQL.lua'
}

files {
    'bridge/**/**/*.lua'
}

dependencies {
    'ox_lib',
    'oxmysql'
}
