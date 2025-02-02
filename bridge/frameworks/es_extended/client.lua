local ESX = exports.es_extended:getSharedObject()
local PlayerData = ESX.GetPlayerData()
local isDead


function stevo_lib.bridgeNotify(msg, type, duration)
    ESX.ShowNotification(msg, type, duration)
end

function stevo_lib.GetPlayerGroups()
    return PlayerData.job.name, false
end

function stevo_lib.GetPlayerGroupInfo()
    local jobInfo = {
        name = PlayerData.job.name,
        grade = PlayerData.job.grade,
        label = PlayerData.job.label
    }
    
    return jobInfo
end

function stevo_lib.GetSex()
    return PlayerData.sex == 'Male' and 1 or 2
end

function stevo_lib.IsDead()
    return isDead
end

function stevo_lib.SetOutfit(outfit) 
    if outfit then 
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            TriggerEvent('skinchanger:loadClothes', skin, outfit)
        end)
    else 
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            TriggerEvent('skinchanger:loadSkin', skin)
        end)
    end 
end


AddEventHandler('esx:onPlayerSpawn', function(noAnim)
    isDead = nil
end)

RegisterNetEvent('esx:setJob', function(job)
    PlayerData.job = job
end)

AddEventHandler('esx:onPlayerDeath', function(data)
    isDead = true
    TriggerEvent('stevo_lib:playerDied')
end)
		
RegisterNetEvent('esx:playerLoaded', function()
    PlayerData = ESX.GetPlayerData()
    TriggerEvent('stevo_lib:playerLoaded')
end)