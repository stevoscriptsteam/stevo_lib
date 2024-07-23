local ESX = exports.es_extended:getSharedObject()
local Config = lib.require('config')


function stevo_lib.bridgeNotify(msg, type, duration)
	ESX.ShowNotification(msg, type, duration)
end

function stevo_lib.GetPlayerGroups()
    local PlayerData = ESX.GetPlayerData()
    return PlayerData.job.name, false
end
		
RegisterNetEvent('esx:playerLoaded', function()
    TriggerEvent('stevo_lib:playerLoaded')
end)




