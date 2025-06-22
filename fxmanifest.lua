fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'unkki'
description 'small overlay protection for fiveguard'
version '1.0.1'

escrow_ignore 'config/config.lua'
escrow_ignore 'locales/**'
escrow_ignore 'whitelist.lua'


client_scripts {
  'client/main.lua',
}

server_scripts {
  'config/config.lua',
  'server/main.lua',
}

shared_scripts {
    'locales/*.lua',
    'config/whitelist.lua'
}

-- you can escrow this script if you want
