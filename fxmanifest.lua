fx_version 'cerulean'
game 'gta5'

description 'QBCore Example Manifest'
version '1.0.0'

lua54 'yes'

shared_script {
    'config.lua'
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}
