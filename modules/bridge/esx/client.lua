local ESX = exports.es_extended:getSharedObject()
local Config = lib.require('config')
local isDead


function stevo_lib.bridgeNotify(msg, type, duration)
	ESX.ShowNotification(msg, type, duration)
end

function stevo_lib.GetPlayerGroups()
    local PlayerData = ESX.GetPlayerData()
    return PlayerData.job.name, false
end

function stevo_lib.IsDead()
    return isDead
end

AddEventHandler('esx:onPlayerSpawn', function(noAnim)
    isDead = nil
end)

AddEventHandler('esx:onPlayerDeath', function(data)
    isDead = true
end)
		
RegisterNetEvent('esx:playerLoaded', function()
    TriggerEvent('stevo_lib:playerLoaded')
end)




