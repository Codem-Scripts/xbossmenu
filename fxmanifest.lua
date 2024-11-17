fx_version 'adamant'
game 'gta5'
version '1.5.0'
author 'CodeM Team'
description 'Codem-xBossMenu'

shared_scripts {
    'shared/*.lua',
    '@ox_lib/init.lua',
}

client_scripts {
    'client/main.lua',
    'client/editable.lua'
}

server_scripts {
    -- '@mysql-async/lib/MySQL.lua', --⚠️PLEASE READ⚠️; Uncomment this line if you use 'mysql-async'.⚠️
    '@oxmysql/lib/MySQL.lua', --⚠️PLEASE READ⚠️; Uncomment this line if you use 'oxmysql'.⚠️
    'server/main.lua',
    'server/editable.lua',
}

ui_page 'ui/app.html'

files {
    'ui/*.js',
    'ui/*.html',
    'ui/*.css',
    'ui/*.json',
    'ui/img/*.png',
    'ui/font/*.ttf'
}

escrow_ignore {
    'shared/*.lua',
    'server/editable.lua',
    'client/editable.lua',
    'client/*.lua',
    'server/*.lua'
}

lua54 'yes'