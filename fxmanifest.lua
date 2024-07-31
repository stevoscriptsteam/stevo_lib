fx_version 'cerulean'
game 'gta5'
use_experimental_fxv2_oal 'yes'
lua54 'yes'

author "Stevo Scripts | steve"
description 'A library of functions & a bridge for Stevo Scripts resources.'
version '1.1.0'

shared_script {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'modules/init/client.lua',
    'modules/resource/customize.lua'
}

server_scripts {
    'modules/init/server.lua',
    '@oxmysql/lib/MySQL.lua'
}


files {
    'modules/bridge/**/*.lua',
    'modules/targets/*.lua',
}

dependencies {
    'ox_lib',
    'oxmysql'
}