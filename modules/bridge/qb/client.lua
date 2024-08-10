local QBCore = exports['qb-core']:GetCoreObject()
local Config = lib.require('config')

function stevo_lib.bridgeNotify(msg, type, duration)
	QBCore.Functions.Notify(msg, 'primary', duration)
end

function stevo_lib.GetPlayerGroups()
    local Player = QBCore.Functions.GetPlayerData()
    return Player.job.name, Player.gang.name
end

function stevo_lib.IsDead()
    playerData = QBCore.Functions.GetPlayerData()
    return playerData.metadata.isdead
end


RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    TriggerEvent('stevo_lib:playerLoaded')
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
    PlayerData = val
end)