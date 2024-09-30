fx_version 'cerulean'
game 'gta5'
use_experimental_fxv2_oal 'yes'
lua54 'yes'

author "Stevo Scripts | steve"
description 'A library of functions & a bridge for Stevo Scripts resources.'
version '1.6.9'

shared_script {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'init/client.lua',
    'customize.lua',
    'modules/functions/client.lua',
    --'modules/skills/client.lua',
}

server_scripts {
    'init/server.lua',
    'modules/functions/server.lua',
    --'modules/skills/server.lua',
    '@oxmysql/lib/MySQL.lua'
}

files {
    'modules/bridge/**/*.lua',
    'modules/targets/*.lua',
    'locales/*.json'
}

dependencies {
    'ox_lib',
    'oxmysql'
}
