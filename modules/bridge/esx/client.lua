local ESX = exports.es_extended:getSharedObject()
local isDead
local PlayerData = ESX.GetPlayerData()

function stevo_lib.bridgeNotify(msg, type, duration)
	ESX.ShowNotification(msg, type, duration)
end

function stevo_lib.GetPlayerGroups()
    return PlayerData.job.name, false
end

function stevo_lib.IsDead()
    return isDead
end

AddEventHandler('esx:onPlayerSpawn', function(noAnim)
    isDead = nil
end)

RegisterNetEvent('esx:setJob', function(job)
    PlayerData.job = job
end)

AddEventHandler('esx:onPlayerDeath', function(data)
    isDead = true
end)
		
RegisterNetEvent('esx:playerLoaded', function()
    TriggerEvent('stevo_lib:playerLoaded')
end)




