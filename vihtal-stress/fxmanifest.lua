fx_version "adamant"
author 'Vihtal'

game "gta5"

server_script "server.lua"

client_script "client.lua"

exports {
    "AddStress",
    "RemoveStress"
}

shared_script '@es_extended/imports.lua'
