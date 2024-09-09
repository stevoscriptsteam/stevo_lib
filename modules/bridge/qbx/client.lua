function stevo_lib.bridgeNotify(msg, type, duration)
	exports.qbx_core:Notify(msg, 'primary', duration)
end

function stevo_lib.GetPlayerGroups()
    local Player = exports.qbx_core:GetPlayerData()
    return Player.job.name, Player.gang.name
end

function stevo_lib.IsDead()
    playerData = exports.qbx_core:GetPlayerData()
    return playerData.metadata.isdead
end

function stevo_lib.GetSex()
    local Player = exports.qbx_core:GetPlayerData()
    return Player.charinfo.gender
end

function GetConvertedClothes(oldClothes)
    local clothes = {}
    local components = {
        ['arms'] = "arms",
        ['tshirt_1'] = "t-shirt", 
        ['torso_1'] = "torso2", 
        ['bproof_1'] = "vest",
        ['decals_1'] = "decals", 
        ['pants_1'] = "pants", 
        ['shoes_1'] = "shoes", 
        ['helmet_1'] = "hat", 
        ['chain_1'] = "accessory", 
    }
    local textures = {
        ['tshirt_1'] = 'tshirt_2', 
        ['torso_1'] = 'torso_2',
        ['bproof_1'] = 'bproof_2',
        ['decals_1'] = 'decals_2',
        ['pants_1'] = 'pants_2',
        ['shoes_1'] = 'shoes_2',
        ['helmet_1'] = 'helmet_2',
        ['chain_1'] = 'chain_2',
    }
    for k,v in pairs(oldClothes) do 
        local component = components[k]
        if component then 
            local texture = textures[k] and (oldClothes[textures[k]] or 0) or 0
            clothes[component] = {item = v, texture = texture}
        end
    end
    return clothes
end

function stevo_lib.SetOutfit(outfit) 
    if outfit then 
        TriggerEvent('qb-clothing:client:loadOutfit', {outfitData = GetConvertedClothes(outfit)})
    else 
        TriggerServerEvent("qb-clothes:loadPlayerSkin")
    end 
end


RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    TriggerEvent('stevo_lib:playerLoaded')
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
    PlayerData = val
end)